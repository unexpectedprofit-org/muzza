angular.module("Muzza.promo", ["Muzza.services"]).directive "promotions", ($ionicModal, PromotionDetails, $q, ProductService) ->
  restrict: 'EA'
  scope: {
    menu: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: '../app/scripts/promotion/templates/menu-promotions.html'


  link: ($scope, ele, attrs, ctrl)->

    $scope.filterProductsBySelection = (products, ruleSubCat) ->

      result = products

      #|FRITA||
      subCatComponents = ruleSubCat.split('|')

      #ID_PROD
      ruleProp1 = (if subCatComponents[0].length > 0 then subCatComponents[0] else undefined)
      #TYPE:
      # DE LA CASA / ESPECIAL
      # FRITO / HORNO
      ruleProp2 = (if subCatComponents[1].length > 0 then subCatComponents[1] else undefined)
      # SIZE
      ruleProp3 = (if subCatComponents[2].length > 0 then subCatComponents[2] else undefined)
      # DOUGH
      ruleProp4 = (if subCatComponents[3].length > 0 then subCatComponents[3] else undefined)


      #filter by type only for the moment
      if ruleProp2 isnt undefined

        #FOR EMPANADA: TO BE REFACTORED
        if ruleProp2 is "HORNO" then ruleProp2 = 1
        if ruleProp2 is "FRITA" then ruleProp2 = 2
        #FOR EMPANADA: TO BE REFACTORED

        result = _.filter products, (prod) ->
          prod.id is ruleProp2


      return result

    $scope.setQuantitiesToZero = (products) ->
      _.forEach products, (currentProductsCategory) ->
        _.forEach currentProductsCategory.products, (currentProd) ->
          currentProd.qty = 0

      products


    $scope.createPromoComponentsList = (promotionRules) ->
      filteredProducts = []

      _.forEach promotionRules, (rule) ->
        products = ProductService.getProductsFromCategory rule.cat
        _temp = $scope.filterProductsBySelection products, rule.subcat
        _tempWithZero = $scope.setQuantitiesToZero _temp

        filteredProducts.push {cat:rule.cat,items:_tempWithZero}

      return filteredProducts



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
      if promotion? then  $scope.promotion = promotion

      $scope.promotion.components = $scope.createPromoComponentsList $scope.promotion.rules


      if $scope.promotion?
        angular.forEach $scope.steps, (key, val)->
          modal = $scope[key]
          modal.show()

    init = ->
      $q.all([details]).then (views)->
        $scope.details = new PromotionDetails views[0]


    init()