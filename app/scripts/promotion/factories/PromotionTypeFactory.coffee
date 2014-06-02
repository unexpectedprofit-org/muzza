angular.module('Muzza.promo').factory 'PromotionTypeFactory', (PromoTypeQuantity) ->

  PromotionTypeFactory = {}

  PromotionTypeFactory.createPromotion = (object) ->
    switch object.cat
      when 1
        return new PromoTypeQuantity object
      else
        return null

  return PromotionTypeFactory