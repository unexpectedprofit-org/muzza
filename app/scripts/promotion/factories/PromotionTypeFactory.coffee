angular.module('Muzza.promo').factory 'PromotionTypeFactory', (Promotion,PromoTypeQuantity) ->

  PromotionTypeFactory = {}

  PromotionTypeFactory.createPromotion = (object) ->
    switch object.cat
      when 1
        return new PromoTypeQuantity object
      else
        return new Promotion object

  return PromotionTypeFactory