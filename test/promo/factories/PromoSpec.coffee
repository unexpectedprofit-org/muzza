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
      expect(promo.validate).toBeDefined()
      expect(promo.apply).toBeDefined()

      expect(promo.rules).toBeDefined()

  describe "validate functionality", ->

    it 'should NOT validate', ->
      expect(promo.validate {}).toBeFalsy()

  describe "apply functionality", ->

    it 'should return same thing', ->
      expect(promo.apply {}).toBe {}