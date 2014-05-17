describe "controllers", ->

  beforeEach ->
    module "Muzza.controllers"

  it "should create a valid test", ->
    expect(true).toBe(true)

  describe "Menu Controller", ->

    scope = undefined

    beforeEach ->
      inject ($controller, $rootScope) ->
        scope = $rootScope.$new()
        $controller "MenuCtrl",
          $scope: scope

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