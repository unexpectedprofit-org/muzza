angular.module('Muzza.facebook').directive 'facebookLogin', ($firebase, $firebaseSimpleLogin)->
  restrict: 'EA'
  scope: {
    user: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: '../app/scripts/facebook/templates/facebookLogin.html'
  link: ($scope, ele, attrs, ctrl)->

    ref = new Firebase("https://muzza.firebaseio.com/")
    auth = $firebaseSimpleLogin(ref)

    $scope.login = ()->
      auth.$login('facebook').then (user)->
        $scope.user.facebookId =  user.uid
        $scope.user.name = user.thirdPartyUserData.name

    $scope.logout = ()->
      auth.$logout()
      $scope.user = {}


