angular.module('Muzza.order').directive 'checkoutButton', ($ionicModal, $state, ShoppingCartService, OrderContact, OrderDelivery, OrderDetails, OrderPromo, $q) ->
  restrict: 'EA'
  scope: {}
  template: '<button class="button button-block button-positive"
                data-ng-if="cart.length > 0"
                data-ng-click="checkout()">Realizar Pedido</button>'

  link: ($scope, ele, attrs, ctrl)->

    $scope.cart = ShoppingCartService.getCart()

    $scope.checkoutSteps = ['contact', 'deliveryOption', 'promos']

    $scope.checkout = () ->

      $scope.order = {}

      promos = $ionicModal.fromTemplateUrl '../app/scripts/order/templates/promos-option.html',
        scope: $scope,
        animation: 'slide-in-up'

      deliveryOption = $ionicModal.fromTemplateUrl '../app/scripts/order/templates/delivery-option.html',
        scope: $scope,
        animation: 'slide-in-up'

      contact = $ionicModal.fromTemplateUrl '../app/scripts/order/templates/contact.html',
        scope: $scope,
        animation: 'slide-in-up'

      $q.all([contact, deliveryOption, promos]).then (views)->
        $scope.contact = new OrderContact views[0]
        $scope.deliveryOption = new OrderDelivery views[1]
        $scope.promos = new OrderPromo views[2]

        angular.forEach $scope.checkoutSteps, (key, val)->
          modal = $scope[key]
          modal.show()