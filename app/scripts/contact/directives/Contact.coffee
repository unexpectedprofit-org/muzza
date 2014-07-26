angular.module('Muzza.contact').directive 'contact', (Contact,$state, $stateParams)->
  restrict: 'EA'
  scope: {}
  templateUrl: '../app/scripts/contact/templates/contact.html'
  link: ($scope, ele, attrs, ctrl)->

    $scope.contact = Contact.retrieveConnectionInfo() or {}

    $scope.deliveryOption = $stateParams.method

    $scope.continue =  ()->
      Contact.addContactInfo($scope.contact)
      $state.go 'app.stores', deliveryOption: $scope.deliveryOption



