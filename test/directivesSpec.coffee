describe "directives", ->

  beforeEach ->
    module 'ionic'
    module 'Muzza.directives'
    module 'Muzza.empanadas'
    module 'Muzza.pizzas'
    module 'Muzza.templates'

    module ($provide) ->
      $provide.value "ShoppingCartService",
        add: ()->
          return null
        getCart: ()->
          return null
        getTotalPrice: () ->
          return null
        get: ()->
          return null
      return null
    module ($provide) ->
      $provide.value "$state",
          go: () ->
            return null
      return null


  describe "CancelSelection", ->

    isolatedScope = $scope = element = undefined

    beforeEach ->
      inject ($compile, $rootScope) ->
        $scope = $rootScope
        element = angular.element('<cancel-selection></cancel-selection>')
        $compile(element)($rootScope)
        $scope.$digest()
        isolatedScope = element.scope()


    it 'should hide all modals included on current scope', ->

      isolatedScope.steps = ['order', 'size']
      isolatedScope.order =
        hide: -> null
      isolatedScope.size =
        hide: -> null
      hideOrder = spyOn(isolatedScope.order, 'hide')
      hideSize = spyOn(isolatedScope.size, 'hide')

      isolatedScope.cancel()

      expect(hideOrder).toHaveBeenCalled()
      expect(hideOrder.calls.count()).toBe 1
      expect(hideSize).toHaveBeenCalled()
      expect(hideSize.calls.count()).toBe 1


  describe "Checkout Button", ->

    describe "init", ->

      isolatedScope = ShoppingCartService = element = undefined

      beforeEach ->
        inject ($compile, $rootScope, _ShoppingCartService_) ->
          ShoppingCartService = _ShoppingCartService_
          $scope = $rootScope
          element = angular.element('<checkout-button></checkout-button>')
          spyOn(ShoppingCartService, 'getCart').and.returnValue  [{id:1, desc:'Muzza'},{id:2, desc:'Fugazzeta'}]
          $compile(element)($rootScope)
          $scope.$digest()
          isolatedScope = element.isolateScope()

      it "should have a cart element defined in the scope", ->
        expect(isolatedScope.cart).toBeDefined

      it "should have steps defined in the scope", ->
        expect(isolatedScope.checkoutSteps).toEqual ['contact', 'delivery']

      it "should load the templates for all the steps", ->
        isolatedScope.steps = ['contact', 'delivery']
        expect(isolatedScope.contact).toBeDefined()
        expect(isolatedScope.delivery).toBeDefined()

      it "should have a checkout function defined in the scope", ->
        expect(isolatedScope.checkout).toBeDefined()

      it "should have a click function bind", ->
        onClickEvent = element.find('button')[0].attributes['data-ng-click'].nodeValue

        expect(onClickEvent).toContain "checkout()"


    describe "car NOT empty", ->

      $scope = element = ShoppingCartService = undefined

      it "should show button", ->
        inject ($compile, $rootScope, _ShoppingCartService_) ->
          ShoppingCartService = _ShoppingCartService_
          $scope = $rootScope
          element = angular.element('<checkout-button></checkout-button>')
          spyOn(ShoppingCartService, 'getCart').and.returnValue  [{id:1, desc:'Muzza'},{id:2, desc:'Fugazzeta'}]
          $compile(element)($rootScope)
          $scope.$digest()

          expect(element.find('button')).toBeDefined()
          expect(element.find('button').html()).toMatch(/Pedido/)

    describe "car empty", ->

      $scope = element = ShoppingCartService = undefined

      it "should NOT show button", ->
        inject ($compile, $rootScope, _ShoppingCartService_) ->
          ShoppingCartService = _ShoppingCartService_
          $scope = $rootScope
          element = angular.element('<checkout-button></checkout-button>')
          spyOn(ShoppingCartService, 'getCart').and.returnValue []
          $compile(element)($rootScope)
          $scope.$digest()

          expect(element.find('button')).toBeUndefined


    describe "when user clicks checkout button", ->

      $scope = element = ShoppingCartService = isolatedScope = undefined

      beforeEach ->
        inject ($compile, $rootScope, _ShoppingCartService_) ->
          ShoppingCartService = _ShoppingCartService_
          $scope = $rootScope
          element = angular.element('<checkout-button></checkout-button>')
          spyOn(ShoppingCartService, 'getCart').and.returnValue [{id:1, desc:'Muzza'},{id:2, desc:'Fugazzeta'}]
          $compile(element)($rootScope)
          $scope.$digest()
          isolatedScope = element.isolateScope()

      it "should show all modals for available steps", ->

        isolatedScope.steps = ['contact', 'delivery']
        showDeliveryMethod = spyOn(isolatedScope.delivery, 'show')
        showContactForm = spyOn(isolatedScope.contact, 'show')

        element.find('button')[0].click()

        expect(showDeliveryMethod).toHaveBeenCalled()
        expect(showDeliveryMethod.calls.count()).toBe 1
        expect(showContactForm).toHaveBeenCalled()
        expect(showContactForm.calls.count()).toBe 1

    #      TODO ADD TEST TO FILL IN DATA IN FIRST MODAL AND GET TO THE SECOND ONE