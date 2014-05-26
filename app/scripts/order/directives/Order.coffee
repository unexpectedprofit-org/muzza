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
    #
    #    $ionicModal.fromTemplateUrl '../app/templates/delivery-option.html',
    #      scope: $scope,
    #      animation: 'slide-in-up'
    #    .then (modal) ->
    #      $scope.delivery = modal
    #      $scope.delivery.choose = (deliveryType) ->
    ##        console.log "delivey method selected: " + deliveryType
    #        $scope.deliveryOption = deliveryType
    #        $scope.delivery.hide()
    #
    #    $ionicModal.fromTemplateUrl '../app/templates/delivery-contact.html',
    #      scope: $scope,
    #      animation: 'slide-in-up'
    #    .then (modal) ->
    #      $scope.contact = modal
    #      $scope.contact.place = () ->
    ##        console.log "form completed: "
    #        $scope.contact.hide()
    #        $state.go('^.orderplace')

    $scope.checkout = () ->
      angular.forEach $scope.checkoutSteps, (key, val)->
        modal = $scope[key]
        modal.show()

    init = ->
      $q.all([contact, deliveryOption]).then (views)->
        $scope.contact = new OrderContact views[0]
        $scope.deliveryOption = new OrderDelivery views[1]


    init()
