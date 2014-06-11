angular.module("Muzza.stores").controller "StoresCtrl", ($scope, StoreService, $state, OrderService) ->

  $scope.stores = StoreService.listStores()

  $scope.continue = (store)->
    OrderService.chooseStore(store).then ()->
      $state.go 'app.menu'



