angular.module("Muzza.controllers", ['Muzza.services'])

angular.module("Muzza.controllers").controller "MenuCtrl", ($scope, $stateParams, ProductService, $rootScope, ShoppingCartService, $state, $ionicModal) ->

  $scope.updateOptionSelection = (option, item) ->

    if option.selection is undefined
      option.selection = []


    if option.config.component is 'ONE_OPTION'

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

#    console.log "colection: " + JSON.stringify option.selection


  $scope.isSelectionValid = () ->
    isValid = true
    _.each $scope.product.options, (option) ->

      if option.config.component is 'ONE_OPTION'

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




  $scope.validate = (option) ->
    console.log JSON.stringify option


  $scope.chooseProduct = (product) ->

    options = $ionicModal.fromTemplateUrl '../app/scripts/product/templates/product-options.html',
      scope: $scope,
      animation: 'slide-in-up'

    options.then (view) ->

      console.log "Choosing product: " + JSON.stringify product

      $scope.product = angular.copy product

      $scope.productOptions = view

      $scope.productTotalPrice = $scope.product.price.base

      $scope.productOptions.show()


  $scope.viewCart = () ->
    $state.go 'app.cart'

  $rootScope.storeId = $stateParams.storeID

  $scope.cartTotalPrice = ShoppingCartService.getTotalPrice()
  $rootScope.$on 'CART:PRICE_UPDATED', (event, newValue) ->
    $scope.cartTotalPrice = newValue

  $scope.menu = ProductService.getMenu($rootScope.storeId, $stateParams.category)


