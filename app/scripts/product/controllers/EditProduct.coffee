angular.module('Muzza.product').controller 'EditProductCtrl', ($scope,product,$state, $rootScope)->


  setCurrentOptionsSelectedForDisplay = (product) ->

    _.each product.options, (option) ->

      selectOnlyOneOption = option.config.min is 1 and option.config.max is 1
      selectMultipleOptions = (option.config.max - option.config.min) > 0

      if selectOnlyOneOption

        selectItemIfMatched = (item) ->
          item.isSelected = item.description is option.selection[0].description

      if selectMultipleOptions

        selectItemIfMatched = (item) ->
          itemFound = _.find option.selection, (selectionElement) ->
            selectionElement.description is item.description
          item.isSelected = itemFound isnt undefined

      option.items.map( selectItemIfMatched )

  $scope.product = product
  setCurrentOptionsSelectedForDisplay $scope.product
  $rootScope.$on 'PRODUCT_SELECTED_TO_BE_ADDED_TO_CART', () ->
    $state.go 'app.cart'