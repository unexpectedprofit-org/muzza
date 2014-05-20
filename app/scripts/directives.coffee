angular.module('Muzza.directives', ['Muzza.factories'])

angular.module('Muzza.directives').directive 'cancelSelection', ()->
  restrict: 'EA'
  template: '<button class="button  button-block button-clear button-positive" ng-click="cancel()">Dejar y volver al menu</button>'
  link: ($scope, ele, attrs, ctrl)->
    $scope.cancel = ->
      angular.forEach $scope.steps, (key, val)->
        modal = $scope[key]
        modal.hide()


angular.module('Muzza.directives').directive 'pizzas', ($log, $ionicModal, ShoppingCart, PizzaSize, PizzaDough, PizzaOrder) ->
  restrict: 'EA'
  scope: {
    menu: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: 'menu-pizzas.html'
  link: ($scope, ele, attrs, ctrl)->

#   holds temp selection
    $scope.pizza = {}

#   this could come from firebase, or we can override when starting the app with a decorator at config phase
    $scope.steps = ['order', 'dough', 'size']

    $ionicModal.fromTemplateUrl 'pizza-size.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.size = new PizzaSize(modal)

    $ionicModal.fromTemplateUrl 'pizza-dough.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.dough = new PizzaDough(modal)

    $ionicModal.fromTemplateUrl 'pizza-order.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.order = new PizzaOrder(modal)


    $scope.choose = (item)->
      $scope.pizza = angular.copy(item)
      angular.forEach $scope.steps, (key, val)->
        modal = $scope[key]
        modal.show()

#    $scope.$on '$destroy', ->
#      $log.log 'destroy'
#      $scope.size.remove()
#      $scope.dough.remove()

angular.module('Muzza.directives').directive 'empanadas', ($log, $ionicModal, ShoppingCart) ->
  restrict: 'EA'
  scope: {
    menu: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: 'menu-empanadas.html'
  link: ($scope, ele, attrs, ctrl)->

#   holds temp selection
    $scope.empanada = {}

    #   this could come from firebase, or we can override when starting the app with a decorator at config phase
    $scope.steps = ['order', 'type']

    $ionicModal.fromTemplateUrl 'empanada-type.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.type = modal
      $scope.type.choose = (fried_qty, oven_qty)->

        $scope.empanada.type =
            f: parseInt fried_qty or 0
            h: parseInt oven_qty or 0

        $scope.type.hide()

    $ionicModal.fromTemplateUrl 'empanada-order.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.order = modal
      $scope.order.add = ()->
        ShoppingCart.addToCart($scope.empanada)
        $scope.order.hide()

      $scope.order.cancel = ->
        $scope.order.hide()

      $scope.order.edit = ()->
        $scope.choose($scope.empanada)


    $scope.choose = (item)->
      $scope.empanada = angular.copy(item)
      angular.forEach $scope.steps, (key, val)->
        modal = $scope[key]
        modal.show()


angular.module('Muzza.directives').directive 'cart', ($ionicModal, ShoppingCart) ->
  restrict: 'EA'
  scope: {}
  templateUrl: 'cart.html'
  link: ($scope, ele, attrs, ctrl)->
    $scope.cart = ShoppingCart.getCart()

angular.module('Muzza.directives').directive 'checkoutButton', ($ionicModal, $state, ShoppingCart) ->
  restrict: 'EA'
  scope: {}
  template: '<button class="button button-block button-positive"
              data-ng-if="cart.length > 0"
              data-ng-click="checkout()">Realizar Pedido</button>'

  link: ($scope, ele, attrs, ctrl)->

    $scope.cart = ShoppingCart.getCart()

    $scope.checkoutSteps = ['contact', 'delivery']

    $ionicModal.fromTemplateUrl 'delivery-option.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.delivery = modal
      $scope.delivery.choose = (deliveryType) ->
        console.log "delivey method selected: " + deliveryType
        $scope.deliveryOption = deliveryType
        $scope.delivery.hide()

    $ionicModal.fromTemplateUrl 'delivery-contact.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.contact = modal
      $scope.contact.place = () ->
        console.log "form completed: "
        $scope.contact.hide()
        $state.go('^.orderplace')

    $scope.checkout = () ->
      angular.forEach $scope.checkoutSteps, (key, val)->
        modal = $scope[key]
        modal.show()

angular.module('Muzza.directives').directive 'validateEmpanadaSelection', () ->
  restrict: 'A'
  require: 'ngModel'
  scope: {
    empanada: "=ngModel"
  }

  link: (scope, ele, attrs, ctrl)->

    scope.$watch 'empanada', (newValue) ->

      if angular.isDefined newValue
        if newValue.fri > 0 || newValue.hor > 0
          ctrl.$setValidity 'missingQty', true
        else
          ctrl.$setValidity 'missingQty', false
    ,true
