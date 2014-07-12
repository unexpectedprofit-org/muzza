angular.module("Muzza.controllers", ['Muzza.services'])

angular.module("Muzza.controllers").controller "MenuCtrl", ($scope, $stateParams, ProductService, Product, $rootScope, ShoppingCartService, $state, $ionicModal) ->

  $scope.chooseProduct = (product) ->

    options = $ionicModal.fromTemplateUrl '../app/scripts/product/templates/product-view.html',
      scope: $scope,
      animation: 'slide-in-up'

    options.then (view)->
      $scope.productOptions = view
      $scope.product = new Product product
      $scope.productOptions.show()

      $rootScope.$on 'PRODUCT_SELECTED_TO_BE_ADDED_TO_CART', (event, productSelected) ->
        ShoppingCartService.add productSelected
        $scope.productOptions.hide()


  $scope.viewCart = () ->
    $state.go 'app.cart'

  $rootScope.storeId = $stateParams.storeID

  $scope.cartTotalPrice = ShoppingCartService.getTotalPrice()
  $rootScope.$on 'CART:PRICE_UPDATED', (event, newValue) ->
    $scope.cartTotalPrice = newValue

  $scope.menu = ProductService.getMenu($rootScope.storeId, $stateParams.category)