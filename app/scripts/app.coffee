
angular.module("Muzza.pizzas", ['ui.router'])
angular.module("Muzza.empanadas", [])
angular.module("Muzza.cart", [])
angular.module("Muzza.order", [])

angular.module("Muzza", [ "ionic", "Muzza.pizzas" ,"Muzza.empanadas", "Muzza.cart", "Muzza.controllers", "Muzza.directives", "Muzza.templates", "Muzza.services", "Muzza.constants"])

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

  .state "app.pizza",
    url: "/menu/pizza/:pizzaId"
    views:
      'navContent':
        templateUrl: "templates/menu.html"

  .state "app.empanada",
    url: "/menu/empanada/:empanadaId"
    views:
      'navContent':
        templateUrl: "templates/menu.html"

  .state "app.store",
    url: "/menu/:storeID"
    views:
      navContent:
        templateUrl: "templates/menu.html"
        controller: "MenuCtrl"

  .state "app.stores",
    url: "/stores"
    views:
      navContent:
        templateUrl: "templates/stores.html"
        controller: "StoreCtrl"

  .state "app.orderplace",
    url: "/order/confo"
    views:
      navContent:
        templateUrl: "templates/confo.html"
        controller: "PlaceOrderCtrl"


  # if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise "/app/menu"