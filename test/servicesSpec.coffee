describe "services", ->

  beforeEach ->
    module "Muzza.services"

  describe "store service", ->
    StoreService = undefined

    beforeEach ->
      inject ($injector) ->
        StoreService = $injector.get 'StoreService'

    it "should create a list of store objects", ->

#      jasmine.getJSONFixtures().fixturesPath = 'test/fixtures'
#      dataResponse = getJSONFixture('store.json')

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
          {day:"Sabado",hours:"18:30 - 02:00"}
        ]
      }

      newObject = StoreService.listStores()
      expect( newObject[0].name ).toEqual expected.name
      expect( newObject[0].address).toEqual expected.address
      expect( newObject[0].tel ).toEqual expected.tel

      expect( newObject[0].hours[0].day ).toBe 'Domingo'
      expect( newObject[0].hours[0].hours ).toBe 'Cerrado'

      expect( newObject[0].hours[1].day ).toBe 'Lunes'
      expect( newObject[0].hours[1].hours ).toBe '12:00 - 14:00'

      expect( newObject[0].hours[3].day ).toBe 'Miercoles'
      expect( newObject[0].hours[3].hours ).toBe '11:30 - 15:00  /  19:30 - 22:00'

      expect( newObject[0].hours[6].day ).toBe 'Sabado'
      expect( newObject[0].hours[6].hours ).toBe '18:30 - 02:00'

      todayDay = _.filter newObject[0].hours, (elem) ->
        elem.today

      expect(todayDay.length).toBe 1


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