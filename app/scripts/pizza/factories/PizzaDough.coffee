angular.module('Muzza.pizzas').factory "PizzaDough", ()->

  class PizzaDough
    constructor: (modal) ->
      @modal = modal

  PizzaDough::show = ->
    totalPrice = @modal.scope.pizzaSelection.totalPrice
    if totalPrice == undefined or totalPrice == 0
      @modal.scope.pizzaSelection.totalPrice = @modal.scope.pizzaSelection.price.base
    @modal.show()

  PizzaDough::hide = ->
    @modal.hide()

  PizzaDough::choose = (selection)->
    pizza = @modal.scope.pizzaSelection
    @modal.scope.pizzaSelection.totalPrice = pizza.totalPrice + pizza.price.dough[selection]
    @hide()

  return PizzaDough