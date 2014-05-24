angular.module('Muzza.empanadas').factory "Empanada", () ->

  class Empanada
    constructor: (param) ->
      @cat = 'EMPANADA'
      @qty = 1
      @desc = param?.desc or ''
      @type = param?.type or ''
      @price = param?.price or 0

      @id = param?.id


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

  Empanada::description = () ->
    @desc


  return Empanada