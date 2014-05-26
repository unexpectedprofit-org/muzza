ddescribe "Pizzas", ->

  beforeEach ->
    module 'ionic'
    module 'Muzza.pizzas'
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


  isolatedScope = $scope = element = Pizza = pizza1 = pizza2 = pizza3 = undefined

  beforeEach ->
    inject (_Pizza_,$compile, $rootScope)->
      Pizza = _Pizza_
      $scope = $rootScope
      pizza1 = new Pizza
        id: 1
        desc: "Muzza"
        toppings: "Muzzarella / tomate / Aceitunas"
        price:
          base: 8000
          size:
            individual: 0
            chica: 1000
            grande: 2000
          dough:
            "a la piedra": 2
            "al molde": 3
      pizza2 = new Pizza
        id: 2,
        desc: "Fugazetta"
        toppings: "Muzzarella / Cebolla"
        price:
          base: 7500
          size:
            individual: 0
            chica: 1500
            grande: 2000
          dough:
            "a la piedra": 0
            "al molde": 0
      pizza3 = new Pizza
        id: 3
        desc: "Calabresa"
        toppings: "Muzzarella / Longaniza / Salsa"
        price:
          base: 5000
          size:
            individual: 0
            chica: 1000
            grande: 2000
          dough:
            "a la piedra": 0
            "al molde": 0

      $scope.menu = [
        id: 1
        desc: "Categ 1"
        products: [ pizza1, pizza2 ]
      ,
        id: 2
        desc: "Categ 2"
        products: [ pizza3 ]
      ]
      element = angular.element('<pizzas ng-model="menu"></pizzas>')
      $compile(element)($rootScope)
      $scope.$digest()
      isolatedScope = element.isolateScope()


  describe "When user gets to the menu", ->

    describe "init", ->

      it "should display the 3 products listed on the menu", ->
        expect(element.find('ion-item').length).toBe 3

        expect(isolatedScope.menu[0].products[0] instanceof Pizza).toBeTruthy()
        expect(isolatedScope.menu[0].products[0]).toBe pizza1

        expect(element.html()).toContain 'Muzza'
        expect(element.html()).toContain 'Muzzarella / tomate / Aceitunas'

        expect(element.html()).toContain 'Fugazetta'
        expect(element.html()).toContain 'Muzzarella / Cebolla'

        expect(element.html()).toContain 'Calabresa'
        expect(element.html()).toContain 'Muzzarella / Longaniza / Salsa'

      it "should display the 2 categories", ->
        divs = element.find('div')

        expect(divs[2].innerHTML).toContain "Categ 1"
        expect(divs[4].innerHTML).toContain "Categ 2"

      it "should have a click function bind", ->
        onClickEvent = element.find('ion-item')[0].attributes['data-ng-click'].nodeValue
        expect(onClickEvent).toContain "choose(prod)"

      it "should have steps defined in the scope", ->
        expect(isolatedScope.steps).toEqual ['order', 'dough', 'size']

      it "should load the templates for all the steps", ->
        isolatedScope.steps = ['size', 'dough']
        expect(isolatedScope.size).toBeDefined()
        expect(isolatedScope.dough).toBeDefined()
        expect(isolatedScope.order).toBeDefined()

      it "should have a product defined in the scope", ->
        expect(isolatedScope.pizza).toBeDefined()

      it "should have a choose function defined in the scope", ->
        expect(isolatedScope.choose).toBeDefined()

    describe "When user chooses a product", ->

      it "should show all modals for available steps", ->
        isolatedScope.steps = ['order', 'dough', 'size']
        showOrder = spyOn(isolatedScope.order, 'show').and.callFake( ()-> 1 )
        showSize = spyOn(isolatedScope.size, 'show').and.callFake( ()-> 1 )
        showDough = spyOn(isolatedScope.dough, 'show').and.callFake( ()-> 1 )
        element.find('ion-item')[0].click()

        expect(showOrder).toHaveBeenCalled()
        expect(showOrder.calls.count()).toBe 1
        expect(showSize).toHaveBeenCalled()
        expect(showSize.calls.count()).toBe 1
        expect(showDough).toHaveBeenCalled()
        expect(showDough.calls.count()).toBe 1

      it 'should create a Pizza model from the item picked form the menu', ->
        element.find('ion-item')[0].click()
        expect(isolatedScope.pizza instanceof Pizza).toBeTruthy()

      it "should replace the previous selection", ->
        spyOn(isolatedScope.size, 'show').and.callFake( ()-> 1 )
        spyOn(isolatedScope.dough, 'show').and.callFake( ()-> 1 )

        #Choose First Product
        element.find('ion-item')[0].click()
        isolatedScope.pizza.size = 'b'
        isolatedScope.pizza.dough = 'a'

        #Choose Second Product
        element.find('ion-item')[1].click()

        expect(isolatedScope.pizza).not.toEqual pizza2
        expect(isolatedScope.pizza).toEqual jasmine.objectContaining
          desc : 'Fugazetta'
          id : 2

  describe "when system requests the menu an specific item view", ->

    ShoppingCartService = $stateParams = getItemSpy = undefined

    beforeEach ->
      inject (_$stateParams_, _ShoppingCartService_, $rootScope) ->
        ShoppingCartService = _ShoppingCartService_
        $stateParams = _$stateParams_

    describe "and the item is a pizza", ->

      beforeEach ->
        inject ($compile, $rootScope, $stateParams, $state) ->
          getItemSpy = spyOn(ShoppingCartService, 'get').and.returnValue(new Pizza({ id: 1, desc: "Muzza", cat: 'PIZZA', totalPrice: 60, price: {base:50} }))
          $stateParams.pizzaId = 1
          element = angular.element('<pizzas ng-model="menu"></pizzas>')
          $compile(element)($rootScope)
          $scope.$digest()
          isolatedScope = element.isolateScope()


      it "should retrieve the item from the shopping cart", ->
        expect(getItemSpy).toHaveBeenCalled()

      it 'should copy the item from the shopping cart into a new one to avoid resetting the price on cart item', ->
        cartItem = ShoppingCartService.get $stateParams.pizzaId
        expect(cartItem).not.toEqual isolatedScope.pizza

      it "should reset the items price to the base price", ->
        expect(isolatedScope.pizza.totalPrice).toBe 50

    describe "and the item is not a pizza", ->

      beforeEach ->
        inject ($rootScope, $compile) ->
          $stateParams.pizzaId = undefined
          $stateParams.empanadaId = 2
          getItemSpy = spyOn(ShoppingCartService, 'get').and.returnValue({ id: 2, desc: "Other", cat: 'Other', totalPrice: 60, price: {base:50} })
          element = angular.element('<pizzas ng-model="menu"></pizzas>')
          $compile(element)($rootScope)
          $scope.$digest()
          isolatedScope = element.isolateScope()

      it "should not retrieve the product", ->
        expect(getItemSpy).not.toHaveBeenCalled()