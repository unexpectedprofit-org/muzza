angular.module('Muzza.promo').service 'PromotionService', ($log, PromotionUtil, ProductService) ->

  setQuantitiesToZero = (products) ->
    _.forEach products, (currentProductsCategory) ->
      _.forEach currentProductsCategory.products, (currentProd) ->
        currentProd.qty = 0
    products


  getPromoComponentsList = (promotionRules) ->
    filteredProducts = {}

    _.forEach promotionRules, (promoRule) ->
      ruleProperties = promoRule.properties

      productsListByCategory = ProductService.getProductsFromCategory ruleProperties.cat
#      console.log "productsListByCategory: " + JSON.stringify productsListByCategory

      ## temp to populate pizzas with default size
      if ruleProperties.cat is "PIZZA"
        _.forEach productsListByCategory, (category) ->
          _.forEach category.products, (product) ->
            product.size = "grande"
      ## temp to populate pizzas with default size

      _temp = PromotionUtil.filterProductsBySelection productsListByCategory, ruleProperties
      _tempWithZero = setQuantitiesToZero _temp

      if angular.isUndefined( filteredProducts[ruleProperties.cat] )
        filteredProducts[ruleProperties.cat] = []

      _.each _tempWithZero, (elem) ->
        elem.ruleId = ruleProperties.id
        filteredProducts[ruleProperties.cat].push elem

    returnResults = {}

    _.forEach promotionRules, (promoRule) ->
      ruleProperties = promoRule.properties
      returnResults[ruleProperties.cat] = filteredProducts[ruleProperties.cat]

    returnResults

  createPromotionComponentsList: getPromoComponentsList