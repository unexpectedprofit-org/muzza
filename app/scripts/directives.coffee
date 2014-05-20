angular.module('Muzza.directives', ['ui.router' ,'Muzza.factories'])

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
      console.log "cancelar button: "
      console.log "empa: " + JSON.stringify $scope.empanada
      console.log "pizza: " + JSON.stringify  $scope.pizza

angular.module('Muzza.directives').directive 'pizza', ($q, $log, $ionicModal, ShoppingCart, PizzaSize, PizzaDough, PizzaOrder,$stateParams, ProductService, $rootScope) ->
  restrict: 'EA'
  scope: {}
  template: '<div></div>'
  link: ($scope, ele, attrs, ctrl)->

#   holds temp selection
    $scope.pizza = {}

    storeMenu = ProductService.listMenuByStore $rootScope.storeID
    $scope.pizza = _.filter storeMenu.products.pizza, (item)->
      console.log $stateParams
      console.log item.id is $stateParams.id
      item.id is $stateParams.id

    #   this could come from firebase, or we can override when starting the app with a decorator at config phase
    $scope.steps = ['order', 'dough', 'size']

    size = $ionicModal.fromTemplateUrl 'pizza-size.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.size = new PizzaSize(modal)

    dough = $ionicModal.fromTemplateUrl 'pizza-dough.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.dough = new PizzaDough(modal)

    order = $ionicModal.fromTemplateUrl 'pizza-order.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.order = new PizzaOrder(modal)

    $q.all([order, dough, size]).then ()->
      angular.forEach $scope.steps, (key, val)->
        modal = $scope[key]
        modal.show()

#    $scope.$on '$destroy', ->
#      $log.log 'destroy'
#      $scope.size.remove()
#      $scope.dough.remove()


angular.module('Muzza.directives').directive 'pizzas', ($log, $ionicModal, ShoppingCart, PizzaSize, PizzaDough, PizzaOrder, $state) ->
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
      $state.go('app.pizza', {id: item.id})
#      $scope.pizza = angular.copy(item)
#      angular.forEach $scope.steps, (key, val)->
#        modal = $scope[key]
#        modal.show()

#    $scope.$on '$destroy', ->
#      $log.log 'destroy'
#      $scope.size.remove()
#      $scope.dough.remove()

angular.module('Muzza.directives').directive 'empanadas', ($log, $ionicModal, ShoppingCart, Empanada) ->
  restrict: 'EA'
  scope: {
    menu: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: 'menu-empanadas.html'
  link: ($scope, ele, attrs, ctrl)->

#   holds temp selection
    $scope.empanada = {
      type: {}
    }

    #   this could come from firebase, or we can override when starting the app with a decorator at config phase
    $scope.steps = ['order', 'type']

    $ionicModal.fromTemplateUrl 'empanada-type.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->

      $scope.type = modal
      $scope.type.choose = ()->
        $scope.type.hide()

    $ionicModal.fromTemplateUrl 'empanada-order.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.order = modal
      $scope.order.add = ()->
        ShoppingCart.addToCart $scope.empanada
        $scope.order.hide()

      $scope.order.cancel = ->
        $scope.order.hide()

      $scope.order.edit = ()->
        $scope.choose($scope.empanada)


    $scope.choose = (item)->
      $scope.empanada = new Empanada item
      if angular.isDefined item.qty
        $scope.empanada.qty = item.qty

      angular.forEach $scope.steps, (key, val)->
        modal = $scope[key]
        modal.show()


angular.module('Muzza.directives').directive 'cart', ($ionicModal, ShoppingCart, PizzaOrder) ->
  restrict: 'EA'
  scope: {}
  templateUrl: 'cart.html'
  link: ($scope, ele, attrs, ctrl)->
    $scope.cart = ShoppingCart.getCart()

    $scope.edit = (item)->
      $scope[item.type] = item
      modalName = "#{item.type}-order.html"
      $ionicModal.fromTemplateUrl modalName,
        scope: $scope,
        animation: 'slide-in-up'
      .then (modal) ->
        $scope.order = create(item.type,modal)
        $scope.order.show()

    create = (type, modal)->
      #TODO: dynamic classname instantiation????
      switch type
        when "pizza" then new PizzaOrder(modal)

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
