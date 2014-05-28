angular.module('Muzza.order').factory "OrderPromo", (Promo_Empanadas_Qty_Type)->

  class OrderPromo
    constructor: (modal) ->
      @modal = modal

  OrderPromo::show = ->
    @modal.show()

  OrderPromo::hide = ->
    @modal.hide()

  OrderPromo::applyPromos = (cart)->

    console.log "apply promo - cart " + JSON.stringify cart

    promo = new Promo_Empanadas_Qty_Type 6, 'H'
    result = promo.validate cart

    console.log "apply promo: " + result

    @modal.scope.isPromoValid = result


  OrderPromo::continue = ()->
    @hide()

  return OrderPromo