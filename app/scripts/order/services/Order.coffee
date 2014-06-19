angular.module('Muzza.order').service 'OrderService', (ShoppingCartService,$firebase, OrderRef, Geo, $q) ->

  order = {}
  store =
    id: 3
    delivery:
      latLong:
        k: -34.591809
        A: -58.3959331
      radio: 2

  setDelivery = (option)->
    order.delivery = option

  getOrder = ()->
    order

  setContactInfo = (contact)->

    deferred = $q.defer()

    success = ->
      order.contact = contact
      deferred.resolve()

    fail = (errorMsg)->
      deferred.reject(errorMsg)

    delivery = getDelivery()

    if delivery is 'pickup' then success()

    if delivery is 'delivery'

      validateDelivery = Geo.validateDeliveryRadio(contact.address, store.delivery)

      validateDelivery.then (isWithinDeliveryRadio)->

        if isWithinDeliveryRadio
          order.store = store
          success()
        else
          fail('No esta en el radio de delivery del local')

      , (errorMsg)->
        fail(errorMsg)

    deferred.promise


  createOrder = (cart)->
    angular.extend(order, cart)

  sendOrder = ->
    deferred = $q.defer()
    order.totalPrice = order.totalPrice()
    ref = OrderRef(order.store.id, order.contact.phone)
    fireOrder = $firebase(ref)
    fireOrder.$set(order)
    deferred.resolve()
    deferred.promise
#   TODO: clean order and references

  getDelivery =  ->
    order.delivery

  getContactInfo = ->
    order.contact

  setPickupStore = (store)->
    deferred = $q.defer()
    order.store = store
    deferred.resolve()
    deferred.promise

  getMinimumAmount = () ->
    #need to be updated when logic for selecting stores is updated
    #since delivery still needs a store to deliver from
    if true
      order.store.order.minPrice['delivery']
    else
      order.store.order.minPrice['pickup']


  isOrderEligible = () ->

    if ShoppingCartService.getCart().length is 0 then return {success: false,reason:"NO_PRODUCTS"}

    if order.store is undefined then return {success: false,reason:"NO_STORE"}

    if ShoppingCartService.getTotalPrice() < getMinimumAmount() then return {success:false,reason:"NO_MIN_AMOUNT"}

    {success:true}


  chooseDelivery: setDelivery
  retrieveOrder: getOrder
  addContactInfo: setContactInfo
  createOrder: createOrder
  submitOrder: sendOrder
  retrieveDelivery: getDelivery
  retrieveConnectionInfo: getContactInfo
  chooseStore: setPickupStore
  retrieveMinimumAmount: getMinimumAmount
  checkEligibility: isOrderEligible