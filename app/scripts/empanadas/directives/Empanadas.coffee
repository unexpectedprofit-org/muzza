angular.module('Muzza.empanadas').directive 'empanadas', ($log, $ionicModal, ShoppingCartService, Empanada, EmpanadaOrder, $q, $stateParams) ->
  restrict: 'EA'
  scope: {
    menu: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: '../app/scripts/empanadas/templates/menu-empanadas.html'
  link: ($scope, ele, attrs, ctrl)->

#   holds temp selection
    $scope.empanada = {}

    #   this could come from firebase, or we can override when starting the app with a decorator at config phase
    $scope.steps = ['order']


    order = $ionicModal.fromTemplateUrl '../app/scripts/empanadas/templates/empanada-order.html',
      scope: $scope,
      animation: 'slide-in-up'

    $scope.remove = () ->
      $scope.empanada = undefined

    $scope.choose = (empanada, hashKey)->

      if hashKey
        editCartItem hashKey
      else
        if empanada instanceof Empanada
          $scope.empanada = empanada
        else
          $scope.empanada = new Empanada empanada

      if $scope.empanada?
        angular.forEach $scope.steps, (key, val)->
          modal = $scope[key]
          modal.show()

    editCartItem = (hashKey)->
      item = ShoppingCartService.get hashKey
      if item.cat == 'EMPANADA'
        $scope.empanada = item

    init = ->
      $q.all([order]).then (views)->
        $scope.order = new EmpanadaOrder views[0]

        # If its coming from the shopping cart
        if $stateParams.empanadaId then $scope.choose(null, $stateParams.empanadaId)

    init()