angular.module('Muzza.contact').directive 'contact', (OrderService,$state, $stateParams)->
  restrict: 'EA'
  scope: {}
  templateUrl: '../app/scripts/contact/templates/contact.html'
  link: ($scope, ele, attrs, ctrl)->

    $scope.contact = OrderService.retrieveConnectionInfo() or {}

    $scope.deliveryOption = $stateParams.method

    $scope.continue =  ()->
      OrderService.addContactInfo($scope.contact).then ()->
        if $scope.deliveryOption is 'delivery' then $state.go 'app.menu'
        if $scope.deliveryOption is 'pickup' then $state.go 'app.stores'
      , (errorMsg)->
        $scope.error = errorMsg



