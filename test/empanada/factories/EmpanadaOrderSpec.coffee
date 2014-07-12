#describe 'EmpanadaOrder', ->
#
#  beforeEach ->
#    module 'Muzza.empanadas'
#
#  EmpanadaOrder = Empanada = modal = showSpy = hideSpy = order = ShoppingCartService = undefined
#
#  beforeEach ->
#    module ($provide) ->
#      $provide.value "ShoppingCartService",
#        add: ()-> null
#      null
#
#  beforeEach ->
#    inject (_EmpanadaOrder_, _ShoppingCartService_,_Empanada_) ->
#      EmpanadaOrder = _EmpanadaOrder_
#      Empanada = _Empanada_
#      ShoppingCartService = _ShoppingCartService_
#      modal =
#        show: -> null
#        hide: -> null
#        scope:
#          choose: -> null
#          remove: -> null
#          empanadaSelection:
#            qty: 1
#
#      showSpy = spyOn(modal, 'show').and.callThrough()
#      hideSpy = spyOn(modal, 'hide').and.callThrough()
#
#      order = new EmpanadaOrder modal
#
#  describe "Init", ->
#
#    it 'should construct a EmpanadaOrder object', ->
#
#      expect(order.add).toBeDefined()
#      expect(order.cancel).toBeDefined()
#      expect(order.show).toBeDefined()
#      expect(order.hide).toBeDefined()
#      expect(order.isMinAllowed).toBeDefined()
#      expect(order.isMaxAllowed).toBeDefined()
#
#    it "should init the object", ->
#      expect(order.modal).toBe modal
#
#  describe "show functionality", ->
#
#    it 'should delegate call to the modal', ->
#      order.show()
#
#      expect(showSpy).toHaveBeenCalled()
#      expect(showSpy.calls.count()).toBe 1
#
#  describe "hide functionality", ->
#
#    it 'should delegate call to the modal', ->
#      order.hide()
#
#      expect(hideSpy).toHaveBeenCalled()
#      expect(hideSpy.calls.count()).toBe 1
#
#
#  describe "When the user confirms the product selection and quantity", ->
#
#    it 'should call ShoppingCart to add a product and hide', ->
#      addSpy = spyOn(ShoppingCartService, 'add').and.callThrough()
#      empanada = new Empanada {id:1,desc:'Humita',type:'Frita',qty:2,totalPrice: 15}
#
#      order.add empanada
#
#      expect(hideSpy).toHaveBeenCalled()
#      expect(hideSpy.calls.count()).toBe 1
#
#      expect(addSpy).toHaveBeenCalledWith  empanada
#      expect(addSpy.calls.count()).toBe 1
#
#  describe "cancel functionality", ->
#
#    it "should hide confirmation modal", ->
#      order.cancel()
#
#      expect(hideSpy).toHaveBeenCalled()
#      expect(hideSpy.calls.count()).toBe 1
#
#    it "should delegate call to the scope", ->
#      removeSpy = spyOn(modal.scope,'remove').and.callThrough()
#      order.cancel()
#
#      expect(removeSpy).toHaveBeenCalled()
#      expect(removeSpy.calls.count()).toBe 1
#
#  describe "min/max allowance", ->
#
#    it "should check minimum quantities", ->
#      modal.scope.empanadaSelection.qty = 8
#      expect(order.isMinAllowed()).toBeFalsy()
#
#      modal.scope.empanadaSelection.qty = 0
#      expect(order.isMinAllowed()).toBeTruthy()
#
#      modal.scope.empanadaSelection.qty = 1
#      expect(order.isMinAllowed()).toBeTruthy()
#
#    it "should check maximum quantities", ->
#      modal.scope.empanadaSelection.qty = 8
#      expect(order.isMaxAllowed()).toBeFalsy()
#
#      modal.scope.empanadaSelection.qty = 0
#      expect(order.isMaxAllowed()).toBeFalsy()
#
#      modal.scope.empanadaSelection.qty = 100
#      expect(order.isMaxAllowed()).toBeTruthy()