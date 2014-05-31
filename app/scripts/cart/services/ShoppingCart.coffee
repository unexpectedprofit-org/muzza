angular.module("Muzza.cart").service 'ShoppingCartService', ($rootScope)->

  products = []
  promotions = []


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


  addPromo = (promoItem) ->
    promotions[0] = promoItem

  retrievePromos = () ->
    promotions

  removePromo = (promoId) ->
    _.remove( promotions, (elem) ->
      elem.details.id is promoId
    )

  retrieveApplicablePromos = () ->
#    console.log "prod " + products
#    console.log "promos " + promotions

    applicablePromos = _.filter promotions, (elem) ->

      #depending on elem.type of promo
      result = elem.validate products
      result is true
    applicablePromos

  notifyTotalPriceChange = () ->
    $rootScope.$broadcast 'CART:PRICE_UPDATED', calculateTotalPrice()


  getCart: getItems
  emptyCart: removeAllItems
  getTotalPrice: calculateTotalPrice

  add: addItem
  remove: removeItem
  get: getItem

  addPromotion: addPromo
  getPromotions: retrievePromos
  removePromotion: removePromo
  getApplicablePromotions: retrieveApplicablePromos