describe "Cart", ->

  beforeEach ->
    module 'Muzza.cart'
    module 'Muzza.templates'
    module 'Muzza.directives'
    module 'Muzza.pizzas'
    module 'Muzza.empanadas'
    module 'Muzza.bebidas'
    module 'ionic'

    module ($provide) ->

      $provide.value "ShoppingCartService",
        getCart: ()-> null
        getTotalPrice: () -> null
        removePromotion: () -> null

      $provide.value "$state",
        go: () -> null

      $provide.value "OrderService",
        createOrder: ()-> null

      return null

  $scope = element = ShoppingCartService = isolatedScope = Pizza = Empanada = Bebida = undefined
  pizza1 = pizza2 = undefined

  beforeEach ->
    inject ($compile, $rootScope, $injector) ->
      ShoppingCartService = $injector.get 'ShoppingCartService'
      Pizza = $injector.get 'Pizza'
      Empanada = $injector.get 'Empanada'
      Bebida = $injector.get 'Bebida'
      $scope = $rootScope
      element = angular.element('<cart></cart>')
      $compile(element)($rootScope)

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

  describe "init", ->

    it "should have functions defined", ->
      $scope.$digest()
      isolatedScope = element.isolateScope()

      expect(isolatedScope.edit).toBeDefined()
      expect(isolatedScope.remove).toBeDefined()
      expect(isolatedScope.checkout).toBeDefined()

    it "should have a cart defined", ->
      $scope.$digest()
      isolatedScope = element.isolateScope()

      expect(isolatedScope.cart).toBeDefined()


  describe 'when shopping cart has at least one item', ->

    it 'should list all items in the shopping cart', ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue [pizza1,pizza2]
      $scope.$digest()
      items = element.find('ion-item')
      expect(items.length).toBe 3

    it "should display items sorted by category - 1", ->
      empanada = new Empanada {desc:'Humita',qty:1,cat:'EMPANADA', price: {base: 2000}}

      spyOn(ShoppingCartService, 'getCart').and.returnValue [pizza1,empanada]
      $scope.$digest()
      items = element.find('ion-list').html()

      expect(items).toContain empanada.description()
      expect(items).toContain pizza1.description()

    it "should show total price", ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue [pizza1,pizza2]
      spyOn(ShoppingCartService, 'getTotalPrice').and.returnValue 1661

      $scope.$digest()
      expect(element.html()).toMatch(/Total \$16.61/)


    it 'should not display the empty msg', ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue [pizza1]
      $scope.$digest()
      msg = element.find('div.card').html()
      expect(msg).not.toMatch(/vacio/)

    it "should list items with edit function bound", ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue [pizza1]
      $scope.$digest()
      isolatedScope = element.isolateScope()
      isolatedScope.showEdit = true
      expect(element.find('ion-item').html()).toContain "$parent.edit(item)"

    it "should list items with remove function bound", ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue [pizza1]
      $scope.$digest()
      expect(element.find('ion-item').html()).toContain "$parent.remove(item.cartItemKey)"


  describe 'when shopping cart is empty', ->

#   NEED TO BE REVIEWED
    # xit "should NOT display buttons on header", ->
#      spyOn(ShoppingCartService, 'getCart').and.returnValue []
#      $scope.$digest()
#      buttons = element.find('button')
#
#      expect(buttons[0]).toBeHidden()
#      expect(buttons[1]).toBeHidden()

    it "should list no items", ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue []
      $scope.$digest()
      items = element.find('ion-item')
      expect(items.length).toBe 0

    it "should not display totalPrice", ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue []
      $scope.$digest()
      msg = element.find('ion-header-bar').html()
      expect(msg).not.toMatch(/0.00/)

    it 'should display the empty msg', ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue []
      $scope.$digest()
      items = element.find('ion-item')
      expect(element.html()).toMatch(/vacio/)
      expect(items.length).toBe 0

  describe 'when editting', ->

    describe "and hit edit button", ->

      it "should call the edit function with proper data", ->

        pizza1 = new Pizza {id:1, desc:'Muzza', qty:1, totalPrice: 10}
        pizza2 = new Pizza {id:2, desc:'Fugazzeta',qty:2, totalPrice:5}

        spyOn(ShoppingCartService, 'getCart').and.returnValue [pizza1, pizza2]
        $scope.$digest()
        isolatedScope = element.isolateScope()

        editItem = spyOn(isolatedScope, 'edit').and.callFake( () -> 1 )

        isolatedScope.edit(pizza1)
        expect(editItem).toHaveBeenCalledWith jasmine.objectContaining {id:1, desc:'Muzza', qty:1, totalPrice: 10}

    describe "edit function show redirect to proper view", ->

      onState = $mystate = undefined

      beforeEach ->
        inject ($state) ->
          $mystate = $state


      it "should redirect to PIZZA edit view", ->
        pizza = new Pizza {desc:'Muzza', qty:1,totalPrice: 1000,cat:'PIZZA', size:'chica', dough:'alala', id:1, price:{base:1000}, cartItemKey: 1}

        spyOn(ShoppingCartService, 'getCart').and.returnValue [pizza]
        $scope.$digest()
        isolatedScope = element.isolateScope()

        onState = spyOn($mystate, 'go').and.callFake( () -> 1 )
        editItem = spyOn(isolatedScope, 'edit').and.callThrough()

        isolatedScope.edit(pizza)
        expect(onState).toHaveBeenCalledWith 'app.pizza', {pizzaId:1}

      it "should redirect to BEBIDA edit view", ->
        bebida = new Bebida {desc:'Muzza',qty:1,totalPrice:1000,cat:'BEBIDA',size:"chica",id:1,price:{base:1000},cartItemKey: 1}

        spyOn(ShoppingCartService, 'getCart').and.returnValue [bebida]
        $scope.$digest()
        isolatedScope = element.isolateScope()

        onState = spyOn($mystate, 'go').and.callFake( () -> 1 )
        editItem = spyOn(isolatedScope, 'edit').and.callThrough()

        isolatedScope.edit bebida
        expect(onState).toHaveBeenCalledWith 'app.bebida', {bebidaId:1}

      it "should redirect to menu default view if no categ matches", ->

        spyOn(ShoppingCartService, 'getCart').and.returnValue [{hash: '45-newproduct',cat: 'NEW_CATEGORY'}]
        $scope.$digest()
        isolatedScope = element.isolateScope()

        onState = spyOn($mystate, 'go').and.callFake( () -> 1 )
        editItem = spyOn(isolatedScope, 'edit').and.callThrough()

        isolatedScope.edit({})
        expect(onState).toHaveBeenCalledWith 'app.menu'

  describe "remove functionality", ->

    it "should call service", ->

      spyOn(ShoppingCartService, 'getCart').and.returnValue [new Pizza {id:1, desc:'Muzza', qty:1}]
      $scope.$digest()
      isolatedScope = element.isolateScope()

      removeItem = spyOn(isolatedScope, 'remove').and.callFake( () -> 1 )

      isolatedScope.remove pizza1.cartItemKey
      expect(removeItem).toHaveBeenCalledWith pizza1.cartItemKey

  describe "when checkout", ->

    it "should redirect to delivery option", ->
      inject ($state)->
        spyOn(ShoppingCartService, 'getCart').and.returnValue [new Pizza {id:1, desc:'Muzza', qty:1}]
        spyOn($state, 'go').and.callThrough()
        $scope.$digest()
        isolatedScope = element.isolateScope()
        isolatedScope.checkout()

        expect($state.go).toHaveBeenCalledWith('app.order-delivery')

    it "should delegate to OrderService to create the order", ->
      inject (OrderService)->
        pizza = new Pizza {id:1, desc:'Muzza', qty:1}
        spyOn(ShoppingCartService, 'getCart').and.returnValue [pizza]
        spyOn(OrderService, 'createOrder')
        $scope.$digest()
        isolatedScope = element.isolateScope()

        isolatedScope.checkout()
        expect(OrderService.createOrder).toHaveBeenCalledWith jasmine.objectContaining
          products: [pizza]