angular.module('Muzza.bebidas').factory "BebidaSize", ()->

  class BebidaSize
    constructor: (modal) ->
      @modal = modal

  BebidaSize::show = ->
    totalPrice = @modal.scope.bebida.totalPrice
    if totalPrice == undefined or totalPrice == 0
      @modal.scope.bebida.totalPrice = @modal.scope.bebida.price.base
    @modal.show()

  BebidaSize::hide = ->
    @modal.hide()

  BebidaSize::choose = (selection)->
    bebida = @modal.scope.bebida
    @modal.scope.bebida.totalPrice = bebida.totalPrice + bebida.price.size[selection]
    @hide()

  return BebidaSize