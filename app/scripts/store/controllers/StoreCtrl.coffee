angular.module("Muzza.stores").controller "StoresCtrl", ($scope, $state, OrderService, StoreService ) ->

  StoreService.listStores().then (branches) ->
    $scope.stores = branches


  $scope.continue = (store)->
    OrderService.chooseStore(store).then ()->
      $state.go 'app.menu'



