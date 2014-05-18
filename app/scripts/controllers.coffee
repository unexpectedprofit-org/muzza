angular.module("Muzza.controllers", [])

angular.module("Muzza.controllers").controller "MenuCtrl", [ "$scope", "$stateParams", "ProductService", ($scope, $stateParams, ProductService) ->

  storeMenu = ProductService.listMenuByStore $stateParams.storeID
  $scope.menu = storeMenu.products
]

angular.module("Muzza.controllers").controller "StoreCtrl", [ "$scope", "StoreService", ($scope, StoreService) ->

  $scope.stores = StoreService.listStores()

]

angular.module("Muzza.controllers").controller "PlaceOrderCtrl", [ "$scope", "OrderService", ($scope, OrderService) ->

  $scope.order = OrderService.placeOrder()
]

