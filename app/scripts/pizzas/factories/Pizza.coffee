angular.module('Muzza.pizzas').factory 'Pizza', ($filter)->

  class Pizza
    constructor: (param)->
      @desc = param?.desc or ''
      @cat = 'PIZZA'
      @qty = param?.qty or 1
      @totalPrice = param?.totalPrice or undefined
      @size = param?.size or ''
      @dough = param?.dough or ''
      @price =
        base: 0
      angular.extend(@, param)

  formatPrice = (value) ->
    value = $filter('centsToMoney')(value)
    $filter('currency')(value)

  Pizza::getBasePrice = ->
    if @price.base is undefined then @price.base = 0
    formatPrice(@price.base)

  Pizza::getTotalPrice = ->
    if @totalPrice is undefined then @totalPrice = 0
    formatPrice(@totalPrice)

  Pizza::description = ()->
    @size + ' de ' + @desc + ' ' + @dough

  Pizza::resetPrice = ()->
    @totalPrice = @price.base

  Pizza::updateQty = (value)->
    @qty = @qty + value
    if @qty <= 0 then @qty = 1

  Pizza::getHash = ()->
    _desc = @desc.toLowerCase().replace(/\s+/g, "")
    _size = @size.toLowerCase().replace(/\s+/g, "")
    _dough = @dough.toLowerCase().replace(/\s+/g, "")
    @id + "-" + _desc + "-" + _size + "-" + _dough

#  TODO:  calculate total price
#  TODO:  handle adding price


  return Pizza