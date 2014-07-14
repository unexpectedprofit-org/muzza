angular.module('Muzza.bebidas').directive 'bebidas', ($log, $ionicModal, ShoppingCartService, BebidaOrder, $q, Bebida) ->
  restrict: 'EA'
  scope: {
    menu: '=ngModel'
    hideDetails: '=nodetails'
    isPromoValid: '=validationrules'
  }
  require: 'ngModel'
  templateUrl: '../app/scripts/bebida/templates/menu-bebidas.html'

  link: ($scope, ele, attrs, ctrl)->

#   holds temp selection
    $scope.bebidaSelection = {}

    #   this could come from firebase, or we can override when starting the app with a decorator at config phase
    $scope.steps = ['order']

    order = $ionicModal.fromTemplateUrl '../app/scripts/bebida/templates/bebida-order.html',
      scope: $scope,
      animation: 'slide-in-up'


    $scope.choose = (bebida)->

      $scope.bebidaSelection = undefined
      # Reminder: we create a new to avoid modifying the model that comes from the menu
      if bebida? then $scope.bebidaSelection = new Bebida bebida

      if $scope.bebidaSelection?
        angular.forEach $scope.steps, (key, val)->
          modal = $scope[key]
          modal.show()

    init = ->

      $q.all([order]).then (views)->
        $scope.order = new BebidaOrder views[0]


    init()