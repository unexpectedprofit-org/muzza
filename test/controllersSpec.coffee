describe "controllers", ->

  beforeEach ->
    module 'ionic'
    module "Muzza.controllers"
    module "Muzza.templates"

  describe "Menu Controller", ->

    scope = rootScope = ProductService = createController = ShoppingCartService = undefined

    beforeEach ->
      module ($provide) ->
        $provide.value 'ProductService',
          getMenu: ()->
            { pizza:[products:{id:1}], empanada:[products:{id:2}] }
        null
        $provide.value 'ShoppingCartService',
          getTotalPrice: () -> 100
          add: () -> null
        null

    beforeEach ->
      inject ($controller, $rootScope, _ProductService_, $stateParams, _ShoppingCartService_) ->

        ProductService = _ProductService_
        ShoppingCartService = _ShoppingCartService_
        spyOn(ProductService, 'getMenu').and.callThrough()
        scope = $rootScope.$new()
        rootScope = $rootScope
        createController = (params)->
          $controller "MenuCtrl",
            $scope: scope
            $stateParams: params
            $rootScope: $rootScope
            ShoppingCartService: ShoppingCartService

    it "should redirect to the cart when user clicks the cart icon", ->
      inject ($state)->
        spyOn($state, 'go')
        createController({storeID: 1})
        scope.viewCart()
        expect($state.go).toHaveBeenCalledWith 'app.cart'


    it "should get all menu items", ->
      createController({storeID: 1})
      expect(scope.menu.pizza).toEqual [{products:{id:1}}]
      expect(scope.menu.empanada).toEqual [{products:{id:2}}]
      expect(ProductService.getMenu).toHaveBeenCalled()

    it "should get only the menu items for an specific category", ->
      createController({category: 'PIZZA', storeID: 1})
      expect(ProductService.getMenu).toHaveBeenCalledWith(1, 'PIZZA')

    it "should call cart to get price", ->
      getPriceSpy = spyOn(ShoppingCartService, 'getTotalPrice').and.callThrough()
      createController({})
      expect(getPriceSpy).toHaveBeenCalled()

    it "should update the price when event is fired", ->
      createController({})
      rootScope.$broadcast 'CART:PRICE_UPDATED', 1200

      expect(scope.cartTotalPrice).toBe 1200


    describe "setCurrentOptionsSelectedForDisplay functionality", ->

      beforeEach ->
        createController {}

      it "should set values for only one single selection", ->

        product =
          options: [
            config:
              min:1
              max:1
            items:[
              description:"Coca"
            ,
              description:"Sprite"
            ,
              description:"Fanta"
            ]
            selection:[
              description:"Sprite"
            ]
          ]

        scope.setCurrentOptionsSelectedForDisplay product

        expect(product.options[0].items[0].isSelected).toBeFalsy()
        expect(product.options[0].items[1].isSelected).toBeTruthy()
        expect(product.options[0].items[2].isSelected).toBeFalsy()

      it "should set values for only one multiple selection", ->

        product =
          options: [
            config:
              min:1
              max:3
            items:[
              description:"Tomate"
            ,
              description:"Lechuga"
            ,
              description:"Huevo duro"
            ,
              description:"Jamon"
            ,
              description:"Queso"
            ]
            selection:[
              description:"Lechuga"
            ,
              description:"Jamon"
            ]
          ]

        scope.setCurrentOptionsSelectedForDisplay product

        expect(product.options[0].items[0].isSelected).toBeFalsy()
        expect(product.options[0].items[1].isSelected).toBeTruthy()
        expect(product.options[0].items[2].isSelected).toBeFalsy()
        expect(product.options[0].items[3].isSelected).toBeTruthy()
        expect(product.options[0].items[4].isSelected).toBeFalsy()

      it "should set values for one single + one multiple selection", ->

        product =
          options: [
            config:
              min:1
              max:1
            items:[
              description:"Coca"
            ,
              description:"Sprite"
            ,
              description:"Fanta"
            ]
            selection:[
              description:"Fanta"
            ]
          ,
            config:
              min:1
              max:3
            items:[
              description:"Tomate"
            ,
              description:"Lechuga"
            ,
              description:"Huevo duro"
            ,
              description:"Jamon"
            ,
              description:"Queso"
            ]
            selection:[
              description:"Tomate"
            ,
              description:"Queso"
            ]
          ]

        scope.setCurrentOptionsSelectedForDisplay product

        expect(product.options[0].items[0].isSelected).toBeFalsy()
        expect(product.options[0].items[1].isSelected).toBeFalsy()
        expect(product.options[0].items[2].isSelected).toBeTruthy()

        expect(product.options[1].items[0].isSelected).toBeTruthy()
        expect(product.options[1].items[1].isSelected).toBeFalsy()
        expect(product.options[1].items[2].isSelected).toBeFalsy()
        expect(product.options[1].items[3].isSelected).toBeFalsy()
        expect(product.options[1].items[4].isSelected).toBeTruthy()




    xdescribe "on event: PRODUCT_SELECTED_TO_BE_ADDED_TO_CART", ->

      beforeEach ->
        inject ($rootScope) ->
          createController({})
          product = {id:15}

          scope.chooseProduct product
          $rootScope.$broadcast 'PRODUCT_SELECTED_TO_BE_ADDED_TO_CART', product

      it "should close modal", ->
        expect(scope.productOptions.hide()).toHaveBeenCalled()

      it "should call service", ->
        addSpy = spyOn(ShoppingCartService, 'add').and.callThrough()
        expect(addSpy).toHaveBeenCalledWith {id:15}