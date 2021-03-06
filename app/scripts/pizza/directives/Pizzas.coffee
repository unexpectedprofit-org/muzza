angular.module('Muzza.pizzas').directive 'pizzas', ($log, $ionicModal, ShoppingCartService, PizzaSize, PizzaDough, PizzaOrder, $state, $stateParams, $q, Pizza) ->
  restrict: 'EA'
  scope: {
    menu: '=ngModel'
    hideDetails: '=nodetails'
    isPromoValid: '=validationrules'
  }
  require: 'ngModel'
  templateUrl: '../app/scripts/pizza/templates/menu-pizzas.html'
  link: ($scope, ele, attrs, ctrl)->

#   holds temp selection
    $scope.pizzaSelection = {}

    #   this could come from firebase, or we can override when starting the app with a decorator at config phase
    $scope.steps = ['order', 'dough', 'size']

    size = $ionicModal.fromTemplateUrl '../app/scripts/pizza/templates/pizza-size.html',
      scope: $scope,
      animation: 'slide-in-up'

    dough = $ionicModal.fromTemplateUrl '../app/scripts/pizza/templates/pizza-dough.html',
      scope: $scope,
      animation: 'slide-in-up'

    order = $ionicModal.fromTemplateUrl '../app/scripts/pizza/templates/pizza-order.html',
      scope: $scope,
      animation: 'slide-in-up'

    $scope.choose = (pizza, hashKey)->

      $scope.pizzaSelection = undefined
      # Reminder: we create a new to avoid modifying the model that comes from the menu
      if pizza? then $scope.pizzaSelection = new Pizza pizza

      if hashKey then editCartItem hashKey

      if $scope.pizzaSelection?
        angular.forEach $scope.steps, (key, val)->
          modal = $scope[key]
          modal.show()

    editCartItem = (id)->
      item = angular.copy (ShoppingCartService.get id)
      if item.cat == 'PIZZA'
        item.resetPrice()
        $scope.pizzaSelection = item


    init = ->

      $q.all([order, dough, size]).then (views)->

        $scope.order = new PizzaOrder views[0]
        $scope.dough = new PizzaDough views[1]
        $scope.size = new PizzaSize views[2]

        #        If its coming from the shopping cart
        if $stateParams.pizzaId then $scope.choose(null, $stateParams.pizzaId)

    init()