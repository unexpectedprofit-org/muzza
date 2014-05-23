angular.module("Muzza.cart").service 'ShoppingCartService', ()->

  products = []


  getItem = (hashKey) ->
    _.find( products, (elem) ->
      elem.hash is hashKey
    )

  addItem = (item) ->
    itemSearched = getItem item.hash

    if angular.isUndefined itemSearched
      products.push item
    else
      itemSearched.qty += item.qty

  #    console.log "Item added to cart: " + JSON.stringify item

  removeItem = (hashKey) ->
    _.remove( products, (elem) ->
      elem.hash is hashKey
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