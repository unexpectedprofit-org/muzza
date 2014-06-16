describe "services", ->

  beforeEach ->
    module "Muzza.services"


  describe "store service", ->
    StoreService = DateService = newStores = undefined

    beforeEach ->
      inject ($injector) ->
        StoreService = $injector.get 'StoreService'
        DateService = $injector.get 'DateService'

    it "should create a list of store objects", ->

#      jasmine.getJSONFixtures().fixturesPath = 'test/fixtures'
#      dataResponse = getJSONFixture('store.json')

      #      Jan 1st 2014 was a Wednesday = 3
      spyOn(DateService, 'nowMoment').and.returnValue moment("01-01-2014T20:00", "MM-DD-YYYYTHH:mm")
      newStores = StoreService.listStores()

      expected = {
        name: "La pizzeria de Juancho"
        address: "Av. Rivadavia 5100 - Caballito (Capital Federal)"
        tel: "4444 5555 / 1111 2222 / 15 4444 9999"
        hours: [
          {day:"Domingo",hours:"Cerrado"}
          {day:"Lunes",hours:"12:00 - 14:00"}
          {day:"Martes",hours:"11:30 - 15:00  /  19:30 - 22:00"}
          {day:"Miercoles",hours:"11:30 - 15:00  /  19:30 - 22:00"}
          {day:"Jueves",hours:"11:30 - 15:00  /  19:30 - 22:00"}
          {day:"Viernes",hours:"11:30 - 15:00  /  19:30 - 22:00"}
          {day:"Sabado",hours:"18:30 - 23:59"}
        ]
      }



      expect( newStores[0].name ).toEqual expected.name
      expect( newStores[0].address).toEqual expected.address
      expect( newStores[0].tel ).toEqual expected.tel

      expect( newStores[0].hours.byDay[0].day ).toBe 'Domingo'
      expect( newStores[0].hours.byDay[0].displayHours ).toBe expected.hours[0].hours
      expect( newStores[0].hours.byDay[0].hours ).toBeUndefined()

      expect( newStores[0].hours.byDay[1].day ).toBe 'Lunes'
      expect( newStores[0].hours.byDay[1].displayHours ).toBe expected.hours[1].hours
      expect( newStores[0].hours.byDay[1].hours ).toBeUndefined()

      expect( newStores[0].hours.byDay[3].day ).toBe 'Miercoles'
      expect( newStores[0].hours.byDay[3].displayHours ).toBe expected.hours[3].hours
      expect( newStores[0].hours.byDay[3].hours[0].start ).toBe '11:30'
      expect( newStores[0].hours.byDay[3].hours[0].end ).toBe '15:00'
      expect( newStores[0].hours.byDay[3].hours[1].start ).toBe '19:30'
      expect( newStores[0].hours.byDay[3].hours[1].end ).toBe '22:00'

      expect( newStores[0].hours.byDay[6].day ).toBe 'Sabado'
      expect( newStores[0].hours.byDay[6].displayHours ).toBe expected.hours[6].hours
      expect( newStores[0].hours.byDay[6].hours ).toBeUndefined()

      todayDay = _.filter newStores[0].hours.byDay, (elem) ->
        elem.today

      expect(todayDay.length).toBe 1

      todayDay = _.filter newStores[0].hours.byDay, (elem) ->
        elem.hours isnt undefined

      expect(todayDay.length).toBe 1


    describe "open or close", ->

      it "should be open - wednesday - 1", ->
        #      3: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
        #      Jan 1st 2014 was a Wednesday = 3
        spyOn(DateService, 'nowMoment').and.returnValue moment("01-01-2014T20:00", "MM-DD-YYYYTHH:mm")
        newStores = StoreService.listStores()
        expect(newStores[0].hours.isOpen).toBeTruthy()

      it "should be open - wednesday - 2", ->
        #      3: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
        #      Jan 1st 2014 was a Wednesday = 3
        spyOn(DateService, 'nowMoment').and.returnValue moment("01-01-2014T14:15", "MM-DD-YYYYTHH:mm")
        newStores = StoreService.listStores()
        expect(newStores[0].hours.isOpen).toBeTruthy()

      it "should be open - wednesday - 3", ->
        #      3: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
        #      Jan 1st 2014 was a Wednesday = 3
        spyOn(DateService, 'nowMoment').and.returnValue moment("01-01-2014T21:33", "MM-DD-YYYYTHH:mm")
        newStores = StoreService.listStores()
        expect(newStores[0].hours.isOpen).toBeTruthy()

      it "should be open - saturday - 1", ->
        #      6: [undefined,{start:"18:30",end:"02:00"}]
        #      Jan 4th 2014 was a Saturday = 6
        spyOn(DateService, 'nowMoment').and.returnValue moment("01-04-2014T18:30", "MM-DD-YYYYTHH:mm")
        newStores = StoreService.listStores()
        expect(newStores[0].hours.isOpen).toBeTruthy()

      it "should be open - saturday - 2", ->
        #      6: [undefined,{start:"18:30",end:"02:00"}]
        #      Jan 4th 2014 was a Saturday = 6
        spyOn(DateService, 'nowMoment').and.returnValue moment("01-04-2014T22:15", "MM-DD-YYYYTHH:mm")
        newStores = StoreService.listStores()
        expect(newStores[0].hours.isOpen).toBeTruthy()

      it "should be open - saturday - 3", ->
        #      6: [undefined,{start:"18:30",end:"23:59"}]
        #      Jan 4th 2014 was a Saturday = 6
        spyOn(DateService, 'nowMoment').and.returnValue moment("01-04-2014T23:59", "MM-DD-YYYYTHH:mm")
        newStores = StoreService.listStores()
        expect(newStores[0].hours.isOpen).toBeTruthy()

      it "should be close - sunday - 1", ->
        #      0: [undefined,undefined],
        #      Jan 5th 2014 was a Sunday = 0
        spyOn(DateService, 'nowMoment').and.returnValue moment("01-05-2014T09:30", "MM-DD-YYYYTHH:mm");
        newStores = StoreService.listStores()
        expect(newStores[0].hours.isOpen).toBeFalsy()

      it "should be close - sunday - 2", ->
        #      0: [undefined,undefined],
        #      Jan 5th 2014 was a Sunday = 0
        spyOn(DateService, 'nowMoment').and.returnValue moment("01-05-2014T15:01", "MM-DD-YYYYTHH:mm");
        newStores = StoreService.listStores()
        expect(newStores[0].hours.isOpen).toBeFalsy()

      it "should be close - tuesday - 1", ->
        #      2: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
        #      Jan 7th 2014 was a Tuesday = 2
        spyOn(DateService, 'nowMoment').and.returnValue moment("01-07-2014T09:30", "MM-DD-YYYYTHH:mm");
        newStores = StoreService.listStores()
        expect(newStores[0].hours.isOpen).toBeFalsy()

      it "should be close - tuesday - 2", ->
        #      2: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
        #      Jan 7th 2014 was a Tuesday = 2
        spyOn(DateService, 'nowMoment').and.returnValue moment("01-07-2014T15:01", "MM-DD-YYYYTHH:mm");
        newStores = StoreService.listStores()
        expect(newStores[0].hours.isOpen).toBeFalsy()

      it "should be close - tuesday - 3", ->
        #      2: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
        #      Jan 7th 2014 was a Tuesday = 2
        spyOn(DateService, 'nowMoment').and.returnValue moment("01-07-2014T19:29", "MM-DD-YYYYTHH:mm");
        newStores = StoreService.listStores()
        expect(newStores[0].hours.isOpen).toBeFalsy()

      it "should be close - tuesday - 4", ->
        #      2: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
        #      Jan 7th 2014 was a Tuesday = 2
        spyOn(DateService, 'nowMoment').and.returnValue moment("01-07-2014T22:01", "MM-DD-YYYYTHH:mm");
        newStores = StoreService.listStores()
        expect(newStores[0].hours.isOpen).toBeFalsy()

      it "should be close - tuesday - 5", ->
        #      2: [{start:"11:30",end:"15:00"},{start:"19:30",end:"22:00"}],
        #      Jan 7th 2014 was a Tuesday = 2
        spyOn(DateService, 'nowMoment').and.returnValue moment("01-08-2014T01:00", "MM-DD-YYYYTHH:mm");
        newStores = StoreService.listStores()
        expect(newStores[0].hours.isOpen).toBeFalsy()


  describe "Product Service", ->

    ProductService = undefined

    beforeEach ->
      inject(( _ProductService_ ) ->
        ProductService = _ProductService_
    )

    it 'should retrieve a list of categories with products and produce an array of models', ->
      menu = ProductService.getMenu undefined, undefined

      expect(_.toArray(menu).length).toBe 4
      expect(menu.pizza.length > 0).toBeTruthy()
      expect(menu.empanada.length > 0).toBeTruthy()
      expect(menu.bebida.length > 0).toBeTruthy()
      expect(menu.promo.length > 0).toBeTruthy()

      expect(menu.pizza[0].products[0].getDescription()).toBeDefined()

    it 'should return only the array from an specific category', ->
      menu = ProductService.getMenu 1, 'pizza'

      expect(_.toArray(menu).length).toBe 1
      expect(menu.pizza).toBeDefined()



  describe "OrderService", ->
    OrderService = undefined

    beforeEach ->
      inject(( _OrderService_ ) ->
        OrderService = _OrderService_
    )

    it "should get an order details object", ->
      newMenuObject = OrderService.placeOrder {}
      expect( newMenuObject.number ).toBe "AXAHA263920"