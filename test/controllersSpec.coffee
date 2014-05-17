describe "controllers", ->

  beforeEach ->
    module "Muzza.controllers"

  describe "Menu Controller", ->

    scope = undefined

    returnObject = {
      some: "thing"
    }

    _fakeProductService =
      listMenuByStore: () ->
        returnObject

    beforeEach ->
      module ($provide) ->
        $provide.value('ProductService', _fakeProductService )
        null


    beforeEach ->
      inject ($controller, $rootScope) ->
        scope = $rootScope.$new()
        $controller "MenuCtrl",
          $scope: scope
          $stateParams: {}
          ProductService: _fakeProductService

    it "should get the menu items", ->
      expected = [
        {
          title: "Muzza"
          id: 1
        }
        {
          title: "Fugazetta"
          id: 2
        }
        {
          title: "Jamon y Morron"
          id: 3
        }
      ]

      expect(scope.menu).toEqual(expected)

    it "should call the service", ->
      expect(scope.menu1).toEqual returnObject

  describe "Store Controller", ->

    scope = undefined
    returnObject = {
      some: "thing"
    }

    _fakeStoreService =
      listStores: () ->
        returnObject

    beforeEach ->
      module ($provide) ->
        $provide.value('StoreService', _fakeStoreService )
        null

      inject ($controller, $rootScope) ->
        scope = $rootScope.$new()
        $controller "StoreCtrl",
          $scope: scope
          StoreService: _fakeStoreService

    it "should call the service", ->
      expect(scope.stores).toEqual returnObject
