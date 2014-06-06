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

  BebidaOrder::cancel = ->
#    TODO: if item comes from shoppingcart it should be removed
    @hide()

  BebidaOrder::edit = (bebida)->
    bebida.resetPrice()
    @modal.scope.choose bebida

  BebidaOrder::isMinAllowed = () ->
    @modal.scope.bebidaSelection.qty <= 1

  BebidaOrder::isMaxAllowed = () ->
    @modal.scope.bebidaSelection.qty >= 10

  return BebidaOrder