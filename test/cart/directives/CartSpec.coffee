describe "Cart", ->

  beforeEach ->
    module 'Muzza.cart'
    module 'Muzza.templates'
    module 'Muzza.directives'
    module 'Muzza.pizzas'
    module 'Muzza.empanadas'
    module 'ionic'

    module ($provide) ->
      $provide.value "ShoppingCartService",
        getCart: ()->
          return null
        getTotalPrice: () ->
          return null
      return null
    module ($provide) ->
      $provide.value "$state",
        go: () ->
         return null
      return null

  $scope = element = ShoppingCartService = isolatedScope = Pizza = Empanada = undefined

  beforeEach ->
    inject ($compile, $rootScope, _ShoppingCartService_, _Pizza_, _Empanada_) ->
      ShoppingCartService = _ShoppingCartService_
      Pizza = _Pizza_
      Empanada = _Empanada_
      $scope = $rootScope
      element = angular.element('<cart></cart>')
      $compile(element)($rootScope)

  describe 'when shopping cart has at least one item', ->

    it 'should list all items in the shopping cart and the total price', ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue [new Pizza {id:1, desc:'Muzza', qty:1, totalPrice: 10},{id:2, desc:'Fugazzeta',qty:2, totalPrice:5}]
      $scope.$digest()
      items = element.find('ion-item')
      expect(items.length).toBe 2

    it 'should not display the empty msg', ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue [new Pizza {id:1, desc:'Muzza', qty:1, totalPrice: 10},{id:2, desc:'Fugazzeta',qty:2, totalPrice:5}]
      $scope.$digest()
      msg = element.find('div.card').html()
      expect(msg).not.toMatch(/vacio/)

    it "should show total price", ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue [new Pizza {id:1, desc:'Muzza', qty:1, totalPrice: 10},{id:2, desc:'Fugazzeta',qty:2, totalPrice:5}]
      spyOn(ShoppingCartService, 'getTotalPrice').and.returnValue 1211

      $scope.$digest()
      msg = element.find('ion-list').html()
      expect(msg).toMatch(/Total:/)
      expect(msg).toMatch(/12.11/)

    it "should display items sorted by category - 1", ->
      inject (Pizza, Empanada)->
        pizza = new Pizza {desc:'Muzza', qty:1,cat:'PIZZA', price: {base: 1000}}
        empanada = new Empanada {desc:'Humita',qty:1,cat:'EMPANADA', price: {base: 2000}}

        spyOn(ShoppingCartService, 'getCart').and.returnValue [pizza,empanada]
        $scope.$digest()
        items = element.find('ion-list').html()

        expect(items).toContain empanada.description()
        expect(items).toContain pizza.description()

  describe 'when shopping cart is empty', ->

    it "should list no items", ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue []
      $scope.$digest()
      items = element.find('ion-item')
      expect(items.length).toBe 0

    it 'should display the empty msg', ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue []
      $scope.$digest()
      items = element.find('ion-item')
      msg = element.find('ion-content').html()
      expect(msg).toMatch(/vacio/)
      expect(items.length).toBe 0

    it "should not display totalPrice", ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue []
      $scope.$digest()
      msg = element.find('ion-list').html()
      expect(msg).not.toMatch(/vacio/)

  describe 'when editting', ->

    describe "and hit edit button", ->

      it "should call the edit function with proper data", ->

        pizza1 = new Pizza {id:1, desc:'Muzza', qty:1, totalPrice: 10, cat: 'EMPANADA'}
        pizza2 = new Pizza {id:2, desc:'Fugazzeta',qty:2, totalPrice:5, cat: 'EMPANADA'}

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
        pizza = new Pizza {desc:'Muzza', qty:1,totalPrice: 1000,cat:'PIZZA', size:'chica', dough:'alala', id:1, price:{base:1000}}

        spyOn(ShoppingCartService, 'getCart').and.returnValue [pizza]
        $scope.$digest()
        isolatedScope = element.isolateScope()

        onState = spyOn($mystate, 'go').and.callFake( () -> 1 )
        editItem = spyOn(isolatedScope, 'edit').and.callThrough()

        isolatedScope.edit(pizza)
        expect(onState).toHaveBeenCalledWith 'app.pizza', {pizzaId:'1-muzza-chica-alala'}

      it "should redirect to EMPANADA edit view", ->
        empanada = new Empanada {desc:'Pollo',qty:1,totalPrice:2000,cat:'EMPANADA', id:45, type:'alhorno', price:{base:2000}}

        spyOn(ShoppingCartService, 'getCart').and.returnValue [empanada]
        $scope.$digest()
        isolatedScope = element.isolateScope()

        onState = spyOn($mystate, 'go').and.callFake( () -> 1 )
        editItem = spyOn(isolatedScope, 'edit').and.callThrough()


        isolatedScope.edit(empanada)
        expect(onState).toHaveBeenCalledWith 'app.empanada', {empanadaId:'45-pollo-alhorno'}

      it "should redirect to menu default view if no categ matches", ->

        spyOn(ShoppingCartService, 'getCart').and.returnValue [{hash: '45-newproduct',cat: 'NEW_CATEGORY'}]
        $scope.$digest()
        isolatedScope = element.isolateScope()

        onState = spyOn($mystate, 'go').and.callFake( () -> 1 )
        editItem = spyOn(isolatedScope, 'edit').and.callThrough()

        isolatedScope.edit({})
        expect(onState).toHaveBeenCalledWith 'app.menu'