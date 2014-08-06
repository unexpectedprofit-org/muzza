angular.module('Muzza.contact').directive 'contact', (Contact,$state, $stateParams)->
  restrict: 'EA'
  scope: {}
  templateUrl: '../app/scripts/contact/templates/contact.html'
  link: ($scope, ele, attrs, ctrl)->

    Contact.retrieveContactInfo().then (userInfo)->
      $scope.contact = userInfo or {}

    $scope.deliveryOption = $stateParams.method

    $scope.continue =  ()->
      Contact.addContactInfo($scope.contact)
      $state.go 'app.stores', deliveryOption: $scope.deliveryOption



