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
      }

      newObject = StoreService.listStores()
      expect( newObject[0].name ).toBe expected.name
      expect( newObject[0].address).toBe expected.address
      expect( newObject[0].tel ).toBe expected.tel




  describe "Product Service", ->

    ProductService = undefined

    beforeEach ->
      inject(( _ProductService_ ) ->
        ProductService = _ProductService_
    )

    it "should get a menu of product objects", ->
      store =
        products:
          "empanada": [
            "id": 1,
            "desc": "Al Horno",
            "products": [
              "id": 1
              "desc": "Carne cortada a cuchillo"
              "toppings": [ "Carne", "Huevo", "Morron" ]
              "price": 1800
            ,
              "id": 2
              "desc": "Calabresa"
              "toppings": [ "Muzzarella", "Longaniza", "Salsa" ]
              "price": 1800
            ]
          ]
      spyOn(ProductService, 'listMenuByStore').and.returnValue store
      newMenuObject = ProductService.listMenuByStore 1
      expect( newMenuObject.products.empanada.length ).toBe 1
      expect( newMenuObject.products.empanada[0].products.length ).toBe 2


  describe "OrderService", ->
    OrderService = undefined

    beforeEach ->
      inject(( _OrderService_ ) ->
        OrderService = _OrderService_
    )

    it "should get an order details object", ->
      newMenuObject = OrderService.placeOrder {}
      expect( newMenuObject.number ).toBe "AXAHA263920"