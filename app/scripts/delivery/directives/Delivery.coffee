angular.module('Muzza.delivery').directive 'delivery', (OrderService,$state)->
  restrict: 'EA'
  scope: {}
  templateUrl: '../app/scripts/delivery/templates/delivery.html'
  link: ($scope, ele, attrs, ctrl)->

    $scope.option = OrderService.retrieveDelivery() or ''

    $scope.chooseDelivery =  (option)->
      OrderService.chooseDelivery(option)
      $state.go 'app.order-contact', {method: option}
