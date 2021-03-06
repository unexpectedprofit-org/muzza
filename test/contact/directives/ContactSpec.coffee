describe 'Contact', ->

  beforeEach ->
    module 'Muzza.contact'
    module 'Muzza.templates'

    module ($provide) ->
      $provide.value '$state',
        go: ()-> null
      $provide.value '$stateParams',
        {}
      $provide.value 'Contact',
        chooseDelivery: ()-> null
        addContactInfo: ()-> {then: (callback)-> callback()}
        retrieveContactInfo: ()-> {then: (callback)-> callback({name:'San'})}
      return null

  Contact = isolatedScope = $state = _stateParams_ = $q = undefined

  beforeEach ->
    inject ($compile, $rootScope, _Contact_, _$state_, _$stateParams_, _$q_) ->
      $q = _$q_
      Contact = _Contact_
      $state = _$state_
      $stateParams = _$stateParams_
      $stateParams.method = 'pickup'
      $scope = $rootScope
      element = angular.element('<contact></contact>')
      $compile(element)($rootScope)
      $scope.$digest()
      isolatedScope = element.isolateScope()

  describe 'init', ->

    it 'should set the deliveryOption based on routeParams', ->
      expect(isolatedScope.deliveryOption).toBe 'pickup'

  describe 'when user fills in the form', ->

    it 'should delegate to Order Service', ->
      spyOn(Contact, 'addContactInfo').and.callThrough()
      isolatedScope.contact =
        name: 'Santiago'
        phone: '123455889'
        email: 'test@test.com'
      isolatedScope.continue()
      expect(Contact.addContactInfo).toHaveBeenCalledWith( { name : 'Santiago', phone : '123455889', email : 'test@test.com' }  )

    it 'should redirect to the menu if the user selected delivery option', ->
      isolatedScope.deliveryOption = 'delivery'
      spyOn($state, 'go')
      isolatedScope.continue()
      expect($state.go).toHaveBeenCalledWith('app.stores', { deliveryOption : 'delivery' })

    it 'should redirect to the store selection if the user selected pickup option', ->
      isolatedScope.deliveryOption = 'pickup'
      spyOn($state, 'go')
      isolatedScope.continue()
      expect($state.go).toHaveBeenCalledWith('app.stores', { deliveryOption : 'pickup' })

#    TODO: move to address store validation
    xit 'should load an error if the Order service rejected the promise for some reason', ->
      spyOn(Contact, 'addContactInfo').and.callFake ()-> {then: (callback, fallback)-> fallback('Error 101')}
      isolatedScope.contact = {}
      isolatedScope.continue()
      expect(isolatedScope.error).toBe 'Error 101'


  describe 'when user has previosuly filled the form', ->

    it 'should display the contact information', ->
      spyOn(Contact, 'retrieveContactInfo')
      expect(isolatedScope.contact).toEqual {name:'San'}



