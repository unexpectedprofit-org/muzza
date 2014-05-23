angular.module('Muzza.pizzas').factory "PizzaOrder", (ShoppingCartService, $state)->

  class PizzaOrder
    constructor: (modal) ->
      @modal = modal

  PizzaOrder::show = ->
    @modal.show()

  PizzaOrder::hide = ->
#   TODO: Where should this go?
    @modal.scope.pizza.size = ''
    @modal.scope.pizza.dough = ''
    @modal.scope.pizza.qty = undefined
    @modal.scope.pizza.hash = undefined
    @modal.scope.pizza.totalPrice = undefined

    @modal.hide()
    $state.go('app.menu')

  PizzaOrder::add = (pizza)->
#   TODO: Why is qty hardcoded
#   TODO: why is cat hardcoded here? not coming from data repo
    ######### FOR CART
    pizza.hash = getHash pizza
    pizza.cat = "PIZZA"
    pizza.qty = 1
    ######### FOR CART //probably will need to have a Pizza object

    pizza.description = ()->
      pizza.desc + " " + pizza.size + " " + pizza.dough
    item = angular.copy(pizza)
    ShoppingCartService.add item
    @hide()

  PizzaOrder::cancel = ->
#    TODO: if item comes from shoppingcart it should be removed
    @hide()

  PizzaOrder::edit = (pizza)->
    pizza.totalPrice = pizza.price.base
    @modal.scope.choose(pizza)

  getHash = (pizza) ->
    _desc = pizza.desc.toLowerCase().replace(/\s+/g, "")
    _size = pizza.size.toLowerCase().replace(/\s+/g, "")
    _dough = pizza.dough.toLowerCase().replace(/\s+/g, "")

    pizza.id + "-" + _desc + "-" + _size + "-" + _dough

  return PizzaOrder