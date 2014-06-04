angular.module('Muzza.bebidas').directive 'bebidas', ($log, $ionicModal, ShoppingCartService, BebidaSize, BebidaOrder, $state, $stateParams, $q, Bebida) ->
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
    $scope.bebida = {}

    #   this could come from firebase, or we can override when starting the app with a decorator at config phase
    $scope.steps = ['order', 'size']

    size = $ionicModal.fromTemplateUrl '../app/scripts/bebida/templates/bebida-size.html',
      scope: $scope,
      animation: 'slide-in-up'

    order = $ionicModal.fromTemplateUrl '../app/scripts/bebida/templates/bebida-order.html',
      scope: $scope,
      animation: 'slide-in-up'

    $scope.choose = (bebida, hashKey)->

      $scope.bebida = undefined
      # Reminder: we create a new to avoid modifying the model that comes from the menu
      if bebida? then $scope.bebida = new Bebida bebida

      if hashKey then editCartItem hashKey

      if $scope.bebida?
        angular.forEach $scope.steps, (key, val)->
          modal = $scope[key]
          modal.show()

    editCartItem = (id)->
      item = angular.copy (ShoppingCartService.get id)
      if item.cat == 'BEBIDA'
        item.resetPrice()
        $scope.bebida = item


    init = ->

      $q.all([order,size]).then (views)->

        $scope.order = new BebidaOrder views[0]
        $scope.size = new BebidaSize views[1]

        #        If its coming from the shopping cart
        if $stateParams.bebidaId then $scope.choose(null, $stateParams.bebidaId)

    init()