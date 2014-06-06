angular.module('Muzza.empanadas').factory "Empanada", () ->

  class Empanada
    constructor: (param) ->
      @cat = 'EMPANADA'
      @subcat = param.subcat
      @type = param.type or ''
      @qty = param.qty or 1
      @description = param.description or ''
      @totalPrice = param?.price?.base or 0
      @toppings = param.toppings or ''
      @id = param.id
      angular.extend(@, param)

  Empanada::updateQty = (value) ->
    @qty = @qty + value
    if @qty < 0 then @qty = 0

  Empanada::getDescription = () ->
    @description + @type

  Empanada::reset = () ->
    @cat = 'EMPANADA'
    @totalPrice = 0
    @qty = 1

  Empanada::isEditable = () ->
    false

  Empanada::getHash = () ->
    "ID_BRAND|" + @id + "|" + @subcat + "||"

  return Empanada