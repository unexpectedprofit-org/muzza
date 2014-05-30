describe 'PromotionDetails', ->

  beforeEach ->
    module 'Muzza.promo'

    module ($provide) ->
      $provide.value 'ShoppingCartService',
        addPromo: (promo) -> null
      null


  PromotionDetails = Promotion = ShoppingCartService = promoDetails = promo1 = modal = showSpy = hideSpy = undefined

  beforeEach ->
    inject (_PromotionDetails_, _ShoppingCartService_, _Promotion_) ->
      PromotionDetails = _PromotionDetails_
      ShoppingCartService = _ShoppingCartService_
      Promotion = _Promotion_
      promo1 = new Promotion {id:1}

      modal =
        show: -> null
        hide: -> null
        scope:
          promotion: promo1

      showSpy = spyOn(modal, 'show').and.callThrough()
      hideSpy = spyOn(modal, 'hide').and.callThrough()

      promoDetails = new PromotionDetails modal

  describe "Init", ->

    it 'should construct a PromotionDetails object', ->
      expect(promoDetails.select).toBeDefined()
      expect(promoDetails.show).toBeDefined()
      expect(promoDetails.hide).toBeDefined()


  describe "hide functionality", ->

    it 'should delegate the hide call to the modal', ->
      promoDetails.hide()

      expect(hideSpy).toHaveBeenCalled()


  describe "show functionality", ->

    it 'should delegate the show call to the modal', ->
      promoDetails.show()

      expect(showSpy).toHaveBeenCalled()


  describe 'select functionality', ->

    it 'should call hide', ->
      internalHideSpy = spyOn(promoDetails, 'hide').and.callThrough()
      addPromoSpy = spyOn(ShoppingCartService, 'addPromo')

      promoDetails.select()

      expect(internalHideSpy).toHaveBeenCalled()

    it "should call service to add promo", ->

      addPromoSpy = spyOn(ShoppingCartService, 'addPromo')

      promoDetails.select()

      expect(addPromoSpy).toHaveBeenCalledWith promo1