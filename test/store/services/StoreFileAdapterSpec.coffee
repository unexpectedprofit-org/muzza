describe "StoreFileAdapter", ->

  StoreFileAdapter = undefined

  beforeEach ->
    module 'Muzza.store'

  beforeEach ->
    inject ($injector) ->
      StoreFileAdapter = $injector.get 'StoreFileAdapter'

  describe "getBranches", ->

    it "should retrieve stores", ->
      inject ($rootScope)->
        stores = undefined
        StoreFileAdapter.getBranches().then (response)->
          stores = response
        $rootScope.$apply()
        expect(stores.data.length).toBeGreaterThan 0