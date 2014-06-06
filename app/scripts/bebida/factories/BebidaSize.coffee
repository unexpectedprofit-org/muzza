angular.module('Muzza.bebidas').factory "BebidaSize", ()->

  class BebidaSize
    constructor: (modal) ->
      @modal = modal

  BebidaSize::show = ->
    totalPrice = @modal.scope.bebidaSelection.totalPrice
    if totalPrice == undefined or totalPrice == 0
      @modal.scope.bebidaSelection.totalPrice = @modal.scope.bebidaSelection.price.base
    @modal.show()

  BebidaSize::hide = ->
    @modal.hide()

  BebidaSize::choose = (selection)->
    bebida = @modal.scope.bebidaSelection
    @modal.scope.bebidaSelection.totalPrice = bebida.totalPrice + bebida.price.size[selection]
    @hide()

  return BebidaSize