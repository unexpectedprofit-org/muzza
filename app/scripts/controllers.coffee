angular.module("Muzza.controllers",[])

angular.module("Muzza.controllers").controller "MenuCtrl", ($scope, $stateParams, ProductService, $rootScope, ShoppingCartService, $state) ->

  $scope.viewCart = () ->
    $state.go 'app.cart'

  $rootScope.storeId = $stateParams.storeID

  $scope.cartTotalPrice = ShoppingCartService.getTotalPrice

  ProductService.getMenu($rootScope.storeId, $stateParams.category).then (response) ->
    $scope.menu = response