angular.module('Muzza.promo').factory "PromotionDetails", (ShoppingCartService)->

  class PromotionDetails
    constructor: (modal) ->
      @modal = modal

  PromotionDetails::show = ->
    @modal.show()

  PromotionDetails::hide = ->
    @modal.hide()

  PromotionDetails::select = (promotion)->
    ShoppingCartService.addPromo promotion
    @hide()

  return PromotionDetails