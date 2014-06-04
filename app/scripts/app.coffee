angular.module("Muzza.pizzas", ['ui.router'])
angular.module("Muzza.empanadas", [])
angular.module("Muzza.bebidas", [])
angular.module("Muzza.cart", [])
angular.module("Muzza.order", [])
angular.module("Muzza.promo", [])
angular.module("Muzza.delivery", [])
angular.module("Muzza.contact", [])
angular.module("Muzza.review", [])
angular.module("Muzza.qty", [])
angular.module("Muzza.facebook", ['firebase'])
angular.module("Muzza.google", ['firebase'])
angular.module("Muzza.twitter", ['firebase'])
angular.module("Muzza.config",[])

angular.module("Muzza", [ "pasvaz.bindonce","ionic", "Muzza.pizzas" ,"Muzza.empanadas", "Muzza.bebidas","Muzza.cart",
    "Muzza.controllers", "Muzza.directives", "Muzza.templates", "Muzza.services", "Muzza.constants",
    "Muzza.order", "Muzza.promo", "Muzza.delivery", "Muzza.contact", "Muzza.review", "Muzza.qty", "Muzza.facebook"
    , "Muzza.google", "Muzza.twitter", "Muzza.config"])

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

  .state "app.category",
    url: "/menu/:category"
    views:
      'navContent':
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

  .state "app.cart",
    url: "/cart"
    views:
      navContent:
        templateUrl: "../app/scripts/cart/templates/cart-view.html"

  .state "app.orderplace",
    url: "/order/confo"
    views:
      navContent:
        templateUrl: "templates/confo.html"
        controller: "PlaceOrderCtrl"

  .state "app.order-delivery",
    url: "/delivery"
    views:
      navContent:
        templateUrl: "../app/scripts/delivery/templates/delivery-option.html"

  .state "app.order-contact",
    url: "/contact/:method"
    views:
      navContent:
        templateUrl: "../app/scripts/contact/templates/contact-info.html"

  .state "app.order-review",
    url: "/review"
    views:
      navContent:
        templateUrl: "../app/scripts/review/templates/review-order.html"



  # if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise "/app/menu"