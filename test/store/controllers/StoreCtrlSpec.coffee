describe "Store Controller", ->

  beforeEach ->
    module 'Muzza.stores'
    module ($provide) ->
      $provide.value 'StoreService',
        listStores: () -> {then: (callback) -> callback({some: "thing"})}
      $provide.value '$state',
        go: ()-> null
      $provide.value 'OrderService',
        chooseStore: ()-> null

      null

  scope = StoreService = OrderService = undefined

  beforeEach ->
    inject ($controller, $rootScope, _StoreService_, _OrderService_) ->
      scope = $rootScope.$new()
      StoreService = _StoreService_
      OrderService = _OrderService_
      spyOn(StoreService, 'listStores').and.callThrough()
      $controller "StoresCtrl",
        $scope: scope

  it "should call the store service to retrieve the store list", ->
    expect(StoreService.listStores).toHaveBeenCalled()

  describe 'when user selects a store', ->

    it 'should save the selected store into the order', ->
      spyOn(OrderService, 'chooseStore').and.callFake ()-> {then: (callback)-> callback()}
      store = {id: 1}
      scope.continue(store)
      expect(OrderService.chooseStore).toHaveBeenCalledWith(store)

    it 'should redirect to the menu', ->
      inject ($state)->
        spyOn(OrderService, 'chooseStore').and.callFake ()-> {then: (callback)-> callback()}
        spyOn($state, 'go')
        scope.continue()
        expect($state.go).toHaveBeenCalledWith('app.menu')