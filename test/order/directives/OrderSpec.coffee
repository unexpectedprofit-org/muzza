describe "Order", ->

  beforeEach ->
    module 'ionic'
    module 'Muzza.pizzas'
    module 'Muzza.templates'
    module 'Muzza.order'

  beforeEach ->
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

      $provide.value "$state",
        go: () ->
          return null

      $provide.value "$stateParams",
        {}
      return null


  isolatedScope = $scope = element = Pizza = pizza1 = pizza2 = pizza3 = undefined

  beforeEach ->
    inject (_Pizza_,$compile, $rootScope)->

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
        expect(isolatedScope.cart).toBeDefined()

      it "should have steps defined in the scope", ->
        expect(isolatedScope.checkoutSteps).toEqual ['contact', 'deliveryOption']

      it "should load the templates for all the steps", ->
        isolatedScope.steps = ['contact', 'deliveryOption']
        expect(isolatedScope.contact).toBeDefined()
        expect(isolatedScope.deliveryOption).toBeDefined()

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

          expect(element.find('button')).toEqual {}

    describe "when user clicks checkout button", ->

      $scope = element = ShoppingCartService = OrderDetails = isolatedScope = undefined

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

        isolatedScope.steps = ['contact', 'deliveryOption']
        showDeliveryMethod = spyOn(isolatedScope.deliveryOption, 'show')
        showContactForm = spyOn(isolatedScope.contact, 'show')

        element.find('button')[0].click()

        expect(showDeliveryMethod).toHaveBeenCalled()
        expect(showDeliveryMethod.calls.count()).toBe 1
        expect(showContactForm).toHaveBeenCalled()
        expect(showContactForm.calls.count()).toBe 1

      it "should have a order object defined in the scope", ->
        element.find('button')[0].click()

        expect(isolatedScope.order).toBeDefined()
