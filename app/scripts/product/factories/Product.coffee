angular.module('Muzza.product').factory "Product", () ->

  class Product
    constructor: (param) ->
      angular.copy param, @
      @id = param.id
      @qty = param.qty or 1
      @description = param.description or ''

      setOptionsType @options

    setOptionsType = (options) ->
      _.each options, (option) ->
        singleOption = option.config.min is 1 && option.config.max is 1
        multipleOptions = !singleOption and !option.config.multipleQty
        multipleOptionsMultipleQty = !singleOption and option.config.multipleQty

        option.type = "SINGLE" if singleOption
        option.type = "MULTIPLE" if multipleOptions
        option.type = "MULTIPLE_QTY" if multipleOptionsMultipleQty

  hasMultipleQtyOptionType = (options) ->
    option_MULTIPLE_QTY_type = _.find options, (option) ->
      option.type is 'MULTIPLE_QTY'

    option_MULTIPLE_QTY_type isnt undefined

  Product::clearSelections = ()->
    @qty = 1

    _.each @options, (option) ->
      option.selection = undefined
      _.each option.items, (item)->
        item.isSelected = undefined

  Product::isEditable = () ->
    {
      qty: !hasMultipleQtyOptionType @options
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

          if option.type is 'MULTIPLE_QTY' and selection.qty isnt undefined and selection.qty > 0
            detailsStr += selection.qty + " "

          detailsStr += (selection.description + '/') unless selection.qty is 0

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
    productBasePrice = @price?.base or 0
    totalPrice = 0

    _.forEach @options, (option) ->
      totalPricePerOption = if option.type is "MULTIPLE_QTY" then 0 else productBasePrice

      _.forEach option.selection, (selection) ->

        selection.price = 0 unless selection.price isnt undefined
        selection.qty = 1 unless selection.qty isnt undefined

        if option.type is 'MULTIPLE_QTY'

          totalPricePerOption += (productBasePrice + selection.price) * selection.qty
        else
          totalPricePerOption += (selection.price * selection.qty)

      totalPrice += totalPricePerOption


    totalPrice


  return Product