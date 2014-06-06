angular.module('Muzza.empanadas').directive 'empanadas', ($log, $ionicModal, ShoppingCartService, Empanada, EmpanadaOrder, $q, $stateParams) ->
  restrict: 'EA'
  scope: {
    menu: '=ngModel'
    hideDetails: '=nodetails'
    isPromoValid: '=validationrules'
  }
  require: 'ngModel'
  templateUrl: '../app/scripts/empanada/templates/menu-empanadas.html'
  link: ($scope, ele, attrs, ctrl)->

#   holds temp selection
    $scope.empanadaSelection = {}

    #   this could come from firebase, or we can override when starting the app with a decorator at config phase
    $scope.steps = ['order']


    order = $ionicModal.fromTemplateUrl '../app/scripts/empanada/templates/empanada-order.html',
      scope: $scope,
      animation: 'slide-in-up'

    $scope.remove = () ->
      $scope.empanadaSelection = undefined

    $scope.choose = (empanada, hashKey)->

      $scope.empanadaSelection = undefined

      # Reminder: we create a new to avoid modifying the model that comes from the menu
      if empanada? then  $scope.empanadaSelection = new Empanada empanada

      if hashKey then editCartItem hashKey

      if $scope.empanadaSelection?
        angular.forEach $scope.steps, (key, val)->
          modal = $scope[key]
          modal.show()

    editCartItem = (id)->
      item = angular.copy (ShoppingCartService.get id)
      if item.cat == 'EMPANADA'
        $scope.empanadaSelection = item

    init = ->
      $q.all([order]).then (views)->
        $scope.order = new EmpanadaOrder views[0]

        # If its coming from the shopping cart
        if $stateParams.empanadaId then $scope.choose(null, $stateParams.empanadaId)

    init()