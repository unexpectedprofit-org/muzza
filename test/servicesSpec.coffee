fakeDate = undefined
oldDate = Date
Date = ()->
  new oldDate(fakeDate)

describe "services", ->

  beforeEach ->
    module "Muzza.services"


  describe "store service", ->
    StoreService = newStores = undefined

    beforeEach ->
      inject ($injector) ->
        StoreService = $injector.get 'StoreService'

    it "should create a list of store objects", ->

      newStores = StoreService.listStores()

      expected = {
        name: "La pizzeria de Juancho"
        address: "Av. Rivadavia 5100 - Caballito (Capital Federal)"
        tel: "4444 5555 / 1111 2222 / 15 4444 9999"
      }

      expect( newStores[0].name ).toEqual expected.name
      expect( newStores[0].address).toEqual expected.address
      expect( newStores[0].tel ).toEqual expected.tel

    describe "open or close", ->

      it "should be open - wednesday - 1", ->
#        Miercoles: [
#          ['11:30', '15:00']
#          ['19:30', '22:00']
#        ]
#        Jan 1st 2014 was a Wednesday = 3
        fakeDate = "January 1, 2014 20:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeTruthy()

      it "should be open - wednesday - 2", ->
#        Miercoles: [
#          ['11:30', '15:00']
#          ['19:30', '22:00']
#        ]
#        Jan 1st 2014 was a Wednesday = 3
        fakeDate = "January 1, 2014 14:15:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeTruthy()

      it "should be open - wednesday - 3", ->
#        Miercoles: [
#          ['11:30', '15:00']
#          ['19:30', '22:00']
#        ]
#        Jan 1st 2014 was a Wednesday = 3
        fakeDate = "January 1, 2014 21:33:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeTruthy()

      it "should be open - Thrusday - 1", ->
#        Jueves: [
#          ['11:30', '15:00']
#          ['19:30', '01:00']
#        ]
#        Jan 2nd 2014 was a Thrusday = 4
        fakeDate = "January 2, 2014 21:33:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeTruthy()

      it "should be open - friday night  - 1", ->
#        Viernes: [
#          ['11:30', '15:00']
#          ['19:30', '02:30']
#        ]
#        Jan 3nd 2014 was a Friday
        fakeDate = "January 4, 2014 01:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeTruthy()

      it "should be close - friday night  - 2", ->
#        Viernes: [
#          ['11:30', '15:00']
#          ['19:30', '02:30']
#        ]
#        Jan 4th 2014 was a Saturday
        fakeDate = "January 4, 2014 03:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeFalsy()

      it "should be open - friday night  - 3", ->
#        Viernes: [
#          ['11:30', '15:00']
#          ['19:30', '02:30']
#        ]
#        Jan 4th 2014 was a Saturday
        fakeDate = "January 4, 2014 02:15:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeTruthy()

      it "should be open - saturday - 1", ->
#        Sabado: [
#          ['18:30', '23:59']
#        ]
#        Jan 4th 2014 was a Saturday
        fakeDate = "January 4, 2014 18:30:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeTruthy()

      it "should be open - saturday - 2", ->
#        Sabado: [
#          ['18:30', '23:59']
#        ]
#        Jan 4th 2014 was a Saturday
        fakeDate = "January 4, 2014 22:15:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeTruthy()

      it "should be open - saturday - 3", ->
#        Sabado: [
#          ['18:30', '23:59']
#        ]
#        Jan 4th 2014 was a Saturday
        fakeDate = "January 4, 2014 23:59:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeTruthy()

      it "should be close - sunday night - 1", ->
#        Domingo: []
#        Lunes: [
#          ['12:00', '14:00']
#          ['19:30', '03:00']
#        ]
#        Jan 6th 2014 was a Monday
        fakeDate = "January 6, 2014 01:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeFalsy()

      it "should be close - sunday - 1", ->
#        Domingo: []
#        Lunes: [
#          ['12:00', '14:00']
#          ['19:30', '03:00']
#        ]
#        Jan 5th 2014 was a Sunday
        fakeDate = "January 5, 2014 09:30:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeFalsy()

      it "should be close - sunday - 2", ->
#        Sabado: [
#          ['18:30', '23:59']
#        ]
#        Domingo: []
#        Jan 5th 2014 was a Sunday
        fakeDate = "January 5, 2014 01:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeFalsy()

      it "should be close - sunday - 2", ->
#        Sabado: [
#          ['18:30', '23:59']
#        ]
#        Domingo: []
#        Jan 5th 2014 was a Sunday
        fakeDate = "January 5, 2014 15:01:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeFalsy()

      it "should be close - tuesday - 1", ->
#      Lunes: [
#        ['12:00', '14:00']
#        ['19:30', '03:00']
#      ]
#        Martes: [
#          ['11:30', '15:00']
#          ['19:30', '22:00']
#        ]
#        Miercoles: [
#          ['11:30', '15:00']
#          ['19:30', '22:00']
#        ]
#        Jan 7th 2014 was a Tuesday
        fakeDate = "January 7, 2014 09:30:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeFalsy()

      it "should be close - tuesday - 2", ->
#      Lunes: [
#        ['12:00', '14:00']
#        ['19:30', '03:00']
#      ]
#        Martes: [
#          ['11:30', '15:00']
#          ['19:30', '22:00']
#        ]
#        Miercoles: [
#          ['11:30', '15:00']
#          ['19:30', '22:00']
#        ]
#        Jan 7th 2014 was a Tuesday
        fakeDate = "January 7, 2014 15:01:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeFalsy()

      it "should be close - tuesday - 3", ->
#      Lunes: [
#        ['12:00', '14:00']
#        ['19:30', '03:00']
#      ]
#        Martes: [
#          ['11:30', '15:00']
#          ['19:30', '22:00']
#        ]
#        Miercoles: [
#          ['11:30', '15:00']
#          ['19:30', '22:00']
#        ]
#        Jan 7th 2014 was a Tuesday
        fakeDate = "January 7, 2014 19:29:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeFalsy()

      it "should be close - tuesday - 4", ->
#      Lunes: [
#        ['12:00', '14:00']
#        ['19:30', '03:00']
#      ]
#        Martes: [
#          ['11:30', '15:00']
#          ['19:30', '22:00']
#        ]
#        Miercoles: [
#          ['11:30', '15:00']
#          ['19:30', '22:00']
#        ]
#        Jan 7th 2014 was a Tuesday
        fakeDate = "January 7, 2014 22:01:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeFalsy()

      xit "should be close - tuesday - 5", ->
#      Lunes: [
#        ['12:00', '14:00']
#        ['19:30', '03:00']
#      ]
#        Martes: [
#          ['11:30', '15:00']
#          ['19:30', '22:00']
#        ]
#        Miercoles: [
#          ['11:30', '15:00']
#          ['19:30', '22:00']
#        ]
#        Jan 7th 2014 was a Tuesday
        fakeDate = "January 8, 2014 01:00:00"
        newStores = StoreService.listStores()
        expect(newStores[0].isOpenRightNow()).toBeFalsy()


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