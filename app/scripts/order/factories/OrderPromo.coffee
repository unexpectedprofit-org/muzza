angular.module('Muzza.order').factory "OrderPromo", (PromoTypeQuantity)->

  class OrderPromo
    constructor: (modal) ->
      @modal = modal

  OrderPromo::show = ->
    @modal.show()

  OrderPromo::hide = ->
    @modal.hide()

  OrderPromo::applyPromos = (cart)->
    promo = new PromoTypeQuantity [{cat:'EMPANADA',qty:6,subcat:'|||'}]
    result = promo.validate cart

    console.log "apply promo - cart: " + JSON.stringify cart
    console.log "apply promo - rules: " + JSON.stringify promo.rules
    console.log "apply promo: " + result

    @modal.scope.isPromoValid = result


  OrderPromo::continue = ()->
    @hide()

  return OrderPromo