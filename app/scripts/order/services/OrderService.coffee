angular.module('Muzza.order').service 'OrderService', (ShoppingCartService,PlaceOrderResponse) ->

  placeOrder = () ->
    products = ShoppingCartService.getCart()
    order = {}

    #response/call to backend (order, products)

    response =
      status: "success"
      ordenNumber: 'AXFFJ182J'
      date: new Date()

    new PlaceOrderResponse response, products


  place: placeOrder