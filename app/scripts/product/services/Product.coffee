angular.module("Muzza.product").service "ProductService", (ProductFileAdapter, Product) ->

  # define variable here to hold menu info.
  # So that next time the menu is looked up, we don't need to go to the backend to get it again.

  getProductsByCompanyId = (id, catId)->
    ProductFileAdapter.getMenu().then (response) ->
      constructMenu( catId, response.data )


  constructMenu = (categoryId, productsByCategory) ->

    if categoryId isnt undefined
      category = _.find productsByCategory, (elem) ->
        elem.id is parseInt categoryId
      categories = [category]

    else
      categories = productsByCategory

      _.forEach categories, (category) ->
        category.products = _.map category.products, (product) ->
          product.categoryId = category.id
          new Product product

      categories


  getMenu: getProductsByCompanyId