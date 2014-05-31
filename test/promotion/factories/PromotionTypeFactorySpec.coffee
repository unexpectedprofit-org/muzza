describe 'PromotionTypeFactory', ->

  beforeEach ->
    module 'Muzza.promo'

  PromotionTypeFactory = Promotion = PromoTypeQuantity = undefined

  beforeEach ->
    inject ($injector) ->
      PromotionTypeFactory = $injector.get 'PromotionTypeFactory'
      Promotion = $injector.get 'Promotion'
      PromoTypeQuantity = $injector.get 'PromoTypeQuantity'

  describe "Object creation", ->

    it 'should retrieve a generic Promotion object', ->
      myPromo = PromotionTypeFactory.createPromotion {id:1}

      expect(myPromo instanceof Promotion).toBeTruthy()

    it 'should retrieve a PromoTypeQuantity object', ->
      myPromo = PromotionTypeFactory.createPromotion {id:1,cat:1}

      expect(myPromo instanceof PromoTypeQuantity).toBeTruthy()