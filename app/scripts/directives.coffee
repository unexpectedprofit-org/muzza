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
      console.log "cancelar button: "
      console.log "empa: " + JSON.stringify $scope.empanada
      console.log "pizza: " + JSON.stringify  $scope.pizza

angular.module('Muzza.directives').directive 'pizzas', ($log, $ionicModal, ShoppingCartService, PizzaSize, PizzaDough, PizzaOrder, $state, $stateParams, $q) ->
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

    size = $ionicModal.fromTemplateUrl 'pizza-size.html',
      scope: $scope,
      animation: 'slide-in-up'

    dough = $ionicModal.fromTemplateUrl 'pizza-dough.html',
      scope: $scope,
      animation: 'slide-in-up'

    order = $ionicModal.fromTemplateUrl 'pizza-order.html',
      scope: $scope,
      animation: 'slide-in-up'

    $scope.choose = (pizza, hashKey)->

      $scope.pizza = pizza

      if hashKey
        item = ShoppingCartService.get hashKey
        if item.cat == 'PIZZA' then $scope.pizza = item

      if $scope.pizza?
        angular.forEach $scope.steps, (key, val)->
          modal = $scope[key]
          modal.show()

    init = ->

      $q.all([order, dough, size]).then (views)->

        $scope.order = new PizzaOrder(views[0])
        $scope.dough = new PizzaDough(views[1])
        $scope.size = new PizzaSize(views[2])

#        If its coming from the shopping cart
        if $stateParams.id then $scope.choose(null, $stateParams.id)

    init()

angular.module('Muzza.directives').directive 'empanadas', ($log, $ionicModal, ShoppingCartService, Empanada, EmpanadaOrder, $q) ->
  restrict: 'EA'
  scope: {
    menu: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: 'menu-empanadas.html'
  link: ($scope, ele, attrs, ctrl)->

#   holds temp selection
    $scope.empanada = {
    }

    #   this could come from firebase, or we can override when starting the app with a decorator at config phase
    $scope.steps = ['order']


    order = $ionicModal.fromTemplateUrl 'empanada-order.html',
      scope: $scope,
      animation: 'slide-in-up'

    $scope.choose = (item, cat_desc)->
      $scope.empanada = new Empanada item

      if angular.isDefined cat_desc
        $scope.empanada.type = cat_desc

      if angular.isDefined item.qty
        $scope.empanada.qty = item.qty

      angular.forEach $scope.steps, (key, val)->
        modal = $scope[key]
        modal.show()

    init = ->
      $q.all([order]).then (views)->
        $scope.order = new EmpanadaOrder views[0]

        #        If its coming from the shopping cart
#        if $stateParams.id then $scope.choose(null, $stateParams.id)

    init()

angular.module('Muzza.directives').directive 'cart', ($ionicModal, ShoppingCartService, PizzaOrder, $state) ->
  restrict: 'EA'
  scope: {}
  templateUrl: 'cart.html'
  link: ($scope, ele, attrs, ctrl)->

    $scope.edit = (item)->
      switch item.cat
        when 'EMPANADA' then $state.go 'app.empanada', {id: item.hash}
        when 'PIZZA'    then $state.go 'app.pizza', {id: item.hash}
        else $state.go 'app.menu'

    $scope.cart =
      products: ShoppingCartService.getCart()
      totalPrice: ShoppingCartService.getTotalPrice


angular.module('Muzza.directives').directive 'checkoutButton', ($ionicModal, $state, ShoppingCartService) ->
  restrict: 'EA'
  scope: {}
  template: '<button class="button button-block button-positive"
              data-ng-if="cart.items.length > 0"
              data-ng-click="checkout()">Realizar Pedido</button>'

  link: ($scope, ele, attrs, ctrl)->

    $scope.cart = ShoppingCartService.getCart()

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
