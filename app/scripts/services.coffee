angular.module("Muzza.services", ['Muzza.constants', 'Muzza.pizzas', 'Muzza.empanadas'])

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


angular.module("Muzza.services").service "ProductService", (stores, Pizza, Empanada) ->

  getProductsByCompanyId = (id, category)->
    results =
      pizza: _.map stores.store1.products['pizza'], constructPizzas
      empanada: _.map stores.store1.products['empanada'], constructEmpanadas
      promo: stores.store1.products.promotion

    # This should become two different methods executing either diff queries,
    # or fetching form cache...who knows?
    if category?
      menu = {}
      menu[category] = results[category]
    else
      menu = results

    menu

  constructPizzas = (pizzaCategory)->
    pizzaCategory.products = _.map pizzaCategory.products, (pizza)->
      new Pizza pizza
    pizzaCategory

  constructEmpanadas = (empanadaCategory)->
    empanadaCategory.products = _.map empanadaCategory.products, (empanada)->
      empanada.type = empanadaCategory.desc
      new Empanada empanada
    empanadaCategory


  getMenu: getProductsByCompanyId



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
