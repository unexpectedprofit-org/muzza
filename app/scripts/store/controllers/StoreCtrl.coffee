angular.module("Muzza.store").controller "StoresCtrl", ($scope, $state, StoreService, Contact, $stateParams) ->


  deliveryOption = $scope.deliveryOption = $stateParams.deliveryOption

  StoreService.listStores().then (branches) ->
    $scope.stores = []

    Contact.retrieveContactInfo().then (userInfo)->

      openedBranches = _.filter(branches, (store)-> store.hoursInfo.isOpen)

      if deliveryOption is 'pickup' then $scope.stores = openedBranches

      if deliveryOption is 'delivery'

        if !userInfo.address.hasOwnProperty('street')
          throw Error "User address not present"

        userAddress = userInfo.address
        angular.forEach openedBranches, (store)->
          store.isAvailableForUser(userAddress).then (isWithInRadio)->
            if isWithInRadio then $scope.stores.push store


  $scope.continue = (store)->
    StoreService.chooseStore(store).then ()->
      $state.go 'app.menu'



