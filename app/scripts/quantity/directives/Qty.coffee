angular.module('Muzza.qty').directive 'qty', ()->
  restrict: 'EA'
  scope: {
    item: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: '../app/scripts/quantity/templates/qty.html'
#  link: ($scope, ele, attrs, ctrl)->
