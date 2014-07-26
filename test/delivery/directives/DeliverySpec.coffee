describe 'Delivery', ->

  beforeEach ->
    module 'Muzza.delivery'
    module 'Muzza.templates'

    module ($provide) ->
      $provide.value '$state',
        go: ()-> null
      $provide.value 'Delivery',
        chooseDelivery: ()-> null
        retrieveDelivery: ()-> 'pickup'
      return null

  Delivery = isolatedScope = $state = undefined

  beforeEach ->
    inject ($compile, $rootScope, _Delivery_, _$state_) ->
      Delivery = _Delivery_
      $state = _$state_
      $scope = $rootScope
      element = angular.element('<delivery></delivery>')
      $compile(element)($rootScope)
      $scope.$digest()
      isolatedScope = element.isolateScope()

  describe 'when user chooses a delivery option', ->

    it 'should delegate to Order Service', ->
      spyOn(Delivery, 'chooseDelivery')
      isolatedScope.chooseDelivery('pickup')
      expect(Delivery.chooseDelivery).toHaveBeenCalledWith('pickup')

    it 'should redirect to the contact route', ->
      spyOn($state, 'go')
      isolatedScope.chooseDelivery('pickup')
      expect($state.go).toHaveBeenCalledWith('app.order-contact', {method: 'pickup'})

  describe 'when user has previously selected an option and comes back', ->

    it 'should retrieve the selected option', ->
      spyOn(Delivery, 'retrieveDelivery')
      expect(isolatedScope.option).toBe 'pickup'




