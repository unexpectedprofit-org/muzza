describe "ProductFileAdapter", ->

  ProductFileAdapter = mockBackend = undefined

  beforeEach ->
    module 'Muzza.product'

  beforeEach ->
    inject ($injector) ->
      ProductFileAdapter = $injector.get 'ProductFileAdapter'
      mockBackend = $injector.get '$httpBackend'

  describe "getMenu", ->

    it "should make a http call", ->
      ProductFileAdapter.getMenu()

      mockBackend.expectGET().respond({})
      mockBackend.flush()
