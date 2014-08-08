describe 'Review', ->

  beforeEach ->
    module 'Muzza.review'
    module 'Muzza.templates'
    module 'Muzza.directives'

    module ($provide) ->
      $provide.value 'OrderService',
        retrieveOrder: ()-> {id:1}
        submitOrder: ()-> null
      $provide.value '$state',
        go: ()-> {}
      return null

  OrderService = $state = isolatedScope = undefined

  beforeEach ->
    inject ($compile, $rootScope, _OrderService_, _$state_) ->
      OrderService = _OrderService_
      $state = _$state_
      spyOn(OrderService, 'retrieveOrder').and.callThrough()
      spyOn(OrderService, 'submitOrder').and.callFake ()-> {then: (callback, fallback)-> callback()}
      spyOn($state, 'go')
      $scope = $rootScope
      element = angular.element('<review></review>')
      $compile(element)($rootScope)
      $scope.$digest()
      isolatedScope = element.isolateScope()

  it 'should retrieve the order', ->
    expect(OrderService.retrieveOrder).toHaveBeenCalled()
    expect(isolatedScope.order.id).toBe 1

  describe 'when the user submits the order', ->

    it 'should delegate to OrderService', ->
      isolatedScope.submitOrder()
      expect(OrderService.submitOrder).toHaveBeenCalled()

    it 'should redirect to order confirmation view', ->
      isolatedScope.submitOrder()
      expect($state.go).toHaveBeenCalledWith 'app.orderplace'

  it 'should redirect to the menu if user wants to edit the order items ' , ->
    isolatedScope.editOrder()
    expect($state.go).toHaveBeenCalledWith( 'app.menu' )


