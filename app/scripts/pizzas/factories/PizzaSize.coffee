angular.module('Muzza.pizzas').factory "PizzaSize", ()->

  class PizzaSize
    constructor: (modal) ->
      @modal = modal

  PizzaSize::show = ->
    if @modal.scope.pizza.totalPrice == undefined
      @modal.scope.pizza.totalPrice = @modal.scope.pizza.price.base
    @modal.show()

  PizzaSize::hide = ->
    @modal.hide()

  PizzaSize::choose = (selection)->
    pizza = @modal.scope.pizza
    @modal.scope.pizza.totalPrice = pizza.totalPrice + pizza.price.size[selection]
    @hide()

  return PizzaSize