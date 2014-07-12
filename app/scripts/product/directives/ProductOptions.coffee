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

        option.selectionValid =
          status: true

        if option.config.min is 1 and option.config.max is 1

          if option.selection is undefined or option.selection.length is 0
            isValid = false
            option.selectionValid =
              status: false
              error: "OPTION_ERROR_NO_SELECTION"


        else

          if option.selection is undefined
            if option.config.min > 0
              isValid = false
              option.selectionValid =
                status: false
                error: "OPTION_ERROR_NO_SELECTION"

          else if option.selection.length > option.config.max
            isValid = false
            option.selectionValid =
              status: false
              error: "OPTION_ERROR_MAX"
              params:
                max: option.config.max

          else if option.selection.length < option.config.min
            isValid = false
            option.selectionValid =
              status: false
              error: "OPTION_ERROR_MIN"
              params:
                min: option.config.min

      console.log "isSelectionValid: " + isValid
      isValid

    $scope.selectOptionAndRecalculatePrice = (option, item) ->
      if option.selection is undefined
        option.selection = []

      if option.config.min is 1 and option.config.max is 1
        if option.selection.length > 0
          itemRemoved = option.selection.pop()
          $scope.productSelected.totalPrice -= itemRemoved.price

        option.selection.push item
        $scope.productSelected.totalPrice += item.price

      else
        result = _.find option.selection, (elem) ->
          elem.description is item.description

        if result is undefined
          option.selection.push item
          $scope.productSelected.totalPrice += item.price
        else
          _.remove option.selection, (elem) ->
            elem.description is item.description

          $scope.productSelected.totalPrice -= item.price

    $scope.addProductSelectionToCart = (product) ->
      if !$scope.isSelectionValid()
        return

      $rootScope.$broadcast 'PRODUCT_SELECTED_TO_BE_ADDED_TO_CART', product