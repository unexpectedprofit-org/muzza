angular.module("Muzza.services", [])

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


angular.module("Muzza.services").service 'ShoppingCart', ($log)->

  cart = []

  add = (toBeAddedItem)->
#    TODO: we have a limitation by id with this.
#    Need to create unique ids and handle qtys if it comes a duplicate request
    existingItem = @getItemById(toBeAddedItem.id)
    if existingItem == undefined
      cart.push(toBeAddedItem)
    else
      cart = _.map cart, (item) ->
        if item.id == toBeAddedItem.id then toBeAddedItem else item

  getAll = ->
    cart

  getById = (id)->
    results = _.filter cart, (item)->
      item.id is parseInt id
    results[0]

  addToCart: add
  getCart: getAll
  getItemById: getById

angular.module("Muzza.services").factory "ProductService", () ->

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
    storeProducts1 = {
      "empanada": [
        {
          "id": 1,
          "desc": "Al Horno",
          "prod": [
            {
              "id": 1
              "desc": "Carne cortada a cuchillo"
              "topp": [ "Carne", "Huevo", "Morron" ]
              "price": 18
            },
            {
              "id": 2
              "desc": "Calabresa"
              "topp": [ "Muzzarella", "Longaniza", "Salsa" ]
              "price": 18
            },
            {
              "id": 3
              "desc": "Cebolla y queso"
              "topp": [ "Muzzarella", "Cebolla" ]
              "price": 18
            },
            {
              "id": 4
              "desc": "Pollo"
              "topp": [ "Pollo", "Cebolla" ]
              "price": 18
            },
            {
              "id": 5
              "desc": "Carne picante"
              "topp": [ "Carne", "Cebolla" ]
              "price": 18
            },
            {
              "id": 6
              "desc": "Verdura"
              "topp": [ "Espinaca", "Huevo", "Salsa Blanca" ]
              "price": 18
            }
          ]
        },
        {
          "id": 2,
          "desc": "Fritas",
          "prod": [
            {
              "id": 7
              "desc": "Cebolla y queso"
              "topp": [ "Muzzarella", "Cebolla" ]
              "price": 18
            },
            {
              "id": 8
              "desc": "Pollo"
              "topp": [ "Pollo", "Cebolla" ]
              "price": 20
            },
            {
              "id": 9
              "desc": "Verdura"
              "topp": [ "Espinaca", "Huevo", "Salsa Blanca" ]
              "price": 20
            }
          ]
        }
      ],
      "pizza": [
        {
          id: 1
          "desc": "Muzzarella"
          "type": "pizza"
          "topp": [ "Muzzarella", "Salsa tomate", "Aceitunas" ]
          "price" : {
            base: 5000
            size:
              individual: 0
              chica: 1000
              grande: 2000
            dough:
              "a la piedra": 2
              "al molde": 3
          }
        },
        {
          id: 2
          "desc": "Fuggazetta"
          "type": "pizza"
          "topp": [ "Muzzarella", "Cebollas" ]
          "price" : {
            base: 5500
            size:
              individual: 0
              chica: 1500
              grande: 2000
            dough:
              "a la piedra": 0
              "al molde": 0
          }
        },
        {
          id: 3
          "desc": "Jamon y Morrones"
          "type": "pizza"
          "topp": [ "Muzzarella", "Jamon", "Morron" ]
          "price" : {
            base: 7500
            size:
              individual: 0
              chica: 1000
              grande: 1500
            dough:
              "a la piedra": 0
              "al molde": 0
          }
        },
        {
          id: 4
          "desc": "Calabresa"
          "type": "pizza"
          "topp": [ "Muzzarella", "Longaniza", "Salsa" ]
          "price" : {
            base: 5000
            size:
              individual: 0
              chica: 1000
              grande: 2000
            dough:
              "a la piedra": 0
              "al molde": 0
          }
        }
      ]
    }
    storeProducts2 = {
      "pizza": [
        {
          "desc": "Muzzarella"
          "topp": [ "Muzzarella", "Salsa tomate", "Aceitunas" ]
          "price": [ 22, 55, 77 ]
        },
        {
          "desc": "Espinaca y Salsa Blanca"
          "topp": [ "Muzzarella", "Espicana", "Salsa Blanca" ]
          "price": [ 80, 82, 85 ]
        },
        {
          "desc": "Jamon y Morrones"
          "topp": [ "Muzzarella", "Jamon", "Morron" ]
          "price": [ 40, 60, 95 ]
        }
      ],
      "empanada": [
        {
          "id": 1,
          "desc": "Fritas",
          "prod": [
            {
              "id": 10
              "desc": "Humita"
              "topp": [ "Choclo", "Salsa Blanca" ]
              "price": 17
            },
            {
              "id": 11
              "desc": "Jamon y Queso"
              "topp": [ "Muzzarella", "Jamon", "Oregano" ]
              "price": 17
            },
            {
              "id": 12
              "desc": "Carne Suava"
              "topp": [ "Muzzarella", "Longaniza", "Salsa" ]
              "price": 17
            },
            {
              "id": 13
              "desc": "Carne Picante"
              "topp": [ "Carne", "Cebolla", "Huevo" ]
              "price": 17
            }
          ]
        },
        {
          "id": 2,
          "desc": "Horno",
          "prod": [
            {
              "id": 14
              "desc": "Humita"
              "topp": [ "Choclo", "Salsa Blanca" ]
              "price": 23
            },
            {
              "id": 15
              "desc": "Jamon y Queso"
              "topp": [ "Muzzarella", "Jamon", "Oregano" ]
              "price": 23
            },
            {
              "id": 16
              "desc": "Carne Suava"
              "topp": [ "Muzzarella", "Longaniza", "Salsa" ]
              "price": 23
            }
          ]
        }
      ]
    }

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
