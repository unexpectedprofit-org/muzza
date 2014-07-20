angular.module('Muzza.product').controller 'EditProductCtrl', ($scope,product,$state, $rootScope)->


  setCurrentOptionsSelectedForDisplay = (product) ->

    _.each product.options, (option) ->

      if option.type is "SINGLE"

        selectItemIfMatched = (item) ->
          item.isSelected = item.description is option.selection[0].description

      ################### intended for products that can have quantities per item #######################
      ################### multipleQty: current example: PROMO
      if option.type is "MULTIPLE_QTY"

        selectItemIfMatched = (item) ->
          itemFound = _.find option.selection, (selectionElement) ->
            selectionElement.description is item.description
          item.isSelected = itemFound isnt undefined
          item.qty = itemFound?.qty or 0
      ################### intended for products that can have quantities per item #######################

      if option.type is "MULTIPLE"

        selectItemIfMatched = (item) ->
          itemFound = _.find option.selection, (selectionElement) ->
            selectionElement.description is item.description
          item.isSelected = itemFound isnt undefined

      option.items.map( selectItemIfMatched )

  $scope.product = product
  setCurrentOptionsSelectedForDisplay $scope.product
  $rootScope.$on 'PRODUCT_SELECTED_TO_BE_ADDED_TO_CART', () ->
    $state.go 'app.cart'