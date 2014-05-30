angular.module('Muzza.empanadas').factory "Empanada", () ->

  class Empanada
    constructor: (param) ->
      @cat = 'EMPANADA'
      @subcat = if param.type is 'horno' then 'H' else 'F'
      @qty = param.qty or 1
      @desc = param.desc or ''
      @type = param.type or ''
      @totalPrice = param?.price?.base or 0
      @toppings = param.toppings or ''
      @id = param.id
      angular.extend(@, param)

  Empanada::updateQty = (value) ->

    @qty = @qty + value
    if @qty < 0 then @qty = 0

  Empanada::minReached = () ->
    @qty <= 1

  Empanada::maxReached = () ->
    @qty >= 100

  Empanada::description = () ->
    @desc + @type

  Empanada::getHash = () ->

    switch @type
      when "frita"
        _type = "FRITA"
      when "horno"
        _type = "HORNO"
      else
        _type = ""

    "ID_BRAND|" + @id + "|" + _type + "||"

  return Empanada