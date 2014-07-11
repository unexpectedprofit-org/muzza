angular.module('Muzza.product').directive 'productOptions', () ->
  restrict: 'E'
  scope: {
    productSelected: '=ngModel'

  }
  require: 'ngModel'
  templateUrl: '../app/scripts/product/templates/product-options.html'



  link: ($scope, ele, attrs, ctrl) ->

    console.log "Producto seleccionado: " + $scope.productSelected.description

    $scope.productTotalPrice = $scope.productSelected.price.base


    ##############################################################
    ## functions
    ##############################################################
    $scope.isSelectionValid = () ->
      isValid = true
      _.each $scope.productSelected.options, (option) ->

        if option.config.min is 1 and option.config.max is 1

          if option.selection is undefined or option.selection.length is 0
            isValid = false
            option.validationError = "Debe seleccionar una opcion!"
          else
            option.validationError = undefined


        else

          if option.selection is undefined
            if option.config.min > 0
              isValid = false
              option.validationError = "Debe seleccionar una opcion!"
            else
              option.validationError = undefined


          else if option.selection.length <= option.config.max and option.selection.length >= option.config.min
            option.validationError = undefined
          else if !option.selection.length <= option.config.max and !option.selection.length >= option.config.min
            isValid = false
            option.validationError = "Debe seleccionar entre " + option.config.min + " y " + option.config.max
          else if !option.selection.length <= option.config.max
            isValid = false
            option.validationError = "Debe seleccionar menos de " + option.config.max
          else
            isValid = false
            option.validationError = "Debe seleccionar al menos " + option.config.min

      console.log "isSelectionValid: " + isValid
      isValid


    $scope.updateOptionSelection = (option, item) ->
      console.log "function updateOptionSelection!!!"
      if option.selection is undefined
        option.selection = []


      if option.config.min is 1 and option.config.max is 1

        if option.selection.length > 0
          itemRemoved = option.selection.pop()
          $scope.productTotalPrice -= itemRemoved.price

        option.selection.push item
        $scope.productTotalPrice += item.price

      else
        result = _.find option.selection, (elem) ->
          elem.description is item.description

        if result is undefined
    #        console.log "elemento no esta..... agregando"
          option.selection.push item
          $scope.productTotalPrice += item.price
        else
    #        console.log "elemento existe..... removiendo"
          _.remove option.selection, (elem) ->
            elem.description is item.description
          $scope.productTotalPrice -= item.price