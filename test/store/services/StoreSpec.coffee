fakeDate = undefined
oldDate = Date
Date = ()->
  new oldDate(fakeDate)

describe "Store service", ->
  StoreService = StoreFileAdapter = newStores = undefined

  beforeEach ->
    module 'Muzza.store'


  beforeEach ->
    inject ($injector) ->
      stubJSONResponse =
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

          "displayOpenHours": {
            "Domingo": [],
            "Lunes": [
              ["12:00", "14:00"],
              ["19:30", "03:00"]
            ],
            "Martes": [
              ["11:30", "15:00"],
              ["19:30", "22:00"]
            ],
            "Miercoles": [
              ["11:30", "15:00"],
              ["19:30", "22:00"]
            ],
            "Jueves": [
              ["11:30", "15:00"],
              ["19:30", "01:00"]
            ],
            "Viernes": [
              ["11:30", "15:00"],
              ["19:30", "02:30"]
            ],
            "Sabado": [
              ["18:30", "03:00"]
            ]
          },
          "order": {

            "minPrice": {
              "delivery": 6000,
              "pickup": 8000
            }
          }
        }
      ]

      StoreService = $injector.get 'StoreService'
      StoreFileAdapter = $injector.get 'StoreFileAdapter'
      spyOn(StoreFileAdapter, 'getBranches').and.returnValue {then: (callback) -> callback(data:stubJSONResponse)}

  it "should create a list of store objects", ->

    newStores = StoreService.listStores()

    expected = {
      name: "La pizzeria de Juancho"
      address: "Av. Rivadavia 5100 - Caballito (Capital Federal)"
      tel: "4444 5555 / 1111 2222 / 15 4444 9999"
    }

    expect( newStores[0].name ).toEqual expected.name
    expect( newStores[0].address ).toEqual expected.address
    expect( newStores[0].tel ).toEqual expected.tel

  it "should create a hoursInfo object", ->
    expectedDisplayOpenHours =
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

    fakeDate = "January 1, 2014 11:30:00"
    newStores = StoreService.listStores()


    expect(newStores[0].hoursInfo.displayHours).toEqual expectedDisplayOpenHours
    expect(newStores[0].hoursInfo.displayDays).toEqual _.keys expectedDisplayOpenHours
    expect(newStores[0].hoursInfo.todayDayOfWeek).toEqual 3


  describe "wednesday", ->
#         Miercoles: [
#          ['11:30', '15:00']
#          ['19:30', '22:00']

    describe "open/close", ->

      it "should be open as soon as it opens - 1", ->
        fakeDate = "January 1, 2014 11:30:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeTruthy()

      it "should be open as soon as it opens - 2", ->
        fakeDate = "January 1, 2014 19:30:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeTruthy()

      it "should be open during working hours - 3", ->
        fakeDate = "January 1, 2014 14:30:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeTruthy()

      it "should be open during working hours - 4", ->
        fakeDate = "January 1, 2014 21:45:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeTruthy()

      it "should be closed as soon as it closes - 5", ->
        fakeDate = "January 1, 2014 15:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeFalsy()

      it "should be closed as soon as it closes - 6", ->
        fakeDate = "January 1, 2014 22:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeFalsy()

      it "should be closed during non-working hours - 7", ->
        fakeDate = "January 1, 2014 10:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeFalsy()

      it "should be closed during non-working hours - 8", ->
        fakeDate = "January 1, 2014 17:25:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeFalsy()

      it "should be closed during non-working hours - 9", ->
        fakeDate = "January 1, 2014 23:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeFalsy()


    describe "time to open/close", ->

      it "should have open message - 1", ->
        fakeDate = "January 1, 2014 10:45:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToOpen).toBe 45

      it "should have open message - 2", ->
        fakeDate = "January 1, 2014 11:29:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToOpen).toBe 1

      it "should have open message - 3", ->
        fakeDate = "January 1, 2014 19:29:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToOpen).toBe 1

      it "should NOT have open/close message - 4", ->
        fakeDate = "January 1, 2014 09:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToOpen).toBeUndefined()
        expect(newStores[0].hoursInfo.timeToClose).toBeUndefined()

      it "should NOT have open/close message - 5", ->
        fakeDate = "January 1, 2014 17:30:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToOpen).toBeUndefined()
        expect(newStores[0].hoursInfo.timeToClose).toBeUndefined()

      it "should NOT have open/close message - 6", ->
        fakeDate = "January 1, 2014 11:30:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToOpen).toBeUndefined()
        expect(newStores[0].hoursInfo.timeToClose).toBeUndefined()

      it "should NOT have open/close message - 7", ->
        fakeDate = "January 1, 2014 19:30:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToOpen).toBeUndefined()
        expect(newStores[0].hoursInfo.timeToClose).toBeUndefined()

      it "should have close message - 8", ->
        fakeDate = "January 1, 2014 14:59:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToClose).toBe 1

      it "should have close message - 9", ->
        fakeDate = "January 1, 2014 14:30:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToClose).toBe 30

      it "should NOT have close message - 10", ->
        fakeDate = "January 1, 2014 21:45:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToClose).toBe 15

      it "should NOT have open/close message - 11", ->
        fakeDate = "January 1, 2014 15:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToOpen).toBeUndefined()
        expect(newStores[0].hoursInfo.timeToClose).toBeUndefined()

      it "should NOT have open/close message - 12", ->
        fakeDate = "January 1, 2014 22:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToOpen).toBeUndefined()
        expect(newStores[0].hoursInfo.timeToClose).toBeUndefined()

      it "should NOT have open/close message - 13", ->
        fakeDate = "January 1, 2014 22:10:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToOpen).toBeUndefined()
        expect(newStores[0].hoursInfo.timeToClose).toBeUndefined()


  describe "friday", ->
#         Jan 3rd Viernes
#          ['11:30', '15:00']
#          ['19:30', '02:30']

    describe "open/close", ->

      it "should be open - 1", ->
        fakeDate = "January 4, 2014 01:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeTruthy()

      it "should be close - 2", ->
        fakeDate = "January 4, 2014 03:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeFalsy()

      it "should be open - 3", ->
        fakeDate = "January 4, 2014 02:15:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeTruthy()

    describe "time to open/close", ->

      it "should NOT have open/close message - 1", ->
        fakeDate = "January 3, 2014 23:59:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToOpen).toBeUndefined()
        expect(newStores[0].hoursInfo.timeToClose).toBeUndefined()

      it "should NOT have open/close message - 2", ->
        fakeDate = "January 4, 2014 01:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToOpen).toBeUndefined()
        expect(newStores[0].hoursInfo.timeToClose).toBeUndefined()

      it "should have close message - 3", ->
        fakeDate = "January 4, 2014 02:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToClose).toBe 30

      it "should NOT have close message - 4", ->
        fakeDate = "January 4, 2014 02:30:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToClose).toBeUndefined()


  describe "sunday", ->
#        Sabado: [
#          ['18:30', '03:00']
#        Domingo: []
#        Lunes: [
#          ['12:00', '14:00']
#          ['19:30', '03:00']
#        Jan 5th 2014 was a Sunday

    describe "open/close", ->

      it "should be open - 1", ->
        fakeDate = "January 5, 2014 02:45"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeTruthy()

      it "should be open - 2", ->
        fakeDate = "January 5, 2014 00:45"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeTruthy()

      it "should be closed - 3", ->
        fakeDate = "January 5, 2014 03:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeFalsy()

      it "should be close - 4", ->
        fakeDate = "January 5, 2014 09:30:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeFalsy()

      it "should be close past midnight - 5", ->
        fakeDate = "January 6, 2014 01:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeFalsy()


  describe "tuesday", ->
#          ['11:30', '15:00']
#          ['19:30', '22:00']
#        Jan 7th 2014 was a Tuesday

    describe "time to open/close", ->

      it "should have open message - 1", ->
        fakeDate = "January 7, 2014 11:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToOpen).toBe 30

      it "should have open message - 2", ->
        fakeDate = "January 7, 2014 19:15:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToOpen).toBe 15

      it "should have close message - 3", ->
        fakeDate = "January 7, 2014 14:30:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToClose).toBe 30

      it "should have close message - 4", ->
        fakeDate = "January 7, 2014 21:50:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToClose).toBe 10

  describe "monday", ->
#      Domingo: []
#        Lunes: [
#          ['12:00', '14:00']
#          ['19:30', '03:00']
#        ]
#      Jan 6th Monday

    describe "open/close", ->

      it "should be closed - 1", ->
        fakeDate = "January 6, 2014 01:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.isOpen).toBeFalsy()

    describe "time to open/close", ->

      it "should NOT have open/close message - 1", ->
        fakeDate = "January 6, 2014 01:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].hoursInfo.timeToOpen).toBeUndefined()
        expect(newStores[0].hoursInfo.timeToClose).toBeUndefined()