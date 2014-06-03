angular.module('Muzza.twitter').directive 'twitterLogin', ($firebase, $firebaseSimpleLogin)->
  restrict: 'EA'
  scope: {
    user: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: '../app/scripts/twitter/templates/twitterLogin.html'
  link: ($scope, ele, attrs, ctrl)->

    ref = new Firebase("https://muzza.firebaseio.com/")
    auth = $firebaseSimpleLogin(ref)

    $scope.login = ()->
      auth.$login('twitter', {rememberMe: true}).then (user)->
        console.log user
        $scope.user.twitterId =  user.uid
        $scope.user.name = user.thirdPartyUserData.name
        $scope.user.email = user.thirdPartyUserData.email

    $scope.logout = ()->
      auth.$logout()
      $scope.user = {}


