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
    pizza.setHash()
    ShoppingCartService.add pizza
    @hide()

  PizzaOrder::cancel = ->
#    TODO: if item comes from shoppingcart it should be removed
    @hide()

  PizzaOrder::edit = (pizza)->
    pizza.resetPrice()
    @modal.scope.choose(pizza)

  return PizzaOrder