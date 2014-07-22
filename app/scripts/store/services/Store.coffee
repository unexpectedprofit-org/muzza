angular.module("Muzza.stores").service "StoreService", (StoreFileAdapter) ->

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
    StoreFileAdapter.getBranches().then (response) ->
      returnStores = []

      angular.forEach response.data, ( elem ) ->
        returnStores.push new StoreDetailsObject elem

      return returnStores

  listStores: getStores