angular.module('Muzza.product').directive 'productOptions', ($rootScope) ->
  restrict: 'E'
  scope: {
    productSelected: '=ngModel'
  }
  require: 'ngModel'
  templateUrl: '../app/scripts/product/templates/product-options.html'



  link: ($scope, ele, attrs, ctrl) ->

#    TODO: nobody in the html is calling this method. no need to attach it to the $scope.
    $scope.isSelectionValid = () ->
      isValid = true
      _.each $scope.productSelected.options, (option) ->

        option.selectionError = undefined

        if option.config.min is 1 and option.config.max is 1

          if option.selection is undefined or option.selection.length is 0
            isValid = false
            option.selectionError = "OPTION_ERROR_NO_SELECTION"


        else

          if option.selection is undefined
            if option.config.min > 0
              isValid = false
              option.selectionError  = "OPTION_ERROR_NO_SELECTION"

          else if option.selection.length > option.config.max
            isValid = false
            option.selectionError = "OPTION_ERROR_MAX"

          else if option.selection.length < option.config.min
            isValid = false
            option.selectionError  = "OPTION_ERROR_MIN"

      console.log "isSelectionValid: " + isValid
      isValid



    $scope.selectOption = (option, item) ->
#      TODO: is this is the initial state it should go all the way up when the directive is instantiated
      if option.selection is undefined
        option.selection = []

      if option.config.min is 1 and option.config.max is 1
        if option.selection.length > 0
          option.selection.pop()

        option.selection.push item

      else
        result = _.find option.selection, (elem) ->
          elem.description is item.description

        if result is undefined
          option.selection.push item
        else
          _.remove option.selection, (elem) ->
            elem.description is item.description

      calculateTotalPrice()
      null



    $scope.addProductSelectionToCart = (product) ->
      $rootScope.$broadcast 'PRODUCT_SELECTED_TO_BE_ADDED_TO_CART', product if $scope.isSelectionValid()


    calculateTotalPrice = () ->

      totalPrice = $scope.productSelected.price.base

      _.forEach $scope.productSelected.options, (option) ->

        _.forEach option.selection, (selection) ->

          totalPrice += selection.price

      $scope.productSelected.totalPrice = totalPrice