angular.module('Muzza.google').directive 'googleLogin', ($firebase, $firebaseSimpleLogin)->
  restrict: 'EA'
  scope: {
    user: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: '../app/scripts/google/templates/googleLogin.html'
  link: ($scope, ele, attrs, ctrl)->

    ref = new Firebase("https://muzza.firebaseio.com/")
    auth = $firebaseSimpleLogin(ref)

    $scope.login = ()->
      auth.$login('google', {rememberMe: true, scope: 'https://www.googleapis.com/auth/plus.login'}).then (user)->
        $scope.user.googleId =  user.uid
        $scope.user.name = user.thirdPartyUserData.name
        $scope.user.email = user.thirdPartyUserData.email

    $scope.logout = ()->
      auth.$logout()
      $scope.user = {}


