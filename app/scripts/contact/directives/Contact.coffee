angular.module('Muzza.contact').directive 'contact', (OrderService,$state, $stateParams)->
  restrict: 'EA'
  scope: {}
  templateUrl: '../app/scripts/contact/templates/contact.html'
  link: ($scope, ele, attrs, ctrl)->

    $scope.contact = {}

    $scope.deliveryOption = $stateParams.method

    $scope.continue =  ()->
      OrderService.addContactInfo($scope.contact)
      $state.go 'app.order-review'
