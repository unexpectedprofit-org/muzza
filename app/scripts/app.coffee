angular.module("Muzza", [ "ionic", "Muzza.controllers"])

angular.module("Muzza").run ($ionicPlatform) ->
  $ionicPlatform.ready ->
    StatusBar.styleDefault() if window.StatusBar

angular.module("Muzza").config ($stateProvider, $urlRouterProvider) ->
  $stateProvider.state "app",
    url: "/app"
    abstract: true
    templateUrl: "templates/nav.html"

  .state "app.menu",
    url: "/menu"
    views:
      menuContent:
        templateUrl: "templates/menu.html"

  # if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise "/app/menu"