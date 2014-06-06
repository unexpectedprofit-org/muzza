angular.module('Muzza.pizzas').factory "PizzaOrder", (ShoppingCartService, $state, Pizza)->

  class PizzaOrder
    constructor: (modal) ->
      @modal = modal

  PizzaOrder::show = ->
    @modal.show()

  PizzaOrder::hide = ->
    @modal.hide()
    $state.go('app.menu')

  PizzaOrder::add = (pizza)->
    ShoppingCartService.add pizza
    @hide()

  PizzaOrder::cancel = ->
#    TODO: if item comes from shoppingcart it should be removed
    @hide()

  PizzaOrder::edit = (pizza)->
    pizza.resetPrice()
    @modal.scope.choose(pizza)

  PizzaOrder::isMinAllowed = () ->
    @modal.scope.pizza.qty <= 1

  PizzaOrder::isMaxAllowed = () ->
    @modal.scope.pizza.qty >= 10

  return PizzaOrder