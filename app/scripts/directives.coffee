angular.module('Muzza.directives',[])

angular.module("Muzza.directives").filter "centsToMoney", ->
  (cents) ->
    parseFloat(cents / 100).toFixed(2)

angular.module('Muzza.directives').directive 'cancelSelection', ()->
  restrict: 'EA'
  template: '<button class="button  button-block button-clear button-positive" data-ng-click="cancel()">Cancelar</button>'
  link: ($scope, ele, attrs, ctrl)->
    $scope.cancel = ->
      angular.forEach $scope.steps, (key, val)->
        modal = $scope[key]
        if modal isnt undefined
          modal.hide()

      if attrs.resetModel isnt undefined
        $scope[attrs.resetModel].reset()
        $scope[attrs.resetModel].qty = 0 if $scope.isPromoView
