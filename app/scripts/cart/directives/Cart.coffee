angular.module('Muzza.cart').directive 'cart', (ShoppingCartService, $state) ->
  restrict: 'EA'
  scope: {}
  templateUrl: '../app/scripts/cart/templates/cart.html'
  link: ($scope, ele, attrs, ctrl)->

    $scope.edit = (item)->
#      TODO: edit needs to remove the item from cart.
#      If user decided not to edit it after all, we should put it back to the cart.

      switch item.cat
        when 'EMPANADA' then $state.go 'app.empanada', {empanadaId: item.hash}
        when 'PIZZA'    then $state.go 'app.pizza', {pizzaId: item.hash}
        else $state.go 'app.menu'

    $scope.cart =
      products: ShoppingCartService.getCart()
      totalPrice: ShoppingCartService.getTotalPrice