angular.module('Muzza.bebidas').factory 'Bebida', ()->

  class Bebida
    constructor: (param)->
      @desc = param?.desc or undefined
      @cat = 'BEBIDA'
      @subcat = param?.subcat or 0
      @qty = param?.qty or 1
      @size = param?.size or undefined
      @option = param?.option or undefined
      @totalPrice = param?.totalPrice or undefined
      @price =
        base: 0
      angular.extend(@, param)

  Bebida::resetPrice = () ->
    @totalPrice = @price.base

  Bebida::description = ()->
    _result = @desc

    if @size isnt undefined
      _result = _result + " " + @size

    if @option isnt undefined
      _result = _result + " " + @option

    _result

  Bebida::updateQty = (value)->
    @qty = @qty + value
    if @qty < 0 then @qty = 0

  Bebida::getHash = ()->
    switch @size
      when "grande"
        _size = "GRANDE"
      when "chica"
        _size = "CHICA"
      when "individual"
        _size = "INDIVIDUAL"
      else
        _size = ""

    if @option is undefined
      _option = ""
    else
      _option = @option

    "ID_BRAND|" + @id + "|" + @subcat + "|" + _size + "|" + _option


  return Bebida