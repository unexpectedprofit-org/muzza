#angular.module('Muzza.empanadas').factory "EmpanadaOrder", (ShoppingCartService) ->
#
#  class EmpanadaOrder
#    constructor: (modal) ->
#      @modal = modal
#
#  EmpanadaOrder::show = ->
#    @modal.show()
#
#  EmpanadaOrder::hide = ->
#    @modal.hide()
#
#  EmpanadaOrder::add = (empanada)->
#    ShoppingCartService.add empanada
#    @hide()
#
#  EmpanadaOrder::cancel = ->
#    @hide()
#    @modal.scope.remove()
#
#  EmpanadaOrder::isMinAllowed = () ->
#    @modal.scope.empanadaSelection.qty <= 1
#
#  EmpanadaOrder::isMaxAllowed = () ->
#    @modal.scope.empanadaSelection.qty >= 100
#
#  return EmpanadaOrder