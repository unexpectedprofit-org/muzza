describe "services", ->

  beforeEach ->
    module "Muzza.services"

  describe "store service", ->
    StoreService = undefined

    beforeEach ->
      inject(( _StoreService_ ) ->
        StoreService = _StoreService_
    )

    it "should create a store object", ->

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