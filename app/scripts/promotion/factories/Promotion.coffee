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

      _.forEach components, (component) ->
        _.forEach component.items, (currentCategory) ->
          _temp = _.filter currentCategory.products, (elem) ->
            elem.qty >= 1

          items = items.concat _temp

      items

  Promotion::getHash = () ->
    @id + "|" + @totalPrice

  Promotion::getDescription = () ->
    @description

  Promotion::isEditable = () ->
    false


  return Promotion