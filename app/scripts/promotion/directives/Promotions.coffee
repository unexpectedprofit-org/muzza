angular.module("Muzza.promo").directive "promotions", () ->
  restrict: 'EA'
  scope: {
    menu: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: '../app/scripts/promotion/templates/menu-promotions.html'