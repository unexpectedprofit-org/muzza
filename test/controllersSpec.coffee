describe "controllers", ->

  beforeEach ->
    module "Muzza.controllers"

  describe "Menu Controller", ->

    scope = ProductService = createController = undefined

    beforeEach ->
      module ($provide) ->
        $provide.value 'ProductService',
          getMenu: ()->
            { pizza:[products:{id:1}], empanada:[products:{id:2}] }
        null

    beforeEach ->
      inject ($controller, $rootScope, _ProductService_, $stateParams) ->

        ProductService = _ProductService_
        spyOn(ProductService, 'getMenu').and.callThrough()
        scope = $rootScope.$new()
        createController = (params)->
          $controller "MenuCtrl",
            $scope: scope
            $stateParams: params

    it "should get all menu items", ->
      createController({storeID: 1})
      expect(scope.menu.pizza).toEqual [{products:{id:1}}]
      expect(scope.menu.empanada).toEqual [{products:{id:2}}]
      expect(ProductService.getMenu).toHaveBeenCalled()

    it "should get only the menu items for an specific category", ->
      createController({category: 'PIZZA', storeID: 1})
      expect(ProductService.getMenu).toHaveBeenCalledWith(1, 'PIZZA')

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