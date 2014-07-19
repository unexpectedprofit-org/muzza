describe "Cart", ->

  beforeEach ->
    module 'Muzza.cart'
    module 'Muzza.templates'
    module 'Muzza.directives'
    module 'Muzza.product'
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
        checkEligibility: () -> null

      return null

  $scope = element = ShoppingCartService = isolatedScope = Product = undefined
  product1 = product2 = undefined

  beforeEach ->
    inject ($compile, $rootScope, $injector) ->
      ShoppingCartService = $injector.get 'ShoppingCartService'
      Product = $injector.get 'Product'
      $scope = $rootScope
      element = angular.element('<cart></cart>')
      $compile(element)($rootScope)

      product1 = new Product
        id: 1
        desc: "Carne Cortada a cuchillo"
        catId:55
        price:
          base: 8000
        options: [
          description: "Coccion"
          config:
            min:1
            max:1
          items: [
            description: "Frita"
          ,
            description: "Horno"
          ]
        ]
      product2 = new Product
        id: 2,
        desc: "Ensalada de la casa"
        catId:11
        price:
          base: 7500
        options: [
          description: "Ingredientes"
          config:
            min:1
            max:3
          items: [
            description: "Lechuga"
          ,
            description: "Tomate"
          ,
            description: "Hongos"
          ,
            description: "Zanahoria"
          ]
        ]

  describe "init", ->

    it "should have functions defined", ->
      $scope.$digest()
      isolatedScope = element.isolateScope()

      expect(isolatedScope.edit).toBeDefined()
      expect(isolatedScope.remove).toBeDefined()
      expect(isolatedScope.checkout).toBeDefined()

    it "should have variables defined", ->
      $scope.$digest()
      isolatedScope = element.isolateScope()

      expect(isolatedScope.cart).toBeDefined()
      expect(isolatedScope.orderEligibility).toBeDefined()


  describe 'when shopping cart has at least one item', ->

    it 'should list all items in the shopping cart', ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue [product1,product2]
      $scope.$digest()
      items = element.find('ion-item')
      expect(items.length).toBe 3

    it "should display items sorted by category - 1", ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue [product1,product2]
      $scope.$digest()
      items = element.find('ion-list').html()

      expect(items).toContain product1.getDescription()
      expect(items).toContain product2.getDescription()

    it "should display items sorted by category - 2", ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue [product2,product1]
      $scope.$digest()
      items = element.find('ion-list').html()

      expect(items).toContain product1.getDescription()
      expect(items).toContain product2.getDescription()

    it "should show total price", ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue [product1,product2]
      spyOn(ShoppingCartService, 'getTotalPrice').and.returnValue 1661

      $scope.$digest()
      expect(element.html()).toMatch(/Total \$16.61/)

    it 'should not display the empty msg', ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue [product1]
      $scope.$digest()
      msg = element.find('div.card').html()
      expect(msg).not.toMatch(/vacio/)

    it "should list items with edit function bound", ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue [product1]
      $scope.$digest()
      isolatedScope = element.isolateScope()
      isolatedScope.showEdit = true
      expect(element.find('ion-item').html()).toContain "$parent.edit(item.cartItemKey)"

    it "should list items with remove function bound", ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue [product1]
      $scope.$digest()
      expect(element.find('ion-item').html()).toContain "$parent.remove(item.cartItemKey)"

    it "should have edit functions set", ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue [product1,product2]
      $scope.$digest()

      expect(element.html()).toContain "item.isEditable().qty"
      expect(element.html()).toContain "item.isEditable().options"


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

        spyOn(ShoppingCartService, 'getCart').and.returnValue [product1, product2]
        $scope.$digest()
        isolatedScope = element.isolateScope()

        editItem = spyOn(isolatedScope, 'edit').and.callFake( () -> 1 )

        isolatedScope.edit product1
        expect(editItem).toHaveBeenCalledWith jasmine.objectContaining {id:product1.id}

    xdescribe "edit function show redirect to proper view", ->

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

      spyOn(ShoppingCartService, 'getCart').and.returnValue [product1]
      $scope.$digest()
      isolatedScope = element.isolateScope()

      removeItem = spyOn(isolatedScope, 'remove').and.callFake( () -> 1 )

      isolatedScope.remove product1.cartItemKey
      expect(removeItem).toHaveBeenCalledWith product1.cartItemKey

  describe "when checkout", ->

    $state = OrderService = undefined

    beforeEach ->
      inject (_$state_, _OrderService_)->
        $state = _$state_
        OrderService = _OrderService_
        spyOn(ShoppingCartService, 'getCart').and.returnValue [product1]
        spyOn($state, 'go').and.callThrough()
        spyOn(OrderService, 'createOrder')
        $scope.$digest()
        isolatedScope = element.isolateScope()
        isolatedScope.checkout()


    it "should redirect to delivery option", ->
      expect($state.go).toHaveBeenCalledWith('app.order-review')

    it "should delegate to OrderService to create the order", ->
      expect(OrderService.createOrder).toHaveBeenCalledWith jasmine.objectContaining
        products: [product1]

  describe "order eligibility", ->

    it "should call Order service", ->
      inject (OrderService) ->
        eligibilitySpy = spyOn(OrderService, 'checkEligibility').and.returnValue {}
        spyOn(ShoppingCartService, 'getCart').and.returnValue []
        $scope.$digest()
        isolatedScope = element.isolateScope()

        expect(eligibilitySpy).toHaveBeenCalled()
        expect(isolatedScope.orderEligibility).toBeDefined()

    it "should call Order service once cart has changed", ->
      inject (OrderService) ->
        eligibilitySpy = spyOn(OrderService, 'checkEligibility').and.returnValue {}
        spyOn(ShoppingCartService, 'getCart').and.returnValue []
        $scope.$digest()
        isolatedScope = element.isolateScope()

        $scope.$broadcast 'CART:PRICE_UPDATED', 1200

        expect(isolatedScope.orderEligibility).toBeDefined()
        expect(eligibilitySpy).toHaveBeenCalled()
        expect(eligibilitySpy.calls.count()).toBe 2

    it "should evaluate order eligibility on html", ->
      $scope.$digest()
      expect(element.html()).toContain "!orderEligibility.success"