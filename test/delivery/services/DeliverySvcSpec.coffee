describe 'DeliverySvc', ->

  beforeEach ->
    module 'Muzza.delivery'

  DeliverySvc = undefined

  beforeEach ->
    inject (_Delivery_)->
      DeliverySvc = _Delivery_

  describe 'chooseDeliveryOption', ->

    it 'should save the option into the order', ->
      DeliverySvc.chooseDelivery('pickup')
      expect(DeliverySvc.retrieveDelivery()).toEqual 'pickup'

  describe 'retrieveDelivery', ->

    it 'should return the selected delivery option', ->
      DeliverySvc.chooseDelivery('pickup')
      option = DeliverySvc.retrieveDelivery()
      expect(option).toBe 'pickup'
