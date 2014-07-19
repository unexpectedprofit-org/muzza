angular.module('Muzza.product').directive 'product', (ShoppingCartService, $ionicModal, $rootScope, $stateParams, Product) ->
  restrict: 'E'
  required: 'ngModel'
  scope: {
    product: '=ngModel'
  }
  templateUrl: '../app/scripts/product/templates/product.html'
  link: ($scope, ele, attrs, ctrl) ->



    $scope.chooseProduct = (product) ->

      options = $ionicModal.fromTemplateUrl '../app/scripts/product/templates/product-view.html',
        scope: $scope,
        animation: 'slide-in-up'

      options.then (view)->
        $scope.productOptions = view
        product.clearSelections()
        $scope.product = new Product product


        ################### intended for products that can have quantities per item #######################
        ################### multipleQty: current example: PROMO
        _.each $scope.product.options, (option) ->
          if option.config.multipleQty

            option.selection = []

            _.each option.items, (item) ->

              option.selection.push item

              item.qty = 0

              item.updateQty = (value) ->
                item.qty += value
                if item.qty < 0 then item.qty = 0
        ################### intended for products that can have quantities per item #######################


        $scope.productOptions.show()

        $rootScope.$on 'PRODUCT_SELECTED_TO_BE_ADDED_TO_CART', (event, productSelected) ->
          ShoppingCartService.add productSelected
          $scope.productOptions.remove()