angular.module('Muzza.bebidas').factory 'Bebida', ()->

  class Bebida
    constructor: (param)->
      @description = param?.description or ''
      @cat = 'BEBIDA'
      @subcat = param?.subcat or 0
      @qty = param?.qty or 1
      @size = param?.size or ''
      @option = param?.option or ''
      @totalPrice = param?.totalPrice or 0
      @price =
        base: 0
      angular.extend(@, param)

  Bebida::resetPrice = () ->
    @totalPrice = @price.base

  Bebida::getDescription = ()->
    _result = @description

    if @size isnt ''
      _result = _result + " " + @size

    if @option isnt ''
      _result = _result + " " + @option

    _result

  Bebida::updateQty = (value)->
    @qty = @qty + value
    if @qty < 0 then @qty = 0

  Bebida::reset = () ->
    @cat = 'BEBIDA'
    @totalPrice = 0
    @qty = 1

  Bebida::isEditable = () ->
    true

  Bebida::getHash = ()->
    _size = @size.toUpperCase() or ''
    _option = @option?.toUpperCase() or ''

    "ID_BRAND|" + @id + "|" + @subcat + "|" + _size + "|" + _option


  return Bebida