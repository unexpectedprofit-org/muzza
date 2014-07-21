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
        emptySelection = option.selection is undefined or option.selection.length is 0

        if emptySelection and option.config.min > 0 and option.type isnt "MULTIPLE_QTY"
          isValid = false
          option.selectionError = "OPTION_ERROR_NO_SELECTION"


        ################### intended for products that can have quantities per item #######################
        ################### multipleQty: current example: PROMO
        if option.type is "MULTIPLE_QTY"
          totalQty = 0
          _.each option.items, (item) ->
            totalQty += item.qty

          if totalQty isnt option.config.min and option.config.max isnt -1
            isValid = false
            option.selectionError  = "OPTION_ERROR_MIN_MAX"
          else if totalQty < option.config.min
            isValid = false
            option.selectionError  = "OPTION_ERROR_MIN"


        ################### intended for products that can have quantities per item #######################


        if !emptySelection and option.type is "MULTIPLE"

          if option.selection.length > option.config.max
            isValid = false
            option.selectionError = "OPTION_ERROR_MAX"

          if option.selection.length < option.config.min
            isValid = false
            option.selectionError  = "OPTION_ERROR_MIN"

      isValid



    $scope.selectOption = (option, item) ->

      if option.selection is undefined then option.selection = []

      addOrReplace =  (item)->
        if option.selection.length > 0 then option.selection.pop()
        add(item)

      add = (item)->
        option.selection.push item

      remove = (item)->
        _.remove option.selection, (elem) ->
          #TODO: change this for a generated code
          elem.description is item.description

      if option.type is "SINGLE" then addOrReplace(item)

      if option.type is "MULTIPLE"

        isOptionPresentAmongSelected = _.contains(option.selection, item)

        if !isOptionPresentAmongSelected then add(item)
        if isOptionPresentAmongSelected then remove(item)

    $scope.addProductSelectionToCart = (product) ->
      $rootScope.$broadcast 'PRODUCT_SELECTED_TO_BE_ADDED_TO_CART', product if $scope.isSelectionValid()