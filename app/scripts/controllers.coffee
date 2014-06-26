angular.module("Muzza.controllers", ['Muzza.services'])

angular.module("Muzza.controllers").controller "MenuCtrl", ($scope, $stateParams, ProductService, $rootScope, ShoppingCartService, $state, $ionicModal) ->


  $scope.chooseProduct = (product) ->

    options = $ionicModal.fromTemplateUrl '../app/scripts/product/templates/product-options.html',
      scope: $scope,
      animation: 'slide-in-up'

    options.then (view) ->

      $scope.product = product

      $scope.productOptions = view

      console.log "Choosing product: " + JSON.stringify product

      $scope.productOptions.show()


  $scope.viewCart = () ->
    $state.go 'app.cart'

  $rootScope.storeId = $stateParams.storeID

  $scope.cartTotalPrice = ShoppingCartService.getTotalPrice()
  $rootScope.$on 'CART:PRICE_UPDATED', (event, newValue) ->
    $scope.cartTotalPrice = newValue

  $scope.menu = ProductService.getMenu($rootScope.storeId, $stateParams.category)


