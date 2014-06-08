angular.module('Muzza.contact').directive 'contact', (OrderService,$state, $stateParams)->
  restrict: 'EA'
  scope: {}
  templateUrl: '../app/scripts/contact/templates/contact.html'
  link: ($scope, ele, attrs, ctrl)->

    $scope.contact = OrderService.retrieveConnectionInfo() or {}

    $scope.deliveryOption = $stateParams.method

    $scope.continue =  ()->
      OrderService.addContactInfo($scope.contact).then ()->
        $state.go 'app.menu'
      , (errorMsg)->
        $scope.error = errorMsg



