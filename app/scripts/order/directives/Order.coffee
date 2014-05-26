angular.module('Muzza.order').directive 'checkoutButton', ($ionicModal, $state, ShoppingCartService, OrderContact, OrderDelivery, $q) ->
  restrict: 'EA'
  scope: {}
  template: '<button class="button button-block button-positive"
                data-ng-if="cart.length > 0"
                data-ng-click="checkout()">Realizar Pedido</button>'

  link: ($scope, ele, attrs, ctrl)->

    $scope.cart = ShoppingCartService.getCart()

    $scope.checkoutSteps = ['contact', 'deliveryOption']

    deliveryOption = $ionicModal.fromTemplateUrl '../app/scripts/order/templates/delivery-option.html',
      scope: $scope,
      animation: 'slide-in-up'

    contact = $ionicModal.fromTemplateUrl '../app/scripts/order/templates/contact.html',
      scope: $scope,
      animation: 'slide-in-up'

    $scope.checkout = () ->
      angular.forEach $scope.checkoutSteps, (key, val)->
        modal = $scope[key]
        modal.show()

    init = ->
      $q.all([contact, deliveryOption]).then (views)->
        $scope.contact = new OrderContact views[0]
        $scope.deliveryOption = new OrderDelivery views[1]


    init()
