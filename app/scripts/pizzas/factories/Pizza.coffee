angular.module('Muzza.pizzas').factory 'Pizza', ()->

  class Pizza
    constructor: (param)->
      @desc = param?.desc or ''
      @cat = 'PIZZA'
      @qty = param?.qty or 1
      @totalPrice = param?.totalPrice or 0
      @size = param?.size or ''
      @dough = param?.dough or ''
      @price =
        base: 0
      angular.extend(@, param)

  Pizza::description = ()->
    @size + ' de ' + @desc + ' ' + @dough

  Pizza::resetPrice = ()->
    @totalPrice = @price.base

  Pizza::setHash = ()->
    _desc = @desc.toLowerCase().replace(/\s+/g, "")
    _size = @size.toLowerCase().replace(/\s+/g, "")
    _dough = @dough.toLowerCase().replace(/\s+/g, "")
    @hash = @id + "-" + _desc + "-" + _size + "-" + _dough


  return Pizza