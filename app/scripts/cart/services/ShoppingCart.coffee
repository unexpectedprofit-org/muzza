angular.module("Muzza.cart").service 'ShoppingCartService', ()->

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

  removeItem = (id) ->
    _.remove( products, (elem) ->
      elem.cartItemKey is id
    )

  calculateTotalPrice = () ->
    totalPrice = 0

    angular.forEach products, (product) ->
      totalPrice += product.qty * product.totalPrice

    totalPrice


  getItems = () ->
    products

  removeAllItems = () ->
    products = []


  getCart: getItems
  emptyCart: removeAllItems
  getTotalPrice: calculateTotalPrice

  add: addItem
  remove: removeItem
  get: getItem