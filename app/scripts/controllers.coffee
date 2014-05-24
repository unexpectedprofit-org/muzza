angular.module("Muzza.controllers", ['Muzza.services'])

angular.module("Muzza.controllers").controller "MenuCtrl", ($scope, $stateParams, ProductService, $rootScope) ->
  $rootScope.storeId = $stateParams.storeID
  $scope.menu = ProductService.getMenu()

angular.module("Muzza.controllers").controller "StoreCtrl", ($scope, StoreService) ->

  $scope.stores = StoreService.listStores()


angular.module("Muzza.controllers").controller "PlaceOrderCtrl", ($scope, OrderService) ->

  $scope.order = OrderService.placeOrder()

