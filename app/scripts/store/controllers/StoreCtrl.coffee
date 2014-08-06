angular.module("Muzza.store").controller "StoresCtrl", ($scope, $state, StoreService, Contact, $stateParams) ->

  user = Contact.retrieveConnectionInfo()
  deliveryOption = $scope.deliveryOption = $stateParams.deliveryOption

  StoreService.listStores().then (branches) ->
    $scope.stores = []
    openedBranches = _.filter(branches, (store)-> store.hoursInfo.isOpen)
    if deliveryOption is 'pickup' then $scope.stores = openedBranches
    if deliveryOption is 'delivery' and user?.address
      userAddress = user.address
      angular.forEach openedBranches, (store)->
        store.isAvailableForUser(userAddress).then (isWithInRadio)->
          if isWithInRadio then $scope.stores.push store

  $scope.continue = (store)->
    StoreService.chooseStore(store).then ()->
      $state.go 'app.menu'



