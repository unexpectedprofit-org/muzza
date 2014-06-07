angular.module('Muzza.promo').factory 'Promotion', () ->

  class Promotion
    constructor: (from) ->
      @cat = "PROMO"
      @qty = 1

      @totalPrice = from?.details?.price
      @id = from?.details?.id
      @description = from?.details?.description?.short

      @rules = from.rules
      @items = getItems from?.components

    getItems = (components) ->
      items = []
      _.forEach (_.keys components), (key) ->
        _.forEach components[key], (currentCategory) ->
          _temp = []
          _temp = _.filter currentCategory.products, (elem) ->
            elem.qty >= 1
          items = items.concat _temp if _temp.length > 0

      items

  Promotion::getHash = () ->
    @id + "|" + @totalPrice

  Promotion::getDescription = () ->
    @description

  Promotion::isEditable = () ->
    false


  return Promotion