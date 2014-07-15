angular.module('Muzza.product').directive 'product', (ShoppingCartService, $ionicModal, $rootScope, $stateParams, Product) ->
  restrict: 'E'
  required: 'ngModel'
  scope: {
    product: '=ngModel'
  }
  templateUrl: '../app/scripts/product/templates/product.html'
  link: ($scope, ele, attrs, ctrl) ->



    $scope.chooseProduct = (product) ->

      options = $ionicModal.fromTemplateUrl '../app/scripts/product/templates/product-view.html',
        scope: $scope,
        animation: 'slide-in-up'

      options.then (view)->
        $scope.productOptions = view
        product.clearSelections()
        $scope.product = new Product product
        $scope.productOptions.show()

        $rootScope.$on 'PRODUCT_SELECTED_TO_BE_ADDED_TO_CART', (event, productSelected) ->
          ShoppingCartService.add productSelected
          $scope.productOptions.remove()