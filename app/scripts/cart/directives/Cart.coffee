angular.module('Muzza.cart').directive 'cart', (ShoppingCartService, $state) ->
  restrict: 'EA'
  scope: {}
  templateUrl: '../app/scripts/cart/templates/cart.html'
  link: ($scope, ele, attrs, ctrl)->

    $scope.orderEligibility = ShoppingCartService.checkEligibility

    $scope.edit = (product_cartItemKey)->
      $state.go 'app.products-edit', {productId: product_cartItemKey}

    $scope.remove = (cartItemKey) ->
      ShoppingCartService.remove cartItemKey

    $scope.cart =
      products: ShoppingCartService.getCart()
      totalPrice: ShoppingCartService.getTotalPrice

    $scope.checkout = () ->
      ShoppingCartService.checkout $scope.cart
      $state.go 'app.order-review'