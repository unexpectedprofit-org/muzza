angular.module('Muzza.factories', [])

angular.module('Muzza.factories').factory "PizzaSize", ()->

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


angular.module('Muzza.factories').factory "PizzaDough", ()->

  class PizzaDough
    constructor: (modal) ->
      @modal = modal

  PizzaDough::show = ->
    if @modal.scope.pizza.totalPrice == undefined
      @modal.scope.pizza.totalPrice = @modal.scope.pizza.price.base
    @modal.show()

  PizzaDough::hide = ->
    @modal.hide()

  PizzaDough::choose = (selection)->
    pizza = @modal.scope.pizza
    @modal.scope.pizza.totalPrice = pizza.totalPrice + pizza.price.dough[selection]
    @hide()

  return PizzaDough


angular.module('Muzza.factories').factory "PizzaOrder", (ShoppingCart)->

  class PizzaOrder
    constructor: (modal) ->
      @modal = modal

  PizzaOrder::show = ->
    @modal.show()

  PizzaOrder::hide = ->
    @modal.hide()

  PizzaOrder::add = (pizza)->
    pizza.desc = pizza.desc + " " + pizza.size + " " + pizza.dough
    ShoppingCart.addToCart(pizza)
    @hide()

  PizzaOrder::cancel = ->
    @hide()

  PizzaOrder::edit = (pizza)->
    @modal.scope.choose(pizza)

  return PizzaOrder


angular.module('Muzza.factories').factory "Empanada", () ->

  class Empanada
    constructor: (from) ->
      @qty = 1
      @desc = from?.desc
      @price = from?.price
      @type = from?.type

      @id = from?.id


    toNumber: (value) ->
      value = value * 1
      if isNaN(value) then 0 else value

  Empanada::updateQty = (itemQtyDiff) ->
    itemQtyDiff = @toNumber(itemQtyDiff)
    if (@qty + itemQtyDiff ) <= 0
      @qty = 0
    else
      @qty = @qty + itemQtyDiff

  Empanada::minReached = () ->
    @qty <= 1
  Empanada::maxReached = () ->
    @qty >= 100

  Empanada::equals = (anotherObject) ->
    angular.isDefined(anotherObject) && @id is anotherObject.id


  return Empanada
