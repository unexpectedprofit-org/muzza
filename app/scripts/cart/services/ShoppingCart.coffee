angular.module("Muzza.cart").service 'ShoppingCartService', ($rootScope)->

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
    products.push item
    notifyTotalPriceChange()

  removeItem = (id) ->
    previousLengthBeforeRemoval = products.length
    _.remove( products, (elem) ->
      elem.cartItemKey is id
    )
    notifyTotalPriceChange() unless previousLengthBeforeRemoval is products.length

  calculateTotalPrice = () ->
    totalPrice = 0

    angular.forEach products, (product) ->
      totalPrice += product.qty * product.totalPrice

    totalPrice


  getItems = () ->
    products

  removeAllItems = () ->
    products = []
    notifyTotalPriceChange()

  notifyTotalPriceChange = () ->
    $rootScope.$broadcast 'CART:PRICE_UPDATED', calculateTotalPrice()


  getCart: getItems
  emptyCart: removeAllItems
  getTotalPrice: calculateTotalPrice

  add: addItem
  remove: removeItem
  get: getItem