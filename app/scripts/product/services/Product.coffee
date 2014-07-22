angular.module("Muzza.product").service "ProductService", (stores, Product) ->

  # define variable here to hold menu info.
  # So that next time the menu is looked up, we don't need to go to the backend to get it again.

  getProductsByCompanyId = (id, catId)->
    constructMenu catId


  constructMenu = (categoryId) ->
    if categoryId isnt undefined
      category = _.find stores.store1.products, (elem) ->
        elem.id is parseInt categoryId
      categories = [category]
    else
      categories = stores.store1.products

    _.forEach categories, (category) ->
      category.products = _.map category.products, (product) ->
        product.categoryId = category.id
        new Product product

    categories


  getMenu: getProductsByCompanyId