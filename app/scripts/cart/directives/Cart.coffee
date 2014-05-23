angular.module('Muzza.cart').directive 'cart', (ShoppingCartService, $state) ->
  restrict: 'EA'
  scope: {}
  templateUrl: '../app/scripts/cart/templates/cart.html'
  link: ($scope, ele, attrs, ctrl)->

    $scope.edit = (item)->
      switch item.cat
        when 'EMPANADA' then $state.go 'app.empanada', {id: item.hash}
        when 'PIZZA'    then $state.go 'app.pizza', {id: item.hash}
        else $state.go 'app.menu'

    $scope.cart =
      products: ShoppingCartService.getCart()
      totalPrice: ShoppingCartService.getTotalPrice