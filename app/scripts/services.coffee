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

      @hours.openInfo = @isOpen @hours.byDay


    getPreviousDay = (day) ->
      switch day
        when 0 then previous = 6
        when 1 then previous = 0
        when 2 then previous = 1
        when 3 then previous = 2
        when 4 then previous = 3
        when 5 then previous = 4
        when 6 then previous = 5
      previous

    isOpen: (dayHours) ->

      currentMoment = DateService.nowMoment()
      currentMomentHour = currentMoment.hour()
      today = currentMoment.day()
      todayElem = dayHours[today]

      continueSearching = true

      openDayIndex = -1
      horas = todayElem.hours
      _.forEach horas, (tempHours) ->

        if continueSearching

          startMoment = DateService.specificMomentField( tempHours.start, 'HH:mm' )
          endMoment = DateService.specificMomentField( tempHours.end, 'HH:mm' )

          # check current time agains after midnight
          if currentMomentHour < 6
            # now past midnight
            previousDayIndex = getPreviousDay today

            previousDayTimeframes = dayHours[previousDayIndex].hours

            if previousDayTimeframes.length is 0
              return;

            previousDayLastTimeframe = previousDayTimeframes[previousDayTimeframes.length - 1]
            previousDayLastTimeframe_endTimeMoment = angular.copy DateService.specificMomentField( previousDayLastTimeframe.end, 'HH:mm' )
            previousDayLastTimeframe_endTimeMoment_hour = previousDayLastTimeframe_endTimeMoment.hour()

            # arbitrary number may need to change
            # previous day has closing time after midnight
            if previousDayLastTimeframe_endTimeMoment_hour > 12
              #CERRADO
              return;

            previousDayLastTimeframe_endTimeMoment.year( currentMoment.year() )
            previousDayLastTimeframe_endTimeMoment.month( currentMoment.month() )
            previousDayLastTimeframe_endTimeMoment.date( currentMoment.date() )


#            console.log "end time - year:  " + previousDayLastTimeframe_endTimeMoment.year()
#            console.log "end time - month: " + previousDayLastTimeframe_endTimeMoment.month()
#            console.log "end time - day:   " + previousDayLastTimeframe_endTimeMoment.date()
#            console.log "end time - hour:  " + previousDayLastTimeframe_endTimeMoment.hour()
#            console.log "end time - minute:" + previousDayLastTimeframe_endTimeMoment.minute()
#
#            console.log "currentMoment time - year:   " + currentMoment.year()
#            console.log "currentMoment time - month:  " + currentMoment.month()
#            console.log "currentMoment time - day:    " + currentMoment.date()
#            console.log "currentMoment time - hour:   " + currentMoment.hour()
#            console.log "currentMoment time - minute: " + currentMoment.minute()


            minutes_now = currentMoment.hour() * 60 + currentMoment.minute()
            minutes_end = previousDayLastTimeframe_endTimeMoment.hour() * 60 + previousDayLastTimeframe_endTimeMoment.minute()

            if minutes_now > minutes_end
#            if currentMoment.isAfter previousDayLastTimeframe_endTimeMoment)
              # CERRADO
              return

            else
              # OPEN
              continueSearching = false
              openDayIndex = previousDayLastTimeframe_endTimeMoment.day() - 1

          else
            # now before midnight

            #create start range
            testStartMoment = angular.copy currentMoment
            testStartMoment.hours( startMoment.hour() )
            testStartMoment.minutes( startMoment.minute() )
            testStartMoment.seconds( 0 )
            testStartMoment.milliseconds( 0 )

            #create end range
            testEndMoment = angular.copy currentMoment
            testEndMoment.hour( endMoment.hour() )
            testEndMoment.minutes( endMoment.minute() )
            testEndMoment.seconds( 0 )
            testEndMoment.milliseconds( 0 )

            if endMoment.hour() < 6
              # after midnight then incrementing a day
              testEndMoment.date( testEndMoment.date() + 1 )

            range = DateService.nowMoment().range( testStartMoment, testEndMoment )

            #########################################
  #          console.log "-----------------------------------------"
  #          console.log "-----------------------------------------"
  #          console.log "Today time:     " + currentMoment.format("dddd, MMMM Do YYYY, H:mm:ss")
  #          console.log "RANGE:start     " + range.start.format("dddd, MMMM Do YYYY, H:mm:ss")
  #          console.log "RANGE:end       " + range.end.format("dddd, MMMM Do YYYY, H:mm:ss")
  #          console.log "-----------------------------------------"
  #          console.log "-----------------------------------------"
            #########################################

            if currentMoment.within range
              continueSearching = false
              openDayIndex = testStartMoment.day()
      #          console.log "res: " + result + " ----- " + "flag:  " +  isOpenFlag
  #          console.log "flag updated:  " +  isOpenFlag

      {
        isOpen: !continueSearching
        day: openDayIndex
      }



  contructHours = (hours) ->

    storeHours = []

    todayDayOfWeek = DateService.nowMoment().day()

    _.forEach (_.keys hours), (day) ->
      currentDayHours = hours[day]
      dayName = days.names[day]

      isToday = todayDayOfWeek is parseInt(day)

      currentHours = []

      ###### no hours at all
      if angular.isUndefined( currentDayHours[0] ) and angular.isUndefined( currentDayHours[1] )
        storeHours.push {day:dayName, displayHours:"Cerrado", today:isToday,hours:currentHours}

      ###### some hours
      else

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
          1: [{start:"12:00",end:"14:00"},{start:"19:30",end:"03:00"}],
          2: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
          3: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
          4: [{start:"11:30",end:"15:00"},{start:"19:30",end:"01:00"}],
          5: [{start:"11:30",end:"15:00"},{start:"19:30",end:"02:30"}],
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