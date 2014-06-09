angular.module('Muzza.promo').service 'PromotionUtil', () ->

  #validate all product properties
  isProductApplicableToRule = (product, rule) ->
    continueSearch = true

    _.forEach (_.keys rule), (key) ->
      if continueSearch and key isnt 'size' and
      (product[key] is undefined or product[key] isnt rule[key])
        continueSearch = false
        return

    continueSearch


  getApplicableProductsByRule = (prodByCategory, rule) ->
    acumProd = []

    _.forEach prodByCategory, (subCat) ->

      prodMatching = _.filter subCat.products, (product) ->
        isProductApplicableToRule product, rule

      if prodMatching.length > 0
        prodsByCateg =
          id: subCat.id
          description: subCat.description
          products: prodMatching

        acumProd.push prodsByCateg

    acumProd

  setQuantitiesToZero = (productsListByCategory) ->
    _.forEach productsListByCategory, (category) ->
      _.forEach category.products, (product) ->
        product.qty = 0
    productsListByCategory

  setDefaultValues = (productsListByCategory, ruleProperties) ->

    productsListByCategory = setQuantitiesToZero productsListByCategory, ruleProperties

    if ruleProperties.cat is "PIZZA"
      _.forEach productsListByCategory, (category) ->
        _.forEach category.products, (product) ->
          product.size = ruleProperties.size

    productsListByCategory

  retrieveProducts = (productsListByCategory, ruleProperties) ->
    _result = getApplicableProductsByRule productsListByCategory, ruleProperties
    setDefaultValues _result, ruleProperties

  productMatchesRule: isProductApplicableToRule
  getPromotionProducts: retrieveProducts