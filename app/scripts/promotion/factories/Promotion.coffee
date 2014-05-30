angular.module('Muzza.promo').factory 'Promotion', () ->

  class Promotion
    constructor: (params) ->
      @rules = params.rules or []
      @id = params.id
      @desc = params.desc or ''

  return Promotion
