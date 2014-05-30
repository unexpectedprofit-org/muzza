angular.module('Muzza.promo').factory "PromotionDetails", (ShoppingCartService)->

  class PromotionDetails
    constructor: (modal) ->
      @modal = modal

  PromotionDetails::show = ->
    @modal.show()

  PromotionDetails::hide = ->
    @modal.hide()

  PromotionDetails::select = ()->
    ShoppingCartService.addPromotion @modal.scope.promotion
    @hide()

  return PromotionDetails