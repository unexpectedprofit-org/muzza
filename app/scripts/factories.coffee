angular.module('Muzza.factories', ['ui.router'])

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


angular.module('Muzza.factories').factory "PizzaOrder", (ShoppingCartService, $state)->

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


angular.module('Muzza.factories').factory "Empanada", () ->

  class Empanada
    constructor: (from) ->
      @cat = 'EMPANADA'
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

angular.module('Muzza.factories').factory "EmpanadaOrder", (ShoppingCartService) ->

  class EmpanadaOrder
    constructor: (modal) ->
      @modal = modal

  EmpanadaOrder::show = ->
    @modal.show()

  EmpanadaOrder::hide = ->
    @modal.hide()

  EmpanadaOrder::add = (empanada)->
    empanada.hash = getHash empanada

    empanada.desc = empanada.desc + " " + empanada.type
    empanada.totalPrice = empanada.price
    ShoppingCartService.add empanada
    @modal.hide()

  EmpanadaOrder::cancel = ->
    @modal.hide()

  EmpanadaOrder::edit = (empanada) ->
    @modal.scope.choose empanada

  getHash = (empanada) ->
    _desc = empanada.desc.toLowerCase().replace(/\s+/g, "")
    _type = empanada.type.toLowerCase().replace(/\s+/g, "")

    empanada.id + "-" + _desc + "-" + _type

  return EmpanadaOrder
