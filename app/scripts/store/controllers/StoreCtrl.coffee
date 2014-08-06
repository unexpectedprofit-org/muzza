angular.module("Muzza.store").controller "StoresCtrl", ($scope, $state, StoreService, Contact, $stateParams) ->


  deliveryOption = $scope.deliveryOption = $stateParams.deliveryOption

  StoreService.listStores().then (branches) ->
    $scope.stores = []
    Contact.retrieveConnectionInfo().then (userInfo)->
      if !userInfo.address.hasOwnProperty('latLong')
        throw Error "User address not present"
      openedBranches = _.filter(branches, (store)-> store.hoursInfo.isOpen)
      if deliveryOption is 'pickup' then $scope.stores = openedBranches
      if deliveryOption is 'delivery' and userInfo?.address
        userAddress = userInfo.address
        angular.forEach openedBranches, (store)->
          store.isAvailableForUser(userAddress).then (isWithInRadio)->
            if isWithInRadio then $scope.stores.push store


  $scope.continue = (store)->
    StoreService.chooseStore(store).then ()->
      $state.go 'app.menu'



