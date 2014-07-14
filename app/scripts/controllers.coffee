angular.module("Muzza.controllers", ['Muzza.services'])

angular.module("Muzza.controllers").controller "MenuCtrl", ($scope, $stateParams, ProductService, Product, $rootScope, ShoppingCartService, $state, $ionicModal) ->

# TODO: this should go into the product directive. not productOptions...product directive
  $scope.chooseProduct = (product, productHashKey) ->

    options = $ionicModal.fromTemplateUrl '../app/scripts/product/templates/product-view.html',
      scope: $scope,
      animation: 'slide-in-up'

    options.then (view)->
      $scope.productOptions = view

      if productHashKey
        editCartItem productHashKey
      else
        $scope.product = new Product product


      $scope.productOptions.show()

      $rootScope.$on 'PRODUCT_SELECTED_TO_BE_ADDED_TO_CART', (event, productSelected) ->
        ShoppingCartService.add productSelected
        $scope.productOptions.hide()


  if $stateParams.productId then $scope.chooseProduct null, $stateParams.productId

  editCartItem = (hashId) ->
    item = angular.copy ShoppingCartService.get hashId
#    item.resetPrice()
    $scope.product = new Product item

    $scope.setCurrentOptionsSelectedForDisplay $scope.product



  $scope.setCurrentOptionsSelectedForDisplay = (product) ->
    _.forEach product.options, (option) ->

      if option.config.min is 1 and option.config.max is 1
        optionSelected = option.selection[0].description

        _.forEach option.items, (item) ->
          item.isSelected = item.description is optionSelected
          console.log JSON.stringify item

      else

        _.forEach option.items, (item) ->
          optionSelected = item.description

          itemFound = _.find option.selection, (selectionElement) ->
            selectionElement.description is optionSelected

          item.isSelected = itemFound isnt undefined
          console.log "itemFound?: " + itemFound

    null


# TODO: this should go into the product directive. not productOptions...product directive




  $scope.viewCart = () ->
    $state.go 'app.cart'

  $rootScope.storeId = $stateParams.storeID

  $scope.cartTotalPrice = ShoppingCartService.getTotalPrice()
  $rootScope.$on 'CART:PRICE_UPDATED', (event, newValue) ->
    $scope.cartTotalPrice = newValue

  $scope.menu = ProductService.getMenu($rootScope.storeId, $stateParams.category)