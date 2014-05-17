angular.module('Muzza.directives', [])

angular.module('Muzza.directives').directive 'pizzas', ($log) ->
  restrict: 'EA'
  scope: {
    menu: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: 'menu-pizzas.html'
  link: (scope, ele, attrs, ctrl)->
    scope.add = (pizza)->
      $log.log 'added to cart: ' + pizza.title



