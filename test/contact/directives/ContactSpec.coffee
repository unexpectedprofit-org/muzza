describe 'Contact', ->

  beforeEach ->
    module 'Muzza.contact'
    module 'Muzza.templates'

    module ($provide) ->
      $provide.value '$state',
        go: ()-> null
      $provide.value '$stateParams',
        {}
      $provide.value 'OrderService',
        chooseDelivery: ()-> null
        addContactInfo: ()-> {then: (callback)-> callback()}
        retrieveConnectionInfo: ()-> {name:'San'}
      return null

  OrderService = isolatedScope = $state = _stateParams_ = $q = undefined

  beforeEach ->
    inject ($compile, $rootScope, _OrderService_, _$state_, _$stateParams_, _$q_) ->
      $q = _$q_
      OrderService = _OrderService_
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
      spyOn(OrderService, 'addContactInfo').and.callThrough()
      isolatedScope.contact =
        name: 'Santiago'
        phone: '123455889'
        email: 'test@test.com'
      isolatedScope.continue()
      expect(OrderService.addContactInfo).toHaveBeenCalledWith( { name : 'Santiago', phone : '123455889', email : 'test@test.com' }  )

    it 'should redirect to the contact route', ->
      spyOn($state, 'go')
      isolatedScope.continue()
      expect($state.go).toHaveBeenCalledWith('app.menu')

    it 'should load an error if the Order service rejected the promise for some reason', ->
      spyOn(OrderService, 'addContactInfo').and.callFake ()-> {then: (callback, fallback)-> fallback('Error 101')}
      isolatedScope.contact = {}
      isolatedScope.continue()
      expect(isolatedScope.error).toBe 'Error 101'


  describe 'when user has previosuly filled the form', ->

    it 'should display the contact information', ->
      spyOn(OrderService, 'retrieveConnectionInfo')
      expect(isolatedScope.contact).toEqual {name:'San'}



