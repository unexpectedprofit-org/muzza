angular.module('Muzza.delivery').directive 'delivery', (Delivery,$state)->
  restrict: 'EA'
  scope: {}
  templateUrl: '../app/scripts/delivery/templates/delivery.html'
  link: ($scope, ele, attrs, ctrl)->

    $scope.option = Delivery.retrieveDelivery() or ''

    $scope.chooseDelivery =  (option)->
      Delivery.chooseDelivery(option)
      $state.go 'app.order-contact', {method: option}
