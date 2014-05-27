describe 'OrderDelivery', ->

  beforeEach ->
    module 'Muzza.order'

  OrderDelivery = modal = showSpy = hideSpy = orderDelivery = undefined

  beforeEach ->
    inject (_OrderDelivery_) ->
      OrderDelivery = _OrderDelivery_
      modal =
        show: -> null
        hide: -> null
        scope:
          order: {}

      showSpy = spyOn(modal, 'show').and.callThrough()
      hideSpy = spyOn(modal, 'hide').and.callThrough()

      orderDelivery = new OrderDelivery modal

  describe "Init", ->

    it 'should construct a OrderDelivery object', ->
      expect(orderDelivery.choose).toBeDefined()
      expect(orderDelivery.show).toBeDefined()
      expect(orderDelivery.hide).toBeDefined()

    it "should init the object", ->
      expect(orderDelivery.modal).toBe modal

  describe "show functionality", ->

    it 'should delegate call to the modal', ->
      orderDelivery.show()

      expect(showSpy).toHaveBeenCalled()
      expect(showSpy.calls.count()).toBe 1

  describe "hide functionality", ->

    it 'should delegate call to the modal', ->
      orderDelivery.hide()

      expect(hideSpy).toHaveBeenCalled()
      expect(hideSpy.calls.count()).toBe 1

  describe "choose functionality", ->

    it "should set deliveryoption into the scope", ->
      orderDelivery.choose "mydeliveryMethod"

      expect(modal.scope.order.deliveryOption).toBe "mydeliveryMethod"