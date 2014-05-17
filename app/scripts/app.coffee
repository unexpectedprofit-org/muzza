angular.module("Muzza", [ "ionic", "Muzza.controllers", "Muzza.directives", "Muzza.templates", "Muzza.services"])

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
      navContent:
        templateUrl: "templates/menu.html"

  .state "app.stores",
    url: "/stores"
    views:
      navContent:
        templateUrl: "templates/stores.html"
        controller: "StoreCtrl"

  # if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise "/app/menu"