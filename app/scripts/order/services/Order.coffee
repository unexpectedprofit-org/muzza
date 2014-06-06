angular.module('Muzza.order').service 'OrderService', (ShoppingCartService,$firebase, OrderRef) ->

  order = {}

  setDelivery = (option)->
    order.delivery = option

  getOrder = ()->
    order

  setContactInfo = (contact)->
    order.contact = contact

  createOrder = (cart)->
    angular.extend(order, cart)

  sendOrder = ->
    order.totalPrice = order.totalPrice()
    ref = OrderRef(order.contact.phone)
    fireOrder = $firebase(ref)
    fireOrder.$set(order)
#   TODO: clean order and references

  getDelivery =  ->
    order.delivery

  getContactInfo = ->
    order.contact

  chooseDelivery: setDelivery
  retrieveOrder: getOrder
  addContactInfo: setContactInfo
  createOrder: createOrder
  submitOrder: sendOrder
  retrieveDelivery: getDelivery
  retrieveConnectionInfo: getContactInfo