describe "Store Controller", ->

  beforeEach ->
    module 'Muzza.store'
    module ($provide) ->
      $provide.value 'StoreService',
        listStores: () -> {then: (callback) -> callback( [{some: "thing", hoursInfo:{isOpen: true}}] )}
        chooseStore: ()-> null
      $provide.value '$state',
        go: ()-> null
      $provide.value 'Contact',
        retrieveConnectionInfo: ()-> {}

      null

  scope = StoreService = undefined

  beforeEach ->
    inject ($controller, $rootScope, _StoreService_) ->
      scope = $rootScope.$new()
      StoreService = _StoreService_
      spyOn(StoreService, 'listStores').and.callThrough()
      spyOn(StoreService, 'chooseStore').and.callFake ()-> {then: (callback)-> callback()}
      $controller "StoresCtrl",
        $scope: scope
        $stateParams: {}

  it "should call the store service to retrieve the store list", ->
    expect(StoreService.listStores).toHaveBeenCalled()


  describe 'when user selects a store', ->

    it 'should save the selected store into the order', ->
      store = {id: 1}
      scope.continue(store)
      expect(StoreService.chooseStore).toHaveBeenCalledWith(store)

    it 'should redirect to the menu', ->
      inject ($state)->
        spyOn($state, 'go')
        scope.continue()
        expect($state.go).toHaveBeenCalledWith('app.menu')