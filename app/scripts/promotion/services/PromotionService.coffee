angular.module('Muzza.promo').service 'PromotionService', ($log, PromotionUtil, ProductService) ->

  getPromoComponentsList = (promotionRules) ->
    filteredProducts = {}

    _.forEach promotionRules, (promoRule) ->
      ruleProperties = promoRule.properties

      productsListByCategory = ProductService.getProductsFromCategory ruleProperties.cat
      tempProducts = PromotionUtil.getPromotionProducts productsListByCategory, ruleProperties

      if angular.isUndefined( filteredProducts[ruleProperties.cat] )
        filteredProducts[ruleProperties.cat] = []

      _.each tempProducts, (elem) ->
        elem.ruleId = promoRule.id
        filteredProducts[ruleProperties.cat].push elem

    returnResults = {}

    _.forEach promotionRules, (promoRule) ->
      ruleProperties = promoRule.properties
      returnResults[ruleProperties.cat] = filteredProducts[ruleProperties.cat]

    returnResults

  createPromotionComponentsList: getPromoComponentsList