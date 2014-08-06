describe "Store service", ->

  StoreService = StoreFileAdapter = newStores = undefined

  beforeEach ->
    module 'Muzza.store'
    module ($provide) ->
      $provide.value 'Geo',
        validateDeliveryRadio: ()-> null
      return null

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

          "delivery": {
            "latLong": {
              "k": -34.591809,
              "A": -58.3959331
            },
            "radio": 2
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
    expected =
      name: "La pizzeria de Juancho"
    expect( newStores[0].name ).toEqual expected.name

  it 'should call the Adapter to get all branches', ->
    StoreService.listStores()
    expect(StoreFileAdapter.getBranches).toHaveBeenCalled()

  describe 'chooseStore', ->

    it 'should save the selected store', ->
      store =
        id: 1
      StoreService.chooseStore(store)
      expect(StoreService.retrieveSelectedStore()).toEqual { id: 1}

  describe 'retrieveSelectedStore', ->

    it 'should return selected store', ->
      StoreService.chooseStore({id:1})
      store  = StoreService.retrieveSelectedStore()
      expect(store).toEqual {id:1}



