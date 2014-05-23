angular.module('Muzza.empanadas').directive 'empanadas', ($log, $ionicModal, ShoppingCartService, Empanada, EmpanadaOrder, $q, $stateParams) ->
  restrict: 'EA'
  scope: {
    menu: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: '../app/scripts/empanadas/templates/menu-empanadas.html'
  link: ($scope, ele, attrs, ctrl)->

#   holds temp selection
    $scope.empanada = {
    }

    #   this could come from firebase, or we can override when starting the app with a decorator at config phase
    $scope.steps = ['order']


    order = $ionicModal.fromTemplateUrl '../app/scripts/empanadas/templates/empanada-order.html',
      scope: $scope,
      animation: 'slide-in-up'

    $scope.choose = (item, cat_desc, hashKey)->

      empanadaInCart = undefined

      if angular.isDefined hashKey
        empanadaInCart = ShoppingCartService.get hashKey

      if angular.isDefined empanadaInCart
        $scope.empanada = empanadaInCart
      else
        $scope.empanada = new Empanada item
        $scope.empanada.type = cat_desc


      angular.forEach $scope.steps, (key, val)->
        modal = $scope[key]
        modal.show()

    init = ->
      $q.all([order]).then (views)->
        $scope.order = new EmpanadaOrder views[0]

        #       If its coming from the shopping cart
        if $stateParams.id then $scope.choose(null, null, $stateParams.id)

    init()