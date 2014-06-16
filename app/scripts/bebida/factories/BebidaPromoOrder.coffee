angular.module('Muzza.bebidas').factory "BebidaPromoOrder", ()->

  class BebidaPromoOrder
    constructor: (modal) ->
      @modal = modal

  BebidaPromoOrder::show = ->
    @modal.show()

  BebidaPromoOrder::hide = ->
    @modal.hide()

  BebidaPromoOrder::add = (bebida)->
    bebidaFromPromo = undefined
    found = false
    _.forEach @modal.scope.menu, (cat) ->

      unless found
        bebidaFromPromo = _.find cat.products, (prod) ->
          parseInt(prod.id) is parseInt(bebida.id)

        found = true if bebidaFromPromo isnt undefined
      return

    bebidaFromPromo.qty = bebida.qty
    bebidaFromPromo.size = bebida.size

    @hide()

  BebidaPromoOrder::cancel = ->
#    TODO: if item comes from shoppingcart it should be removed
    @hide()

  BebidaPromoOrder::edit = (bebida)->
    bebida.resetPrice()
    @modal.scope.choosePromoItem bebida

  return BebidaPromoOrder