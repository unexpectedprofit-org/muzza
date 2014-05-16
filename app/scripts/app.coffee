angular.module("Muzza", [ "ionic", "Muzza.controllers"])

angular.module("Muzza").run ($ionicPlatform) ->
  $ionicPlatform.ready ->
    StatusBar.styleDefault() if window.StatusBar

angular.module("Muzza").config ($stateProvider, $urlRouterProvider) ->
  $stateProvider.state "app",
    url: "/app"
    abstract: true
    templateUrl: "templates/menu.html"
    controller: "AppCtrl"

  .state "app.search",
    url: "/search"
    views:
      menuContent:
        templateUrl: "templates/search.html"

  .state "app.browse",
    url: "/browse"
    views:
      menuContent:
        templateUrl: "templates/browse.html"

  .state "app.playlists",
    url: "/playlists"
    views:
      menuContent:
        templateUrl: "templates/playlists.html"
        controller: "PlaylistsCtrl"

  .state "app.single",
    url: "/playlists/:playlistId"
    views:
      menuContent:
        templateUrl: "templates/playlist.html"
        controller: "PlaylistCtrl"

  .state "app.store.new",
    url: "/store/add"
    views:
      menuContent:
        templateUrl: "templates/playlist.html"
        controller: "StoreCtrl"

  # if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise "/app/playlists"