angular.module('Muzza.product').directive 'product', (ShoppingCartService, $ionicModal, $rootScope, $stateParams, Product) ->
  restrict: 'E'
  required: 'ngModel'
  scope: {
    menu: '=ngModel'

  }
  templateUrl: '../app/scripts/product/templates/product-menu.html'


  link: ($scope, ele, attrs, ctrl) ->

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
            console.log "setCurrentOptionsSelectedForDisplay " + JSON.stringify item

        else

          _.forEach option.items, (item) ->
            optionSelected = item.description

            itemFound = _.find option.selection, (selectionElement) ->
              selectionElement.description is optionSelected

            item.isSelected = itemFound isnt undefined
            console.log "setCurrentOptionsSelectedForDisplay - itemFound?: " + itemFound

      null


    if $stateParams.productId then $scope.chooseProduct null, $stateParams.productId