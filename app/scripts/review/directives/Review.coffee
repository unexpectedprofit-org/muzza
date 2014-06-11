angular.module('Muzza.review').directive 'review', (OrderService, $state)->
  restrict: 'EA'
  scope: {}
  templateUrl: '../app/scripts/review/templates/review.html'
  link: ($scope, ele, attrs, ctrl)->

    $scope.order = OrderService.retrieveOrder()

    $scope.submitOrder = ->
      OrderService.submitOrder().then ()->
        $state.go 'app.orderplace'

    $scope.editOrder = ->
      $state.go 'app.menu'



