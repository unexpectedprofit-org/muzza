angular.module('Muzza.promo').controller 'PromotionDetails', ($stateParams, $scope, PromotionService, ProductService, Promotion, ShoppingCartService, $state) ->

  menu = ProductService.getMenu '', 'promo'

  promotions = _.filter menu.promo, (elem) ->
    elem.details.id is parseInt($stateParams.promoId)

  $scope.promotion = promotions[0]

  $scope.promotion.components = PromotionService.createPromotionComponentsList $scope.promotion.rules

  $scope.$watch 'promotion.components', (newObject) ->
    $scope.isSelectionValid = $scope.promotion.validate()

    $scope.isPromoValid = {}

    _.each $scope.promotion.rules, (rule) ->
      ruleID = rule.id
      response = $scope.promotion.validateRule ruleID
      $scope.isPromoValid[ruleID] = response

  , true

  $scope.choose = (promotion)->
    ShoppingCartService.add new Promotion promotion
    $state.go "app.category", {category: 'promo'}