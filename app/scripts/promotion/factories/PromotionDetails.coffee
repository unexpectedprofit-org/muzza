angular.module('Muzza.promo').factory "PromotionDetails", (ShoppingCartService, Promotion)->

  class PromotionDetails
    constructor: (modal) ->
      @modal = modal

  PromotionDetails::show = ->
    @modal.show()

  PromotionDetails::hide = ->
    @modal.hide()

  PromotionDetails::select = ()->
    ShoppingCartService.add new Promotion @modal.scope.promotion
    @hide()

  return PromotionDetails