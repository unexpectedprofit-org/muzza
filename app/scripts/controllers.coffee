angular.module("Muzza.controllers", ['Muzza.services'])

angular.module("Muzza.controllers").controller "MenuCtrl", ($scope, $stateParams, ProductService, $rootScope, ShoppingCartService, $state) ->

  $scope.viewCart = () ->
    $state.go 'app.cart'

  $rootScope.storeId = $stateParams.storeID

  $scope.cartTotalPrice = ShoppingCartService.getTotalPrice

  $scope.menu = ProductService.getMenu($rootScope.storeId, $stateParams.category)