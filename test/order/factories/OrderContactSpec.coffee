#describe 'OrderContact', ->
#
#  beforeEach ->
#    module 'Muzza.order'
#    module ($provide) ->
#      $provide.value "$state",
#        go: ()-> ''
#      return null
#
#  OrderContact = modal = showSpy = hideSpy = orderContact = undefined
#
#  beforeEach ->
#    inject (_OrderContact_) ->
#      OrderContact = _OrderContact_
#      modal =
#        show: -> null
#        hide: -> null
#
#      showSpy = spyOn(modal, 'show').and.callThrough()
#      hideSpy = spyOn(modal, 'hide').and.callThrough()
#
#      orderContact = new OrderContact modal
#
#  describe "Init", ->
#
#    it 'should construct a OrderContact object', ->
#      expect(orderContact.place).toBeDefined()
#      expect(orderContact.show).toBeDefined()
#      expect(orderContact.hide).toBeDefined()
#
#    it "should init the object", ->
#      expect(orderContact.modal).toBe modal
#
#  describe "show functionality", ->
#
#    it 'should delegate call to the modal', ->
#      orderContact.show()
#
#      expect(showSpy).toHaveBeenCalled()
#      expect(showSpy.calls.count()).toBe 1
#
#  describe "hide functionality", ->
#
#    it 'should delegate call to the modal', ->
#      orderContact.hide()
#
#      expect(hideSpy).toHaveBeenCalled()
#      expect(hideSpy.calls.count()).toBe 1
#
#  describe "place functionality", ->
#
#    it "should redirect to confo page", ->
#      inject ($state) ->
#        confoSpy = spyOn($state, 'go').and.callThrough()
#        orderContact.place()
#
#        expect(confoSpy).toHaveBeenCalledWith "^.orderplace"
#        expect(confoSpy.calls.count()).toBe 1
