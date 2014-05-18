describe "controllers", ->

  beforeEach ->
    module "Muzza.controllers"

  describe "Menu Controller", ->

    scope = undefined

    pizzas = [
      {
        desc: "Muzza"
        id: 1
      }
      {
        desc: "Fugazetta"
        id: 2
      }
      {
        desc: "Jamon y Morron"
        id: 3
      }
    ]

    returnObject = {
      products:
        pizza: pizzas
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
      expect(scope.menu).toEqual( pizzas )

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


  describe "PlaceOrder Controller", ->

    scope = undefined
    returnObject = {
      some: "thing"
    }

    _fakeOrderService =
      placeOrder: () ->
        returnObject

    beforeEach ->
      module ($provide) ->
        $provide.value('OrderService', _fakeOrderService )
        null

      inject ($controller, $rootScope) ->
        scope = $rootScope.$new()
        $controller "PlaceOrderCtrl",
          $scope: scope
          OrderService: _fakeOrderService

    it "should call the service", ->
      expect(scope.order).toEqual returnObject