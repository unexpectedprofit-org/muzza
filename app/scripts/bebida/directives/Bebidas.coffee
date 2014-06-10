angular.module('Muzza.bebidas').directive 'bebidas', ($log, $ionicModal, ShoppingCartService, BebidaSize, BebidaOrder, BebidaPromoOrder, $state, $stateParams, $q, Bebida) ->
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
    $scope.stepsPromo = ['orderPromo']

    orderPromo = $ionicModal.fromTemplateUrl '../app/scripts/bebida/templates/bebida-order-promo.html',
      scope: $scope,
      animation: 'slide-in-up'

    order = $ionicModal.fromTemplateUrl '../app/scripts/bebida/templates/bebida-order.html',
      scope: $scope,
      animation: 'slide-in-up'


    $scope.choosePromoItem = (bebida) ->

      $scope.bebidaSelection = new Bebida bebida

      if $scope.bebidaSelection?
        angular.forEach $scope.stepsPromo, (key, val)->
          modal = $scope[key]
          modal.show()

    $scope.choose = (bebida, hashKey)->

      $scope.bebidaSelection = undefined
      # Reminder: we create a new to avoid modifying the model that comes from the menu
      if bebida? then $scope.bebidaSelection = new Bebida bebida

      if hashKey then editCartItem hashKey

      if $scope.bebidaSelection?
        angular.forEach $scope.steps, (key, val)->
          modal = $scope[key]
          modal.show()

    editCartItem = (id)->
      item = angular.copy (ShoppingCartService.get id)
      if item.cat == 'BEBIDA'
        item.resetPrice()
        $scope.bebidaSelection = item


    init = ->

      $q.all([order,orderPromo]).then (views)->

        $scope.order = new BebidaOrder views[0]
        $scope.orderPromo = new BebidaPromoOrder views[1]

        #        If its coming from the shopping cart
        if $stateParams.bebidaId then $scope.choose(null, $stateParams.bebidaId)

    init()