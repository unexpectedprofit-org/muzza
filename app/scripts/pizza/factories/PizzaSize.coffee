#angular.module('Muzza.pizzas').factory "PizzaSize", ()->
#
#  class PizzaSize
#    constructor: (modal) ->
#      @modal = modal
#
#  PizzaSize::show = ->
#    totalPrice = @modal.scope.pizzaSelection.totalPrice
#    if totalPrice == undefined or totalPrice == 0
#      @modal.scope.pizzaSelection.totalPrice = @modal.scope.pizzaSelection.price.base
#    @modal.show()
#
#  PizzaSize::hide = ->
#    @modal.hide()
#
#  PizzaSize::choose = (selection)->
#    pizza = @modal.scope.pizzaSelection
#    @modal.scope.pizzaSelection.totalPrice = pizza.totalPrice + pizza.price.size[selection]
#    @hide()
#
#  return PizzaSize