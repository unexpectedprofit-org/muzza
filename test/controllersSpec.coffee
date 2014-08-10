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
            { then: (callback) -> callback([{products:[{id:1}]}, {products:[id:2]}]) }
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

    it 'should have functions set in scope', ->
      createController {storeID: 1}
      expect(scope.viewCart).toBeDefined()
      expect(scope.showMenu).toBeDefined()

    it "should redirect to the cart when user clicks the cart icon", ->
      inject ($state)->
        spyOn($state, 'go')
        createController({storeID: 1})
        scope.viewCart()
        expect($state.go).toHaveBeenCalledWith 'app.cart'

    it "should redirect to category menu when user clicks the category item", ->
      inject ($state)->
        spyOn($state, 'go')
        createController({storeID: 1})
        categoryId = 88
        scope.showMenu(categoryId)
        expect($state.go).toHaveBeenCalledWith 'app.category', {category:categoryId}

    it "should get all menu items", ->
      createController({storeID: 1})
      expect(scope.menu[0]).toEqual {products:[{id:1}]}
      expect(scope.menu[1]).toEqual {products:[{id:2}]}
      expect(ProductService.getMenu).toHaveBeenCalled()

    it 'should be mainMenu view', ->
      createController {storeID: 1}
      expect(scope.isMainMenu).toBeTruthy()

    describe 'when requested specific category id', ->

      it "should get only the menu items for an specific category", ->
        createController({category: 'PIZZA', storeID: 1})
        expect(ProductService.getMenu).toHaveBeenCalledWith(1, 'PIZZA')

      it 'should NOT be mainMenu view', ->
        createController({category: 'PIZZA', storeID: 1})
        expect(scope.isMainMenu).toBeFalsy()


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