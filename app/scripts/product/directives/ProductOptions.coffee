angular.module('Muzza.product').directive 'productOptions', ($rootScope) ->
  restrict: 'E'
  scope: {
    productSelected: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: '../app/scripts/product/templates/product-options.html'

  link: ($scope, ele, attrs, ctrl) ->

    $scope.isSelectionValid = () ->
      isValid = true

      _.each $scope.productSelected.options, (option) ->

        option.selectionError = undefined

        selectMultipleOptions = !(option.config.min is 1 and option.config.max is 1) and !option.config.multipleQty
        selectMultipleOptionsMultipleQty = !(option.config.min is 1 and option.config.max is 1) and option.config.multipleQty
        emptySelection = option.selection is undefined or option.selection.length is 0

        if emptySelection and option.config.min > 0 and !selectMultipleOptionsMultipleQty
          isValid = false
          option.selectionError = "OPTION_ERROR_NO_SELECTION"


        ################### intended for products that can have quantities per item #######################
        ################### multipleQty: current example: PROMO
        if selectMultipleOptionsMultipleQty
          totalQty = 0
          _.each option.items, (item) ->
            totalQty += item.qty

          if totalQty isnt option.config.min
            isValid = false
            option.selectionError  = "OPTION_ERROR_MIN_MAX"

        ################### intended for products that can have quantities per item #######################


        if !emptySelection and selectMultipleOptions

          if option.selection.length > option.config.max
            isValid = false
            option.selectionError = "OPTION_ERROR_MAX"

          if option.selection.length < option.config.min
            isValid = false
            option.selectionError  = "OPTION_ERROR_MIN"

      isValid



    $scope.selectOption = (option, item) ->

      if option.selection is undefined then option.selection = []

      selectOnlyOneOption = option.config.min is 1 and option.config.max is 1
      selectMultipleOptions = !selectOnlyOneOption and !option.config.multipleQty

      addOrReplace =  (item)->
        if option.selection.length > 0 then option.selection.pop()
        add(item)

      add = (item)->
        option.selection.push item

      remove = (item)->
        _.remove option.selection, (elem) ->
          #TODO: change this for a generated code
          elem.description is item.description

      if selectOnlyOneOption then addOrReplace(item)

      if selectMultipleOptions

        isOptionPresentAmongSelected = _.contains(option.selection, item)

        if !isOptionPresentAmongSelected then add(item)
        if isOptionPresentAmongSelected then remove(item)

    $scope.addProductSelectionToCart = (product) ->
      $rootScope.$broadcast 'PRODUCT_SELECTED_TO_BE_ADDED_TO_CART', product if $scope.isSelectionValid()