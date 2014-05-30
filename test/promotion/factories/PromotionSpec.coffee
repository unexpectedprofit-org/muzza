describe 'Promo', ->

  beforeEach ->
    module 'Muzza.promo'

  Promotion = promo = undefined

  beforeEach ->
    inject (_Promotion_) ->
      Promotion = _Promotion_

      promo = new Promotion {id:2,desc:"Promo 1: 6 empanadas..."}

  describe "Init", ->

    it 'should construct a Promo object', ->
      expect(promo.id).toBe 2
      expect(promo.desc).toBe "Promo 1: 6 empanadas..."
      expect(promo.rules).toEqual []