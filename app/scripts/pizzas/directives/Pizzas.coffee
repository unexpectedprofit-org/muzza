angular.module('Muzza.pizzas').directive 'pizzas', ($log, $ionicModal, ShoppingCartService, PizzaSize, PizzaDough, PizzaOrder, $state, $stateParams, $q) ->
  restrict: 'EA'
  scope: {
    menu: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: '../app/scripts/pizzas/templates/menu-pizzas.html'
  link: ($scope, ele, attrs, ctrl)->

#   holds temp selection
    $scope.pizza = {}

    #   this could come from firebase, or we can override when starting the app with a decorator at config phase
    $scope.steps = ['order', 'dough', 'size']

    size = $ionicModal.fromTemplateUrl '../app/scripts/pizzas/templates/pizza-size.html',
      scope: $scope,
      animation: 'slide-in-up'

    dough = $ionicModal.fromTemplateUrl '../app/scripts/pizzas/templates/pizza-dough.html',
      scope: $scope,
      animation: 'slide-in-up'

    order = $ionicModal.fromTemplateUrl '../app/scripts/pizzas/templates/pizza-order.html',
      scope: $scope,
      animation: 'slide-in-up'

    $scope.choose = (pizza, hashKey)->

      $scope.pizza = pizza

      if hashKey then editCartItem hashKey

      if $scope.pizza?
        angular.forEach $scope.steps, (key, val)->
          modal = $scope[key]
          modal.show()

    editCartItem = (hashKey)->
      item = ShoppingCartService.get hashKey
      if item.cat == 'PIZZA'
        #RESET PRICE to base
        item.totalPrice = item.price.base
        $scope.pizza = item


    init = ->

      $q.all([order, dough, size]).then (views)->

        $scope.order = new PizzaOrder(views[0])
        $scope.dough = new PizzaDough(views[1])
        $scope.size = new PizzaSize(views[2])

        #        If its coming from the shopping cart
        if $stateParams.id then $scope.choose(null, $stateParams.id)

    init()