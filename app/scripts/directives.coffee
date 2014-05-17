angular.module('Muzza.directives', [])

angular.module('Muzza.directives').directive 'pizzas', ($log, $ionicModal) ->
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
    $scope.steps = ['dough', 'size']

    $ionicModal.fromTemplateUrl 'pizza-size.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.size = modal
      $scope.size.choose = (value)->
        $scope.pizza.size = value
        $scope.size.hide()
        if $scope.size.isLastToBeDisplayed then $scope.add()

    $ionicModal.fromTemplateUrl 'pizza-dough.html',
      scope: $scope,
      animation: 'slide-in-up'
    .then (modal) ->
      $scope.dough = modal
      $scope.dough.choose = (value)->
        $scope.pizza.dough = value
        $scope.dough.hide()
        if $scope.dough.isLastToBeDisplayed then $scope.add()

    $scope.choose = (item)->
      $scope.pizza = angular.copy(item)
      angular.forEach $scope.steps, (key, val)->
        modal = $scope[key]
        modal.isLastToBeDisplayed = (val == 0)
        modal.show()

    $scope.add = ()->
      $scope.pizzas.push $scope.pizza
      $log.log 'added to cart: ' + angular.toJson($scope.pizzas)

#    $scope.$on '$destroy', ->
#      $log.log 'destroy'
#      $scope.size.remove()
#      $scope.dough.remove()



