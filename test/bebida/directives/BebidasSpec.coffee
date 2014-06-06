describe "Bebidas", ->

  beforeEach ->
    module 'ionic'
    module 'Muzza.bebidas'
    module 'Muzza.templates'
    module 'Muzza.directives'

  beforeEach ->
    module ($provide) ->
      $provide.value "ShoppingCartService",
        add: ()->
          return null
        getCart: ()->
          return null
        getTotalPrice: () ->
          return null
        get: ()->
          return null

      $provide.value "$state",
        go: () ->
          return null

      $provide.value "$stateParams",
        {}
      return null


  isolatedScope = $scope = element = Bebida = bebida1 = bebida2 = bebida3 = undefined

  beforeEach ->
    inject ($injector, $compile, $rootScope)->
      Bebida = $injector.get 'Bebida'
      $scope = $rootScope

      bebida1 = new Bebida
        id: 1
        desc: "Agua saborizada"
        price:
          base: 8000
          size:
            individual: 0
            chica: 1000
            grande: 2000
      bebida2 = new Bebida
        id: 2,
        desc: "Jugo exprimido"
        price:
          base: 7500
          size:
            individual: 0
            chica: 1500
            grande: 2000
      bebida3 = new Bebida
        id: 3
        desc: "agua mineral"
        price:
          base: 5000
          size:
            individual: 0
            chica: 1000
            grande: 2000

      $scope.menu = [
        id: 1
        desc: "Categ 1"
        products: [ bebida1, bebida2 ]
      ,
        id: 2
        desc: "Categ 2"
        products: [ bebida3 ]
      ]
      element = angular.element('<bebidas ng-model="menu"></bebidas>')
      $compile(element)($rootScope)
      $scope.$digest()
      isolatedScope = element.isolateScope()


  describe "When user gets to the menu", ->

    describe "init", ->

      it "should display the 3 products listed on the menu", ->
        expect(element.find('ion-item').length).toBe 3

        expect(isolatedScope.menu[0].products[0] instanceof Bebida).toBeTruthy()
        expect(isolatedScope.menu[0].products[0]).toBe bebida1

      it "should have a click function bind", ->
        onClickEvent = element.find('ion-item')[0].attributes['data-ng-click'].nodeValue
        expect(onClickEvent).toContain "choose(product)"

      it "should have steps defined in the scope", ->
        expect(isolatedScope.steps).toEqual ['order', 'size']
        expect(isolatedScope.stepsPromo).toEqual ['orderPromo', 'size']

      it "should load the templates for all the steps", ->
        isolatedScope.steps = ['order','size']
        expect(isolatedScope.size).toBeDefined()
        expect(isolatedScope.order).toBeDefined()
        expect(isolatedScope.orderPromo).toBeDefined()

      it "should have a product defined in the scope", ->
        expect(isolatedScope.bebidaSelection).toBeDefined()

      it "should have a functions defined in the scope", ->
        expect(isolatedScope.choose).toBeDefined()
        expect(isolatedScope.choosePromoItem).toBeDefined()

    describe "When user chooses a product", ->

      it "should show all modals for available steps", ->
        isolatedScope.steps = ['order', 'size']
        showOrder = spyOn(isolatedScope.order, 'show').and.callFake( ()-> 1 )
        showSize = spyOn(isolatedScope.size, 'show').and.callFake( ()-> 1 )
        element.find('ion-item')[0].click()

        expect(showOrder).toHaveBeenCalled()
        expect(showSize).toHaveBeenCalled()

      it 'should create a Bebida model from the item picked from the menu', ->
        element.find('ion-item')[0].click()
        expect(isolatedScope.bebidaSelection instanceof Bebida).toBeTruthy()

      it "should replace the previous selection", ->
        #Choose First Product
        element.find('ion-item')[0].click()
        isolatedScope.bebidaSelection.size = 'mediana'

        #Choose Second Product
        element.find('ion-item')[1].click()
        expect(isolatedScope.bebidaSelection).not.toEqual bebida1
        expect(isolatedScope.bebidaSelection).toEqual jasmine.objectContaining
          desc : 'Jugo exprimido'
          id : 2

  describe "when system requests the menu an specific item view", ->

    ShoppingCartService = $stateParams = getItemSpy = undefined

    beforeEach ->
      inject (_$stateParams_, _ShoppingCartService_, $rootScope) ->
        ShoppingCartService = _ShoppingCartService_
        $stateParams = _$stateParams_

    describe "and the item is a bebida", ->

      beforeEach ->
        inject ($compile, $rootScope, $stateParams, $state) ->
          getItemSpy = spyOn(ShoppingCartService, 'get').and.returnValue(new Bebida({id:1,desc: "Muzza",totalPrice:60,price:{base:50}}))
          $stateParams.bebidaId = 1
          element = angular.element('<bebidas ng-model="menu"></bebidas>')
          $compile(element)($rootScope)
          $scope.$digest()
          isolatedScope = element.isolateScope()


      it "should retrieve the item from the shopping cart", ->
        expect(getItemSpy).toHaveBeenCalled()

      it 'should copy the item from the shopping cart into a new one to avoid resetting the price on cart item', ->
        cartItem = ShoppingCartService.get $stateParams.bebidaId
        expect(cartItem).not.toEqual isolatedScope.bebidaSelection

      it "should reset the items price to the base price", ->
        expect(isolatedScope.bebidaSelection.totalPrice).toBe 50

    describe "and the item is not a bebida", ->

      beforeEach ->
        inject ($rootScope, $compile) ->
          $stateParams.bebidaId = undefined
          $stateParams.empanadaId = 2
          getItemSpy = spyOn(ShoppingCartService, 'get').and.returnValue({id:2,desc:"Other",cat:'Other',totalPrice:60,price:{base:50}})
          element = angular.element('<bebidas ng-model="menu"></bebidas>')
          $compile(element)($rootScope)
          $scope.$digest()
          isolatedScope = element.isolateScope()

      it "should not retrieve the product", ->
        expect(getItemSpy).not.toHaveBeenCalled()

  describe "when user selects an item from a promo", ->

    beforeEach ->
      inject ($injector, $compile, $rootScope)->
        Bebida = $injector.get 'Bebida'
        $scope = $rootScope

        bebida1 = new Bebida
          id: 1
          desc: "Agua saborizada"
          price:
            base: 8000
            size:
              individual: 0
              chica: 1000
              grande: 2000
        bebida2 = new Bebida
          id: 2,
          desc: "Jugo exprimido"
          price:
            base: 7500
            size:
              individual: 0
              chica: 1500
              grande: 2000
        bebida3 = new Bebida
          id: 3
          desc: "agua mineral"
          price:
            base: 5000
            size:
              individual: 0
              chica: 1000
              grande: 2000

        $scope.menu = [
          id: 1
          desc: "Categ 1"
          products: [ bebida1, bebida2 ]
        ,
          id: 2
          desc: "Categ 2"
          products: [ bebida3 ]
        ]
        element = angular.element('<bebidas ng-model="menu" nodetails="true"></bebidas>')
        $compile(element)($rootScope)
        $scope.$digest()
        isolatedScope = element.isolateScope()

    describe "init", ->

      it "should have a click function bind", ->
        onClickEvent = element.find('ion-item')[0].attributes['data-ng-click'].nodeValue
        expect(onClickEvent).toContain "choosePromoItem(product)"

      it "should have a product defined in the scope", ->
        expect(isolatedScope.bebidaSelection).toBeDefined()

    describe "When user chooses a product", ->

      it "should show all modals for available steps", ->
        isolatedScope.steps = ['orderPromo', 'size']
        showOrder = spyOn(isolatedScope.orderPromo, 'show').and.callFake( ()-> 1 )
        showSize = spyOn(isolatedScope.size, 'show').and.callFake( ()-> 1 )
        element.find('ion-item')[0].click()

        expect(showOrder).toHaveBeenCalled()
        expect(showSize).toHaveBeenCalled()

      it 'should create a Bebida model from the item picked from the menu', ->
        element.find('ion-item')[0].click()
        expect(isolatedScope.bebidaSelection instanceof Bebida).toBeTruthy()

      it "should replace the previous selection", ->
        #Choose First Product
        element.find('ion-item')[0].click()
        isolatedScope.bebidaSelection.size = 'mediana'

        #Choose Second Product
        element.find('ion-item')[1].click()
        expect(isolatedScope.bebidaSelection).not.toEqual bebida1
        expect(isolatedScope.bebidaSelection).toEqual jasmine.objectContaining
          desc : 'Jugo exprimido'
          id : 2