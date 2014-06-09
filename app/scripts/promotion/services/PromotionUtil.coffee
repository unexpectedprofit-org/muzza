angular.module('Muzza.promo').service 'PromotionUtil', () ->


  #validate all product properties
  #BUT price/qty
  isProductApplicableToRule = (product, rule) ->
    continueSearch = true

    _.forEach (_.keys rule), (key) ->
      if continueSearch and
      key isnt 'price' and
      key isnt 'qty'
        if product[key] is undefined or product[key] isnt rule[key]
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



  productMatchesRule: isProductApplicableToRule
  filterProductsBySelection: getApplicableProductsByRule