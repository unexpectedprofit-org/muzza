angular.module('Muzza.promo').factory 'Promotion', () ->

  class Promotion
    constructor: (params) ->
      @rules = params.rules or []
      @id = params.id
      @desc = params.desc
      @price = params.price or 0
      @details = params.details

  return Promotion
