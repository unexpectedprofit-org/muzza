angular.module('Muzza.pizzas').factory 'Pizza', ($filter)->

  class Pizza
    constructor: (param)->
      @cat = 'PIZZA'
      @isEditable =
        options:true
        qty:true

      @description = param?.description or ''
      @subcat = param?.subcat or 0
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

  Pizza::getDescription = ()->
    @size + ' de ' + @description + ' ' + @dough

  Pizza::resetPrice = ()->
    @totalPrice = @price.base

  Pizza::updateQty = (value)->
    @qty = @qty + value
    if @qty < 0 then @qty = 0

  Pizza::getHash = ()->
    _size =  @size.toUpperCase() or ''
    _dough = @dough.toUpperCase() or ''

    "ID_BRAND|" + @id + "|" + @subcat + "|" + _size + "|" + _dough

  Pizza::reset = () ->
    @cat = 'PIZZA'
    @totalPrice = 0
    @qty = 1
    @size = ''
    @dough = ''

#  TODO:  calculate total price
#  TODO:  handle adding price


  return Pizza