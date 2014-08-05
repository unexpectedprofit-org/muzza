describe "ProductFileAdapter", ->

  ProductFileAdapter = undefined

  beforeEach ->
    module 'Muzza.product'

  beforeEach ->
    inject ($injector) ->
      ProductFileAdapter = $injector.get 'ProductFileAdapter'

  describe "getMenu", ->

    it "should retrieve menu", ->
      menu  = ProductFileAdapter.getMenu()
      expect menu.length > 0