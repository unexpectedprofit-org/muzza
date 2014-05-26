angular.module('Muzza.directives', ['Muzza.factories'])

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
        modal.hide()
#      console.log "cancelar button: "
#      console.log "empa: " + JSON.stringify $scope.empanada
#      console.log "pizza: " + JSON.stringify  $scope.pizza