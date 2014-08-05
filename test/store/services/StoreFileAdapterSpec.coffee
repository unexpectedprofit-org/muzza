describe "StoreFileAdapter", ->

  StoreFileAdapter = undefined

  beforeEach ->
    module 'Muzza.store'

  beforeEach ->
    inject ($injector) ->
      StoreFileAdapter = $injector.get 'StoreFileAdapter'

  describe "getBranches", ->

    it "should retrieve stores", ->
      stores  = StoreFileAdapter.getBranches()
      expect stores.length > 0