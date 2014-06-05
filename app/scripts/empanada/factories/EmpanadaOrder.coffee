angular.module('Muzza.empanadas').factory "EmpanadaOrder", (ShoppingCartService, $state) ->

  class EmpanadaOrder
    constructor: (modal) ->
      @modal = modal

  EmpanadaOrder::show = ->
    @modal.show()

  EmpanadaOrder::hide = ->
    @modal.hide()
    $state.go('app.menu')

  EmpanadaOrder::add = (empanada)->
    ShoppingCartService.add empanada
    @hide()

  EmpanadaOrder::cancel = ->
    @hide()
    @modal.scope.remove()

  return EmpanadaOrder