#describe 'OrderPromo', ->
#
#  beforeEach ->
#    module 'Muzza.order'
#
#    module ($provide) ->
#      $provide.value 'PromoTypeQuantity',
#        validate: () -> true
#      null
#
#
#
#  OrderPromo = PromoTypeQuantity = modal = showSpy = hideSpy = orderPromo = undefined
#
#  beforeEach ->
#    inject (_OrderPromo_, _PromoTypeQuantity_) ->
#      OrderPromo = _OrderPromo_
#      PromoTypeQuantity = _PromoTypeQuantity_
#      modal =
#        show: -> null
#        hide: -> null
#
#      showSpy = spyOn(modal, 'show').and.callThrough()
#      hideSpy = spyOn(modal, 'hide').and.callThrough()
#      validateSpy = spyOn(PromoTypeQuantity, 'validate').and.callThrough()
#
#      orderPromo = new OrderPromo modal
#
#  describe "Init", ->
#
#    it 'should construct a orderPromo object', ->
#      expect(orderPromo.applyPromos).toBeDefined()
#      expect(orderPromo.continue).toBeDefined()
#      expect(orderPromo.show).toBeDefined()
#      expect(orderPromo.hide).toBeDefined()
#
#    it "should init the object", ->
#      expect(orderPromo.modal).toBe modal
#
#  describe "show functionality", ->
#
#    it 'should delegate call to the modal', ->
#      orderPromo.show()
#
#      expect(showSpy).toHaveBeenCalled()
#      expect(showSpy.calls.count()).toBe 1
#
#  describe "hide functionality", ->
#
#    it 'should delegate call to the modal', ->
#      orderPromo.hide()
#
#      expect(hideSpy).toHaveBeenCalled()
#      expect(hideSpy.calls.count()).toBe 1
#
#  describe "apply promo functionality", ->
#
#    it "should redirect to confo page", ->
