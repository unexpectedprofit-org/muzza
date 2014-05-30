angular.module('Muzza.pizzas').directive 'qty', ()->
  restrict: 'EA'
  scope: {
    item: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: '../app/scripts/pizza/templates/pizza-qty.html'
#  link: ($scope, ele, attrs, ctrl)->
