angular.module('Muzza.order').service 'OrderService', (ShoppingCartService,PlaceOrderResponse) ->

  order = {}

  placeOrder = () ->
    products = ShoppingCartService.getCart()
    order = {}

    #response/call to backend (order, products)

    response =
      status: "success"
      ordenNumber: 'AXFFJ182J'
      date: new Date()

    new PlaceOrderResponse response, products

  setDelivery = (option)->
    order.delivery = option

  getOrder = ()->
    order

  setContactInfo = (contact)->
    order.contact = contact

  place: placeOrder
  chooseDelivery: setDelivery
  retrieveOrder: getOrder
  addContactInfo: setContactInfo