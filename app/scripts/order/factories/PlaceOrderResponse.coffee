angular.module('Muzza.order').factory 'PlaceOrderResponse', () ->

  class PlaceOrderResponse
    constructor: (response, products) ->
      @response = response
      @products = products

  return PlaceOrderResponse