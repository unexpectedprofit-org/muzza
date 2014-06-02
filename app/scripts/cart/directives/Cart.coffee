angular.module('Muzza.cart').directive 'cart', (ShoppingCartService, $state, OrderService) ->
  restrict: 'EA'
  scope: {}
  templateUrl: '../app/scripts/cart/templates/cart.html'
  link: ($scope, ele, attrs, ctrl)->

    $scope.edit = (item)->

      switch item.cat
        when 'EMPANADA' then $state.go 'app.empanada', { empanadaId: item.cartItemKey }
        when 'PIZZA'    then $state.go 'app.pizza', { pizzaId: item.cartItemKey }
        else $state.go 'app.menu'

    $scope.remove = (cartItemKey) ->
      ShoppingCartService.remove cartItemKey

    $scope.cart =
      products: ShoppingCartService.getCart()
      totalPrice: ShoppingCartService.getTotalPrice

    $scope.checkout = () ->
      OrderService.createOrder $scope.cart
      $state.go 'app.order-delivery'