angular.module('Muzza.pizzas').factory "PizzaDough", ()->

  class PizzaDough
    constructor: (modal) ->
      @modal = modal

  PizzaDough::show = ->
    totalPrice = @modal.scope.pizza.totalPrice
    if totalPrice == undefined or totalPrice == 0
      @modal.scope.pizza.totalPrice = @modal.scope.pizza.price.base
    @modal.show()

  PizzaDough::hide = ->
    @modal.hide()

  PizzaDough::choose = (selection)->
    pizza = @modal.scope.pizza
    @modal.scope.pizza.totalPrice = pizza.totalPrice + pizza.price.dough[selection]
    @hide()

  return PizzaDough