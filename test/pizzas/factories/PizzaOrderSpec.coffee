describe 'PizzaOrder', ->

  beforeEach ->
    module 'Muzza.pizzas'

  PizzaOrder = Pizza = modal = showSpy = hideSpy = order = ShoppingCartService = undefined

  beforeEach ->
    module ($provide) ->
      $provide.value "ShoppingCartService",
        add: () ->
          return null
        getCart: ()->
          return null
      return null
    module ($provide) ->
      $provide.value "$state",
        go: ()-> ''
      return null

  beforeEach ->
    inject (_PizzaOrder_, _ShoppingCartService_, _Pizza_) ->
      PizzaOrder = _PizzaOrder_
      ShoppingCartService = _ShoppingCartService_
      Pizza = _Pizza_
      modal =
        show: -> null
        hide: -> null
        scope:
          choose: -> null

      showSpy = spyOn(modal, 'show').and.callThrough()
      hideSpy = spyOn(modal, 'hide').and.callThrough()

      order = new PizzaOrder(modal)

  describe "Init", ->

    it 'should construct a PizzaOrder object', ->
      expect(order.add).toBeDefined()
      expect(order.cancel).toBeDefined()
      expect(order.edit).toBeDefined()
      expect(order.show).toBeDefined()
      expect(order.hide).toBeDefined()

    it 'should delegate the show call to the modal', ->
      order.show()

      expect(showSpy).toHaveBeenCalled()
      expect(showSpy.calls.count()).toBe 1

  describe "Hide", ->

    it 'should delegate the hide call to the modal', ->
      modal.scope.pizza = {}
      order.hide()

      expect(hideSpy).toHaveBeenCalled()
      expect(hideSpy.calls.count()).toBe 1

    it 'should redirect to the menu', ->
      inject ($state) ->
        spyOn($state, 'go').and.callThrough()
        modal.scope.pizza = {}
        order.hide()
        expect($state.go).toHaveBeenCalledWith('app.menu')



  describe "When the user confirms the product selection and options", ->

    item = Pizza = undefined

    beforeEach ->
      item = new Pizza({id:1, desc:'Muzza', size:'chica', dough:'a la piedra'})
      modal.scope.pizza = item

    it 'should call ShoppingCart to add a product and hide', ->
      addSpy = spyOn(ShoppingCartService, 'add').and.callThrough()
      internalHideSpy = spyOn(order, 'hide').and.callThrough()
      order.add item

      expect(addSpy).toHaveBeenCalledWith  jasmine.objectContaining {id:1, desc:'Muzza', size:'chica', dough:'a la piedra'}

      expect(addSpy.calls.count()).toBe 1
      expect(internalHideSpy).toHaveBeenCalled()
      expect(internalHideSpy.calls.count()).toBe 1

    it 'should decorate the pizza object', ->
      addSpy = spyOn(ShoppingCartService, 'add').and.callThrough()
      item = new Pizza({id:1, desc:'Muzza', size:'chica', dough:'a la piedra'})
      order.add item
      expect(item.description).toBeDefined()

    it 'should form a hash', ->
      addSpy = spyOn(ShoppingCartService, 'add').and.callThrough()
      order.add new Pizza({id:1, desc:'Muzza', size:'chica', dough:'a la piedra'})
      expect(addSpy).toHaveBeenCalledWith jasmine.objectContaining {id:1, hash: '1-muzza-chica-alapiedra'}
      expect(addSpy.calls.count()).toBe 1


  describe "When user eliminates selected product and options", ->

    it "should hide confirmation modal", ->
      internalHideSpy = spyOn(order, 'hide').and.callThrough()
      modal.scope.pizza =
        size: 'chica'
        dough: 'a la piedra'
        totalPrice: 60
        price:
          base: 50
      order.cancel()

      expect(internalHideSpy).toHaveBeenCalled()
      expect(internalHideSpy.calls.count()).toBe 1

  describe "When user decides to edit the selected product and options", ->

    it "should display all option modals", ->
      chooseSpy = spyOn(modal.scope, 'choose').and.callThrough()
      order.edit(new Pizza({id:1, totalPrice: 60, price: {base: 50 }}))
      expect(chooseSpy).toHaveBeenCalled()

    it "should reset price to its base price", ->
      chooseSpy = spyOn(modal.scope, 'choose').and.callThrough()
      order.edit(new Pizza({id:1, totalPrice: 60, price: {base: 50 }}))
      expect(chooseSpy).toHaveBeenCalledWith jasmine.objectContaining totalPrice: 50
