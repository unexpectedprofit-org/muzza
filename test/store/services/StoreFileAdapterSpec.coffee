describe "StoreFileAdapter", ->

  StoreFileAdapter = mockBackend = undefined

  beforeEach ->
    module 'Muzza.store'

  beforeEach ->
    inject ($injector) ->
      StoreFileAdapter = $injector.get 'StoreFileAdapter'
      mockBackend = $injector.get '$httpBackend'

  describe "getBranches", ->

    it "should make a http call", ->
      StoreFileAdapter.getBranches()

      mockBackend.expectGET().respond({})
      mockBackend.flush()
