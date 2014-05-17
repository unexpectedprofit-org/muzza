angular.module("Muzza.controllers", [])

angular.module("Muzza.controllers").controller "MenuCtrl", ($scope) ->
  $scope.menu = [
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

angular.module("Muzza.controllers").controller "StoreCtrl", [ "$scope", "StoreService", ($scope, StoreService) ->

  $scope.stores = StoreService.listStores()

]
