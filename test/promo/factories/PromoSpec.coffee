describe 'Promo', ->

  beforeEach ->
    module 'Muzza.promo'

  Promo = promo = undefined

  beforeEach ->
    inject (_Promo_) ->
      Promo = _Promo_

      promo = new Promo()

  describe "Init", ->

    it 'should construct a Promo object', ->
      expect(promo.rules).toBeDefined()