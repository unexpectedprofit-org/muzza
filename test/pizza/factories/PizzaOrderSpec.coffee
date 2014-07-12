#describe 'PizzaOrder', ->
#
#  beforeEach ->
#    module 'Muzza.pizzas'
#
#  PizzaOrder = Pizza = modal = showSpy = hideSpy = order = ShoppingCartService = undefined
#
#  beforeEach ->
#    module ($provide) ->
#      $provide.value "ShoppingCartService",
#        add: () ->
#          null
#        getCart: ()->
#          null
#      null
#
#  beforeEach ->
#    inject (_PizzaOrder_, _ShoppingCartService_, _Pizza_) ->
#      PizzaOrder = _PizzaOrder_
#      ShoppingCartService = _ShoppingCartService_
#      Pizza = _Pizza_
#      modal =
#        show: -> null
#        hide: -> null
#        scope:
#          choose: -> null
#
#      showSpy = spyOn(modal, 'show').and.callThrough()
#      hideSpy = spyOn(modal, 'hide').and.callThrough()
#
#      order = new PizzaOrder(modal)
#
#  describe "Init", ->
#
#    it 'should construct a PizzaOrder object', ->
#      expect(order.add).toBeDefined()
#      expect(order.cancel).toBeDefined()
#      expect(order.edit).toBeDefined()
#      expect(order.show).toBeDefined()
#      expect(order.hide).toBeDefined()
#      expect(order.isMinAllowed).toBeDefined()
#      expect(order.isMaxAllowed).toBeDefined()
#
#    it 'should delegate the show call to the modal', ->
#      order.show()
#
#      expect(showSpy).toHaveBeenCalled()
#      expect(showSpy.calls.count()).toBe 1
#
#  describe "Hide", ->
#
#    it 'should delegate the hide call to the modal', ->
#      modal.scope.pizzaSelection = {}
#      order.hide()
#
#      expect(hideSpy).toHaveBeenCalled()
#      expect(hideSpy.calls.count()).toBe 1
#
#
#  describe "When the user confirms the product selection and options", ->
#
#    item = Pizza = undefined
#
#    beforeEach ->
#      item = new Pizza({id:1, desc:'Muzza', size:'chica', dough:'a la piedra'})
#      modal.scope.pizzaSelection = item
#
#    it 'should call ShoppingCart to add a product and hide', ->
#      addSpy = spyOn(ShoppingCartService, 'add').and.callThrough()
#      internalHideSpy = spyOn(order, 'hide').and.callThrough()
#      order.add item
#
#      expect(addSpy).toHaveBeenCalledWith  jasmine.objectContaining {id:1, desc:'Muzza', size:'chica', dough:'a la piedra'}
#
#      expect(addSpy.calls.count()).toBe 1
#      expect(internalHideSpy).toHaveBeenCalled()
#      expect(internalHideSpy.calls.count()).toBe 1
#
#    it 'should decorate the pizzaSelection object', ->
#      addSpy = spyOn(ShoppingCartService, 'add').and.callThrough()
#      item = new Pizza({id:1, desc:'Muzza', size:'chica', dough:'a la piedra'})
#      order.add item
#      expect(item.getDescription()).toBeDefined()
#
#  describe "When user eliminates selected product and options", ->
#
#    it "should hide confirmation modal", ->
#      internalHideSpy = spyOn(order, 'hide').and.callThrough()
#      modal.scope.pizzaSelection =
#        size: 'chica'
#        dough: 'a la piedra'
#        totalPrice: 60
#        price:
#          base: 50
#      order.cancel()
#
#      expect(internalHideSpy).toHaveBeenCalled()
#      expect(internalHideSpy.calls.count()).toBe 1
#
#  describe "When user decides to edit the selected product and options", ->
#
#    it "should display all option modals", ->
#      chooseSpy = spyOn(modal.scope, 'choose').and.callThrough()
#      order.edit(new Pizza({id:1, totalPrice: 60, price: {base: 50 }}))
#      expect(chooseSpy).toHaveBeenCalled()
#
#    it "should reset price to its base price", ->
#      chooseSpy = spyOn(modal.scope, 'choose').and.callThrough()
#      order.edit(new Pizza({id:1, totalPrice: 60, price: {base: 50 }}))
#      expect(chooseSpy).toHaveBeenCalledWith jasmine.objectContaining totalPrice: 50
#
#
#  describe "min/max allowance", ->
#
#    it "should check minimum quantities", ->
#      modal.scope.pizzaSelection =
#        qty: 8
#
#      expect(order.isMinAllowed()).toBeFalsy()
#
#      modal.scope.pizzaSelection.qty = 0
#      expect(order.isMinAllowed()).toBeTruthy()
#
#      modal.scope.pizzaSelection.qty = 1
#      expect(order.isMinAllowed()).toBeTruthy()
#
#    it "should check maximum quantities", ->
#      modal.scope.pizzaSelection =
#        qty: 8
#
#      expect(order.isMaxAllowed()).toBeFalsy()
#
#      modal.scope.pizzaSelection.qty = 0
#      expect(order.isMaxAllowed()).toBeFalsy()
#
#      modal.scope.pizzaSelection.qty = 10
#      expect(order.isMaxAllowed()).toBeTruthy()