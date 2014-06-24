angular.module("Muzza.services", ['Muzza.constants', 'Muzza.pizzas', 'Muzza.empanadas', 'Muzza.bebidas', 'Muzza.promo'])

angular.module("Muzza.services").factory "StoreService", (days) ->

  getDayName = (index)->
    days = ['Domingo','Lunes','Martes','Miercoles','Jueves','Viernes','Sabado']
    days[index]

  class StoreDetailsObject
    constructor: ( data ) ->
      @id = data.id
      @name = data.name_fantasy
      @address = data.address.street + " " + data.address.door + " - " + data.address.hood + " (" +  data.address.area + ")"
      @tel = data.phone.main + " / " + data.phone.other + " / " + data.phone.cel
      @order = data.order

      @hoursInfo = @constructHoursInfo data.displayOpenHours


    constructHoursInfo: ( displayOpenHours ) ->
      displayHours = displayOpenHours
      todayDayOfWeek =  new Date().getDay()

      objectToReturn =
        displayHours: displayHours
        displayDays:  _.keys displayOpenHours
        todayDayOfWeek: todayDayOfWeek


      isOpen = false

      minutesToOpen = undefined
      minutesToClose  = undefined

      todayHourRanges = displayHours[ getDayName todayDayOfWeek ]
      currentRanges = todayHourRanges

      rightNow = new Date()
      open = new Date()
      closed = new Date()

      # if right now is passed midnight
      if rightNow.getHours() >= 0 and rightNow.getHours() < 6

        previousDay = (if todayDayOfWeek is 0 then 6 else todayDayOfWeek - 1)
        yesterdayHourRanges = displayHours[ getDayName previousDay ]

        # if previous day was opened
        if yesterdayHourRanges.length > 0
          afterMidnight = _.find(yesterdayHourRanges, (range)-> range[1].substr(0, 2) < 6)

          # if previous service hours did extend after midnight
          if afterMidnight?.length > 0
            currentRanges = yesterdayHourRanges
            open.setDate(rightNow.getDate()-1)
            closed.setDate(rightNow.getDate()-1)
        else
          return angular.extend objectToReturn, {isOpen:isOpen,timeToOpen: minutesToOpen,timeToClose: minutesToClose}


      angular.forEach currentRanges, (range)->

        open.setHours parseInt(range[0].substr(0, 2))
        open.setMinutes parseInt(range[0].substr(3, 2))

        closeHours = parseInt(range[1].substr(0, 2))

        if closeHours < 6 then closed.setDate(open.getDate()+1)

        closed.setHours closeHours
        closed.setMinutes parseInt(range[1].substr(3, 2))

        if rightNow >= open and rightNow < closed
          isOpen = true

          diffMs = closed - rightNow
          differenceInMinutes = Math.round( diffMs / 1000/60 )
          minutesToClose = differenceInMinutes if differenceInMinutes < 60 and differenceInMinutes > 0

        else
          diffMs = open - rightNow
          differenceInMinutes = Math.round( diffMs / 1000/60 )
          minutesToOpen = differenceInMinutes if differenceInMinutes < 60 and differenceInMinutes > 0


      return angular.extend objectToReturn, {isOpen:isOpen,timeToOpen: minutesToOpen,timeToClose: minutesToClose}



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
        },

        displayOpenHours:
          Domingo: []
          Lunes: [
            ['12:00', '14:00']
            ['19:30', '03:00']
          ]
          Martes: [
            ['11:30', '15:00']
            ['19:30', '22:00']
          ]
          Miercoles: [
            ['11:30', '15:00']
            ['19:30', '22:00']
          ]
          Jueves: [
            ['11:30', '15:00']
            ['19:30', '01:00']
          ]
          Viernes: [
            ['11:30', '15:00']
            ['19:30', '02:30']
          ]
          Sabado: [
            ['18:30', '03:00']
          ]
        ,

        order:
          minPrice:
            delivery: 6000
            pickup: 8000
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
        },
        displayOpenHours:
          Domingo: [
            ['10:30', '13:00']
          ]
          Lunes: [
            ['12:00', '14:00']
            ['19:00', '21:00']
          ]
          Martes: [
            ['11:30', '15:00']
            ['19:30', '22:00']
          ]
          Miercoles: [
            ['11:30', '15:00']
            ['19:30', '22:00']
          ]
          Jueves: [
            ['11:30', '15:00']
            ['19:30', '22:00']
          ]
          Viernes: []
          Sabado: []
        ,

        order:
          minPrice:
            delivery: 9000
            pickup: 10000
      }
    ]
    ######################### back end data

    returnStores = []

    angular.forEach stores, ( elem ) ->
      returnStores.push new StoreDetailsObject elem

    return returnStores

  listStores: getStores


angular.module("Muzza.services").service "ProductService", (stores, Pizza, Empanada, Bebida, PromotionTypeFactory) ->

  _menu = undefined

  getProductsByCompanyId = (id, category)->
    results =
      pizza: _.map stores.store1.products['pizza'], constructPizzas
      empanada: _.map stores.store1.products['empanada'], constructEmpanadas
      promo: constructPromotions stores.store1.products['promotion']
      bebida: _.map stores.store1.products['bebida'], constructBebidas

    # This should become two different methods executing either diff queries,
    # or fetching form cache...who knows?
    if category?
      menu = {}
      menu[category] = results[category]
    else
      menu = results

    _menu = menu

    menu


  retrieveProdFromCategory = (categoryId) ->

    switch categoryId
      when "EMPANADA"
        _cat = "empanada"
      when "PIZZA"
        _cat = "pizza"
      when "BEBIDA"
        _cat = "bebida"
      else
        _cat = undefined

    if angular.isUndefined( _menu ) or angular.isUndefined( _menu[_cat] )
      getProductsByCompanyId()

    angular.copy _menu[_cat]





  constructPizzas = (pizzaCategory)->
    pizzaCategory.products = _.map pizzaCategory.products, (pizza)->
      pizza.subcat = pizzaCategory.id
      new Pizza pizza
    pizzaCategory

  constructEmpanadas = (empanadaCategory)->
    empanadaCategory.products = _.map empanadaCategory.products, (empanada)->
      empanada.subcat = empanadaCategory.id
      empanada.type = empanadaCategory.description
      new Empanada empanada
    empanadaCategory

  constructPromotions = (promotions) ->
    allPromos = _.map promotions, (promotion)->
      PromotionTypeFactory.createPromotion promotion
    allPromos

  constructBebidas = (bebidaCategory)->
    bebidaCategory.products = _.map bebidaCategory.products, (bebida)->
      bebida.subcat = bebidaCategory.id
      new Bebida bebida
    bebidaCategory


  getMenu: getProductsByCompanyId
  getProductsFromCategory: retrieveProdFromCategory



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
