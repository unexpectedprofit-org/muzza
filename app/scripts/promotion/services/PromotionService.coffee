angular.module('Muzza.promo').service 'PromotionService', ($log, ProductService) ->

  setQuantitiesToZero = (products) ->
    _.forEach products, (currentProductsCategory) ->
      _.forEach currentProductsCategory.products, (currentProd) ->
        currentProd.qty = 0
    products

  filterProductsBySelection = (products, ruleSubCat) ->
    result = products
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
      result = _.filter products, (prod) ->
        prod.id is parseInt(ruleProp2)

    result

  getPromoComponentsList = (promotionRules) ->
    filteredProducts = {}

    _.forEach promotionRules, (rule) ->
      productsList = ProductService.getProductsFromCategory rule.cat

      ## temp to populate pizzas with default size
      if rule.cat is "PIZZA"
        _.forEach productsList, (category) ->
          _.forEach category.products, (product) ->
            product.size = "grande"
      ## temp to populate pizzas with default size

      _temp = filterProductsBySelection productsList, rule.subcat
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