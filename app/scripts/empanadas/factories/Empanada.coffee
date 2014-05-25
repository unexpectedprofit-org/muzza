angular.module('Muzza.empanadas').factory "Empanada", () ->

  class Empanada
    constructor: (param) ->
      @cat = 'EMPANADA'
      @qty = param.qty or 1
      @desc = param.desc or ''
      @type = param.type or ''
      @totalPrice = param.price or 0
      @toppings = param.toppings or ''

      @id = param.id

  Empanada::updateQty = (itemQtyDiff) ->

    toNumber = (value) ->
      value = value * 1
      if isNaN(value) then 0 else value

    itemQtyDiff = toNumber(itemQtyDiff)
    if (@qty + itemQtyDiff ) <= 0
      @qty = 0
    else
      @qty = @qty + itemQtyDiff

  Empanada::minReached = () ->
    @qty <= 1

  Empanada::maxReached = () ->
    @qty >= 100

  Empanada::description = () ->
    @desc

  Empanada::getHash = () ->
    _desc = @desc.toLowerCase().replace(/\s+/g, "")
    _type = @type.toLowerCase().replace(/\s+/g, "")

    @id + "-" + _desc + "-" + _type

  return Empanada