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
        retrieveConnectionInfo: ()-> {address: {}}

      null

  scope = StoreService = createController  = $controller = Contact = undefined

  beforeEach ->
    inject ($controller, $rootScope, _StoreService_, _Contact_) ->
      scope = $rootScope.$new()
      StoreService = _StoreService_
      Contact = _Contact_
      spyOn(StoreService, 'chooseStore').and.callFake ()-> {then: (callback)-> callback()}
      createController = (params)->
        $controller "StoresCtrl",
          $scope: scope
          $stateParams: params or {}

  it "should call the store service to retrieve the store list", ->
    spyOn(StoreService, 'listStores').and.callThrough()
    user = {address: { latLong: 1}}
    spyOn(Contact, 'retrieveConnectionInfo').and.callFake ()-> {then: (callback)-> callback(user)}

    createController()
    expect(StoreService.listStores).toHaveBeenCalled()

  it 'should throw an error if the user address is not present', ->
    stores  = [
      {some: "thing", hoursInfo:{isOpen: true}, isAvailableForUser: ()-> return {then: (callback)-> callback(true)} },
      {some: "thing", hoursInfo:{isOpen: false}, isAvailableForUser: ()-> return {then: (callback)-> callback(true)} }
    ]
    user = {address: {}}
    spyOn(StoreService, 'listStores').and.callFake ()-> {then: (callback)-> callback(stores)}
    spyOn(Contact, 'retrieveConnectionInfo').and.callFake ()-> {then: (callback)-> callback(user)}
    missingAddress = ()->
      createController(deliveryOption:'delivery')
    expect(missingAddress).toThrow(Error 'User address not present')
    expect(scope.stores.length).toBe 0

  describe 'delivery', ->

    it 'should get only those stores opened and within the delivery range', ->
      stores  = [
        {some: "thing", hoursInfo:{isOpen: true}, isAvailableForUser: ()-> return {then: (callback)-> callback(true)} },
        {some: "thing", hoursInfo:{isOpen: false}, isAvailableForUser: ()-> return {then: (callback)-> callback(false)} }
      ]
      user = {address: {latLong: 111}}
      spyOn(StoreService, 'listStores').and.callFake ()-> {then: (callback)-> callback(stores)}
      spyOn(Contact, 'retrieveConnectionInfo').and.callFake ()-> {then: (callback)-> callback(user)}
      createController(deliveryOption:'delivery')
      expect(scope.stores.length).toBe 1

    it 'should get only those stores opened and within the delivery range', ->
      stores  = [
        {some: "thing", hoursInfo:{isOpen: true}, isAvailableForUser: ()-> return {then: (callback)-> callback(false)} },
        {some: "thing", hoursInfo:{isOpen: true}, isAvailableForUser: ()-> return {then: (callback)-> callback(false)} }
      ]
      user = {address: {latLong: 111}}
      spyOn(StoreService, 'listStores').and.callFake ()-> {then: (callback)-> callback(stores)}
      spyOn(Contact, 'retrieveConnectionInfo').and.callFake ()-> {then: (callback)-> callback(user)}
      createController(deliveryOption:'delivery')
      expect(scope.stores.length).toBe 0

  describe 'pickup', ->

    it 'should retrieve only those opened stores', ->
      stores  = [
        {some: "thing", hoursInfo:{isOpen: true}},
        {some: "thing", hoursInfo:{isOpen: false}}
      ]
      user = {address: { latLong: 1}}
      spyOn(Contact, 'retrieveConnectionInfo').and.callFake ()-> {then: (callback)-> callback(user)}
      spyOn(StoreService, 'listStores').and.callFake ()-> {then: (callback)-> callback(stores)}

      createController(deliveryOption:'pickup')
      expect(scope.stores.length).toBe 1

    it 'should retrieve opened stores when all are opened', ->
      stores  = [
        {some: "thing", hoursInfo:{isOpen: true}},
        {some: "thing", hoursInfo:{isOpen: true}}
      ]
      user = {address: { latLong: 1}}
      spyOn(Contact, 'retrieveConnectionInfo').and.callFake ()-> {then: (callback)-> callback(user)}

      spyOn(StoreService, 'listStores').and.callFake ()-> {then: (callback)-> callback(stores)}
      createController(deliveryOption:'pickup')
      expect(scope.stores.length).toBe 2

    it 'should retrieve no stores when all are closed', ->
      stores  = [
        {some: "thing", hoursInfo:{isOpen: false}},
        {some: "thing", hoursInfo:{isOpen: false}}
      ]
      user = {address: { latLong: 1}}
      spyOn(Contact, 'retrieveConnectionInfo').and.callFake ()-> {then: (callback)-> callback(user)}

      spyOn(StoreService, 'listStores').and.callFake ()-> {then: (callback)-> callback(stores)}
      createController(deliveryOption:'pickup')
      expect(scope.stores.length).toBe 0



  describe 'when user selects a store', ->

    it 'should save the selected store into the order', ->
      user = {address: { latLong: 1}}
      spyOn(Contact, 'retrieveConnectionInfo').and.callFake ()-> {then: (callback)-> callback(user)}

      createController()
      store = {id: 1}
      scope.continue(store)
      expect(StoreService.chooseStore).toHaveBeenCalledWith(store)

    it 'should redirect to the menu', ->
      inject ($state)->
        spyOn($state, 'go')
        user = {address: { latLong: 1}}
        spyOn(Contact, 'retrieveConnectionInfo').and.callFake ()-> {then: (callback)-> callback(user)}

        createController()
        scope.continue()
        expect($state.go).toHaveBeenCalledWith('app.menu')