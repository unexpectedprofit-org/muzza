angular.module("Muzza.services", ['Muzza.constants'])

angular.module("Muzza.services").factory "StoreService", () ->

  class StoreDetailsObject
    constructor: ( data ) ->
      @id = data.id
      @name = data.name_fantasy
      @address = data.address.street + " " + data.address.door + " - " + data.address.hood + " (" +  data.address.area + ")"
      @tel = data.phone.main + " / " + data.phone.other + " / " + data.phone.cel


  getStores = () ->
    ######################### back end data
    stores =
    [
      {
        "id": 1,
        "name_real": "Juancho S.R.L.",
        "name_fantasy": "La pizzeria de Juancho",

        "address": {
          "street": "Av. Rivadavia",
          "door": 5100,
          "zip": "1406",
          "hood": "Caballito",
          "area": "Capital Federal",
          "state": "Buenos Aires"
        },

        "phone": {
          "main": "4444 5555",
          "other": "1111 2222",
          "cel": "15 4444 9999"
        }
      },
      {
        "id": 2,
        "name_real": "Las 10 porciones S.R.L.",
        "name_fantasy": "Pizzeria la tengo mas grande",

        "address": {
          "street": "Av. Juan B. Alberdi",
          "door": 3200,
          "zip": "1406",
          "hood": "Flores",
          "area": "Capital Federal",
          "state": "Buenos Aires"
        },

        "phone": {
          "main": "2222 8898",
          "other": "1234 4444",
          "cel": "15 0000 2222"
        }
      }
    ]
    ######################### back end data

    returnStores = []

    angular.forEach stores, ( elem ) ->
      returnStores.push new StoreDetailsObject elem

    return returnStores

  listStores: getStores


angular.module("Muzza.services").service 'ShoppingCartService', ()->

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


angular.module("Muzza.services").factory "ProductService", (stores) ->

  class MenuObject
    constructor: ( data ) ->
      @products = @getProducts data

    getProducts: ( data ) ->
      {
        pizza:  data.pizza or []
        empanada: data.empanada or []
      }

  getStoreMenu = ( storeId ) ->
    ######################### back end data
    storeProducts1 = stores.store1.products
    storeProducts2 = stores.store1.products

    id = parseInt( storeId ) or 1
    if id is 1
      responseData = storeProducts1
    else
      responseData = storeProducts2
    ######################### back end data

    return new MenuObject responseData

  listMenuByStore: getStoreMenu

angular.module("Muzza.services").factory "OrderService", () ->

  class OrderDetailsObject
    constructor: ( data ) ->
      @number = "AXAHA263920"
      @date = "15-feb-2010"
      @total =  100.20
      @contact =
        name: "Gonzalo"
        tel: "1111 2222"
        email: "gonzalo.docarmo@gmail.com"
        isDelivery: true
        address: "Av. Gonzalo 5100 - Capital"
      @products = {}

  submitOrder = () ->
    ######################### back end data
    return new OrderDetailsObject {}

  placeOrder: submitOrder
