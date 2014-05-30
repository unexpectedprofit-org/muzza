describe 'Delivery', ->

  beforeEach ->
    module 'Muzza.delivery'
    module 'Muzza.templates'

    module ($provide) ->
      $provide.value '$state',
        go: ()-> null
      $provide.value 'OrderService',
        chooseDelivery: ()-> null
      return null

  OrderService = isolatedScope = $state = undefined

  beforeEach ->
    inject ($compile, $rootScope, _OrderService_, _$state_) ->
      OrderService = _OrderService_
      $state = _$state_
      $scope = $rootScope
      element = angular.element('<delivery></delivery>')
      $compile(element)($rootScope)
      $scope.$digest()
      isolatedScope = element.isolateScope()

  describe 'when user chooses a delivery option', ->

    it 'should delegate to Order Service', ->
      spyOn(OrderService, 'chooseDelivery')
      isolatedScope.chooseDelivery('pickup')
      expect(OrderService.chooseDelivery).toHaveBeenCalledWith('pickup')

    it 'should redirect to the contact route', ->
      spyOn($state, 'go')
      isolatedScope.chooseDelivery('pickup')
      expect($state.go).toHaveBeenCalledWith('app.order-contact', {method: 'pickup'})



