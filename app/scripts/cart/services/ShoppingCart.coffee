angular.module("Muzza.cart").service 'ShoppingCartService', (StoreService, Delivery, Contact, OrderService)->

  products = []


  getItem = (id) ->
    _.find( products, (elem) ->
      elem.cartItemKey is id
    )

  generateItemKey = ()->
    _.uniqueId('cart_')

  addItem = (item) ->
    id = item.cartItemKey
    if id
      removeItem id
    else
      item.cartItemKey = generateItemKey()
      item.hashKey = item.getHash()
    products.push item

  removeItem = (id) ->
    previousLengthBeforeRemoval = products.length
    _.remove( products, (elem) ->
      elem.cartItemKey is id
    )

  calculateTotalPrice = () ->
    totalPrice = 0
    angular.forEach products, (product) ->
      totalPrice += product.qty * product.calculateTotalPrice()

    totalPrice


  getItems = () ->
    products

  removeAllItems = () ->
    products = []

  getMinimumAmount = () ->
    deliveryOption = getDeliveryMethod()
    store = getStore()
    store.order.minPrice[deliveryOption]

  isOrderEligible = () ->
    if getItems().length is 0 then return {success: false,reason:"NO_PRODUCTS"}
    if getStore() is undefined then return {success: false,reason:"NO_STORE"}
    if calculateTotalPrice() < getMinimumAmount() then return {success:false,reason:"NO_MIN_AMOUNT"}
    return {success:true}

  getStore = ()->
    StoreService.retrieveSelectedStore() or undefined

  getDeliveryMethod = ()->
    Delivery.retrieveDelivery()

  retrieveContact = ()->
    Contact.retrieveContactInfo().then (contactInfo) ->
      contactInfo

  submitOrder = (cart)->
    cart.store = getStore()
    cart.delivery = getDeliveryMethod()

    #TODO: Call retrieveContact instead of dupe this same code
    Contact.retrieveContactInfo().then (contactInfo) ->
      cart.contact = contactInfo
      OrderService.createOrder cart


  getCart: getItems
  emptyCart: removeAllItems
  getTotalPrice: calculateTotalPrice
  checkEligibility: isOrderEligible
  add: addItem
  remove: removeItem
  get: getItem
  checkout: submitOrder
  getContact: retrieveContact