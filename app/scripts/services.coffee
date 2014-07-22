angular.module("Muzza.services", ['Muzza.constants', 'Muzza.promo', 'Muzza.product'])


angular.module("Muzza.services").service "ProductService", (stores, Product, PromotionTypeFactory) ->

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



angular.module("Muzza.services").factory "OrderService", () ->

  class OrderDetailsObject
    constructor: ( data ) ->
      @number = "AXAHA263920"
      @date = "15-feb-2010"
      @total =  100.20
      @contact =
        name: "Gonzalo"
        tel: "1111 2222"
        email: "gonzalo.docarmo@gmail.com"
        isDelivery: true
        address: "Av. Gonzalo 5100 - Capital"
      @products = {}

  submitOrder = () ->
    ######################### back end data
    return new OrderDetailsObject {}

  placeOrder: submitOrder
