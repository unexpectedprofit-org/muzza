angular.module('Muzza.directives', ['Muzza.factories'])

angular.module("Muzza.directives").filter "centsToMoney", ->
  (cents) ->
    parseFloat(cents / 100).toFixed(2)

angular.module('Muzza.directives').directive 'cancelSelection', ()->
  restrict: 'EA'
  template: '<button class="button  button-block button-clear button-positive" ng-click="cancel()">Dejar y volver al menu</button>'
  link: ($scope, ele, attrs, ctrl)->
    $scope.cancel = ->
      angular.forEach $scope.steps, (key, val)->
        modal = $scope[key]
        modal.hide()
#      console.log "cancelar button: "
#      console.log "empa: " + JSON.stringify $scope.empanada
#      console.log "pizza: " + JSON.stringify  $scope.pizza

angular.module('Muzza.directives').directive 'checkoutButton', ($ionicModal, $state, ShoppingCartService) ->
  restrict: 'EA'
  scope: {}
  template: '<button class="button button-block button-positive"
              data-ng-if="cart.length > 0"
              data-ng-click="checkout()">Realizar Pedido</button>'

  link: ($scope, ele, attrs, ctrl)->

    $scope.cart = ShoppingCartService.getCart()

    $scope.checkoutSteps = ['contact', 'delivery']

    $ionicModal.fromTemplateUrl '../app/templates/delivery-option.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.delivery = modal
      $scope.delivery.choose = (deliveryType) ->
#        console.log "delivey method selected: " + deliveryType
        $scope.deliveryOption = deliveryType
        $scope.delivery.hide()

    $ionicModal.fromTemplateUrl '../app/templates/delivery-contact.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.contact = modal
      $scope.contact.place = () ->
#        console.log "form completed: "
        $scope.contact.hide()
        $state.go('^.orderplace')

    $scope.checkout = () ->
      angular.forEach $scope.checkoutSteps, (key, val)->
        modal = $scope[key]
        modal.show()
