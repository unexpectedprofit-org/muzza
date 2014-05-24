angular.module('Muzza.empanadas').factory "EmpanadaOrder", (ShoppingCartService) ->

  class EmpanadaOrder
    constructor: (modal) ->
      @modal = modal

  EmpanadaOrder::show = ->
    @modal.show()

  EmpanadaOrder::hide = ->
    @modal.hide()

  EmpanadaOrder::add = (empanada)->
    empanada.hash = getHash empanada

    empanada.desc = empanada.desc + " " + empanada.type
    empanada.totalPrice = empanada.price
    ShoppingCartService.add empanada
    @hide()

  EmpanadaOrder::cancel = ->
    @hide()
    @modal.scope.remove()

  EmpanadaOrder::edit = (empanada) ->
    @modal.scope.choose empanada

  getHash = (empanada) ->
    _desc = empanada.desc.toLowerCase().replace(/\s+/g, "")
    _type = empanada.type.toLowerCase().replace(/\s+/g, "")

    empanada.id + "-" + _desc + "-" + _type

  return EmpanadaOrder