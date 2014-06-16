angular.module('Muzza.bebidas').factory "BebidaOrder", (ShoppingCartService, $state)->

  class BebidaOrder
    constructor: (modal) ->
      @modal = modal

  BebidaOrder::show = ->
    @modal.show()

  BebidaOrder::hide = ->
    @modal.hide()
    $state.go('app.menu')

  BebidaOrder::add = (bebida)->
    ShoppingCartService.add bebida
    @hide()

  return BebidaOrder