angular.module('Muzza.product').factory "Product", () ->

  class Product
    constructor: (param) ->
      @id = param.id
      @categoryId = param.catId
      @qty = param.qty or 1
      @description = param.description or ''
      @totalPrice = param?.price?.base or undefined

#      @isEditable =
#        options:false
#        qty:true

      angular.extend(@, param)

  Product::updateQty = (value) ->
    @qty = @qty + value
    if @qty < 0 then @qty = 0

  Product::getDescription = () ->
    @description

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


  return Product