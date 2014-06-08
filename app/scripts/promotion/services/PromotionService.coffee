angular.module('Muzza.promo').service 'PromotionService', ($log, PromotionUtil, ProductService) ->

  setQuantitiesToZero = (products) ->
    _.forEach products, (currentProductsCategory) ->
      _.forEach currentProductsCategory.products, (currentProd) ->
        currentProd.qty = 0
    products


  getPromoComponentsList = (promotionRules) ->
    filteredProducts = {}

    _.forEach promotionRules, (rule) ->
      productsListByCategory = ProductService.getProductsFromCategory rule.cat
#      console.log "productsListByCategory: " + JSON.stringify productsListByCategory


      ## temp to populate pizzas with default size
      if rule.cat is "PIZZA"
        _.forEach productsListByCategory, (category) ->
          _.forEach category.products, (product) ->
            product.size = "grande"
      ## temp to populate pizzas with default size

      _temp = PromotionUtil.filterProductsBySelection productsListByCategory, rule
      _tempWithZero = setQuantitiesToZero _temp

      ruleCat = rule.cat

      if angular.isUndefined( filteredProducts[ruleCat] )
        filteredProducts[ruleCat] = []

      _.each _tempWithZero, (elem) ->
        elem.ruleId = rule.id
        filteredProducts[ruleCat].push elem

    returnResults = {}

    _.forEach promotionRules, (rule) ->
      cate = rule.cat
      returnResults[cate] = filteredProducts[cate]

    returnResults

  createPromotionComponentsList: getPromoComponentsList