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
      expect(promo.id).toBe 2
      expect(promo.desc).toBe "Promo 1: 6 empanadas..."
      expect(promo.rules).toEqual []
      expect(promo.price).toBe 54
      expect(promo.details).toBe "alala"

    it 'should construct a Promo object - case 2', ->
      promo = new Promotion {id:5,desc:"Promo 2: aaa"}
      expect(promo.id).toBe 5
      expect(promo.desc).toBe "Promo 2: aaa"
      expect(promo.rules).toEqual []
      expect(promo.price).toBe 0
      expect(promo.details).toBeUndefined()