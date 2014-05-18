angular.module('Muzza.directives', [])

angular.module('Muzza.directives').directive 'pizzas', ($log, $ionicModal, ShoppingCart) ->
  restrict: 'EA'
  scope: {
    menu: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: 'menu-pizzas.html'
  link: ($scope, ele, attrs, ctrl)->

#   holds temp selection
    $scope.pizza = {}
#   holds selections
    $scope.pizzas = []

#   this could come from firebase, or we can override when starting the app with a decorator at config phase
    $scope.steps = ['order', 'dough', 'size']

    $ionicModal.fromTemplateUrl 'pizza-size.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.size = modal
      $scope.size.choose = (value)->
        $scope.pizza.size = value
        $scope.size.hide()

    $ionicModal.fromTemplateUrl 'pizza-dough.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.dough = modal
      $scope.dough.choose = (value)->
        $scope.pizza.dough = value
        $scope.dough.hide()

    $ionicModal.fromTemplateUrl 'pizza-order.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.order = modal
      $scope.order.add = ()->
        $scope.pizzas.push $scope.pizza
        ShoppingCart.addToCart($scope.pizza)
        $scope.order.hide()

    $scope.choose = (item)->
      $scope.pizza = angular.copy(item)
      angular.forEach $scope.steps, (key, val)->
        modal = $scope[key]
        modal.show()

#    $scope.$on '$destroy', ->
#      $log.log 'destroy'
#      $scope.size.remove()
#      $scope.dough.remove()

angular.module('Muzza.directives').directive 'cart', ($ionicModal, ShoppingCart) ->
  restrict: 'EA'
  scope: {}
  templateUrl: 'cart.html'
  link: ($scope, ele, attrs, ctrl)->
    $scope.cart = ShoppingCart.getCart()


    $scope.checkoutSteps = ['contact', 'delivery']


    ####################################
    $scope.checkout = () ->
      angular.forEach $scope.checkoutSteps, (key, val)->
        modal = $scope[key]
        modal.show()


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
    ####################################