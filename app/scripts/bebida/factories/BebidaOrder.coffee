#angular.module('Muzza.bebidas').factory "BebidaOrder", (ShoppingCartService)->
#
#  class BebidaOrder
#    constructor: (modal) ->
#      @modal = modal
#
#  BebidaOrder::show = ->
#    @modal.show()
#
#  BebidaOrder::hide = ->
#    @modal.hide()
#
#  BebidaOrder::add = (bebida)->
#    ShoppingCartService.add bebida
#    @hide()
#
#  return BebidaOrder