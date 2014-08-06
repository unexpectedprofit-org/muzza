describe "ProductFileAdapter", ->

  ProductFileAdapter = undefined

  beforeEach ->
    module 'Muzza.product'

  beforeEach ->
    inject ($injector) ->
      ProductFileAdapter = $injector.get 'ProductFileAdapter'

  describe "getMenu", ->

    it "should retrieve menu", ->
      inject ($rootScope)->
        menu = undefined
        ProductFileAdapter.getMenu().then (response)->
          menu = response
        $rootScope.$apply()
        expect(menu.data.length).toBeGreaterThan 0
