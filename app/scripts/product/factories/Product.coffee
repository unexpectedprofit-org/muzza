angular.module('Muzza.product').factory "Product", () ->

  class Product
    constructor: (param) ->
      @id = param.id
      @categoryId = param.catId
      @qty = param.qty or 1
      @description = param.description or ''

      angular.extend(@, param)


  Product::isEditable = () ->
    {
      qty:true
      options: @options?[0].selection?.length > 0
    }

  Product::updateQty = (value) ->
    @qty = @qty + value
    if @qty < 0 then @qty = 0

  Product::getDescription = () ->
    @description

  Product::getDetails = () ->
    detailsStr = ''

    if @options isnt undefined
      _.each @options, (option) ->
        detailsStr += option.description + ': '

        _.each option.selection, (selection) ->
          detailsStr += selection.description + '/'

        detailsStr += '||'

    detailsStr


  Product::reset = () ->
    @totalPrice = 0
    @qty = 1

  Product::getHash = () ->
    commonHash = "ID_BRAND|ID:" + @id + "|CAT_ID:" + @categoryId + "|"

    if @options isnt undefined
      _.each @options, (option) ->
        commonHash += "OPT:" + option.description + '|'

        _.each option.selection, (selection) ->
          commonHash += selection.description + '|'

    commonHash

  Product::calculateTotalPrice = () ->
    totalPrice = @price?.base or 0

    _.forEach @options, (option) ->

      _.forEach option.selection, (selection) ->

        totalPrice += selection.price

    totalPrice


  return Product