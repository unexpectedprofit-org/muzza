describe 'Promo', ->

  beforeEach ->
    module 'Muzza.promo'

  Promotion = promo = undefined

  beforeEach ->
    inject (_Promotion_) ->
      Promotion = _Promotion_

      promo = new Promotion {id:2,desc:"Promo 1: 6 empanadas...",price:54,details:"alala"}

  describe "Init", ->

    it 'should construct a Promo object', ->
      expect(promo instanceof Promotion).toBeTruthy()
      expect(promo.details.id).toBe 2
      expect(promo.details.description.short).toBe "Promo 1: 6 empanadas..."
      expect(promo.details.description.long).toBe "alala"
      expect(promo.rules).toEqual []
      expect(promo.details.price).toBe 54