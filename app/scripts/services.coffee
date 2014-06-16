angular.module("Muzza.services", ['Muzza.constants', 'Muzza.pizzas', 'Muzza.empanadas', 'Muzza.bebidas', 'Muzza.promo'])

angular.module("Muzza.services").factory "StoreService", (days, DateService) ->

  class StoreDetailsObject
    constructor: ( data ) ->
      @id = data.id
      @name = data.name_fantasy
      @address = data.address.street + " " + data.address.door + " - " + data.address.hood + " (" +  data.address.area + ")"
      @tel = data.phone.main + " / " + data.phone.other + " / " + data.phone.cel
      @hours =
        byDay: contructHours data.hours

      @hours.isOpen = @isOpen @hours.byDay


    isOpen: (dayHours) ->
      today = DateService.nowMoment().day()

      todayElem = dayHours[today]

      continueSearching = true

      try

        horas = todayElem.hours
        _.forEach horas, (tempHours) ->


          if continueSearching
  #          console.log "loop " + JSON.stringify tempHours
    #        console.log "tempHours.start: " + tempHours.start
    #        console.log "tempHours.end: " + tempHours.end

            startMoment = DateService.specificMomentField( tempHours.start, 'HH:mm' )
            endMoment = DateService.specificMomentField( tempHours.end, 'HH:mm' )

            # check in case closing hours after midnight
            # need to be implemented later
            if endMoment.hour() < 8
              throw "isOpen: closing hours after midnight Not yet implemented"
  #            continueSearching = false
  #            return

            #create start range
            testStartMoment = angular.copy DateService.nowMoment()
            testStartMoment.hours( startMoment.hour() )
            testStartMoment.minutes( startMoment.minute() )
            testStartMoment.seconds( 0 )
            testStartMoment.milliseconds( 0 )

            #create end range
            testEndMoment = angular.copy DateService.nowMoment()
            testEndMoment.hour( endMoment.hour() )
            testEndMoment.minutes( endMoment.minute() )
            testEndMoment.seconds( 0 )
            testEndMoment.milliseconds( 0 )

            range = DateService.nowMoment().range( testStartMoment, testEndMoment )


            currentMoment = DateService.nowMoment()

            #########################################
  #          console.log "-----------------------------------------"
  #          console.log "-----------------------------------------"
  #          console.log "Today time:     " + currentMoment.format("dddd, MMMM Do YYYY, H:mm:ss")
  #          console.log "RANGE:start     " + range.start.format("dddd, MMMM Do YYYY, H:mm:ss")
  #          console.log "RANGE:end       " + range.end.format("dddd, MMMM Do YYYY, H:mm:ss")
  #          console.log "-----------------------------------------"
  #          console.log "-----------------------------------------"
            #########################################

            continueSearching = !currentMoment.within range
  #          console.log "res: " + result + " ----- " + "flag:  " +  isOpenFlag
  #          console.log "flag updated:  " +  isOpenFlag
      catch err
        console.log err
        continueSearching = true

      !continueSearching



  contructHours = (hours) ->

    storeHours = []

    todayDayOfWeek = DateService.nowMoment().day()

    _.forEach (_.keys hours), (day) ->
      currentDayHours = hours[day]
      dayName = days.names[day]

      isToday = if todayDayOfWeek is parseInt(day) then true else false

      ###### no hours at all
      if angular.isUndefined( currentDayHours[0] ) and angular.isUndefined( currentDayHours[1] )
        storeHours.push {day:dayName, displayHours:"Cerrado", today:isToday}

      ###### some hours
      else

        currentHours = undefined
        if isToday
          currentHours = []
          _.forEach currentDayHours, (elem) ->
            currentHours.push {start:elem.start, end:elem.end} if elem isnt undefined

        if angular.isDefined( currentDayHours[0] ) and angular.isDefined( currentDayHours[1] )
          currentHoursDisplay = currentDayHours[0].start + " - " + currentDayHours[0].end
          currentHoursDisplay = currentHoursDisplay + "  /  "
          currentHoursDisplay = currentHoursDisplay + currentDayHours[1].start + " - " + currentDayHours[1].end
          storeHours.push {day:dayName, displayHours:currentHoursDisplay,hours:currentHours,today:isToday}

        else if angular.isDefined( currentDayHours[0] )
          storeHours.push {day:dayName, displayHours:currentDayHours[0].start + " - " + currentDayHours[0].end,hours:currentHours,today:isToday}

        else
          storeHours.push {day:dayName, displayHours:currentDayHours[1].start + " - " + currentDayHours[1].end,hours:currentHours,today:isToday}

    storeHours


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

        "hours": {
          0: [undefined,undefined],
          1: [{start:"12:00",end:"14:00"},undefined],
          2: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
          3: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
          4: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
          5: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
          6: [undefined,{start:"18:30",end:"23:59"}]
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
        },

        "hours": {
          0: [{start:"10:30",end:"13:00"},undefined],
          1: [{start:"12:00",end:"14:00"},{start:"19:00",end:"21:00"}],
          2: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
          3: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
          4: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
          5: [undefined,undefined],
          6: [undefined,undefined]
        }
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


angular.module('Muzza.services').service 'DateService', () ->

  getNowMoment = () ->
    moment()

  getSpecificMomentField = ( field, format ) ->
    moment( field, format )


  nowMoment: getNowMoment
  specificMomentField: getSpecificMomentField