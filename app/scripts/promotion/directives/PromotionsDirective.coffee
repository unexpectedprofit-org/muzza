angular.module("Muzza.promo").directive "promotions", ($ionicModal, Promotion, PromotionDetails, $q) ->
  restrict: 'EA'
  scope: {
    menu: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: '../app/scripts/promotion/templates/menu-promotions.html'
  link: ($scope, ele, attrs, ctrl)->


  #   holds temp selection
    $scope.promotion = {}

    #   this could come from firebase, or we can override when starting the app with a decorator at config phase
    $scope.steps = ['details']


    details = $ionicModal.fromTemplateUrl '../app/scripts/promotion/templates/details.html',
      scope: $scope,
      animation: 'slide-in-up'

    $scope.choose = (promotion)->

      $scope.promotion = undefined

      # Reminder: we create a new to avoid modifying the model that comes from the menu
      if promotion? then  $scope.promotion = new Promotion promotion

      if $scope.promotion?
        angular.forEach $scope.steps, (key, val)->
          modal = $scope[key]
          modal.show()

    init = ->
      $q.all([details]).then (views)->
        $scope.details = new PromotionDetails views[0]


    init()