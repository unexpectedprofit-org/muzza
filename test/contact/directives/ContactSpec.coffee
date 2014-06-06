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
        addContactInfo: ()-> null
        retrieveConnectionInfo: ()-> {name:'San'}
      return null

  OrderService = isolatedScope = $state = _stateParams_ = undefined

  beforeEach ->
    inject ($compile, $rootScope, _OrderService_, _$state_, _$stateParams_) ->
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
      spyOn(OrderService, 'addContactInfo')
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

  describe 'when user has previosuly filled the form', ->

    it 'should display the contact information', ->
      spyOn(OrderService, 'retrieveConnectionInfo')
      expect(isolatedScope.contact).toEqual {name:'San'}



