#describe "Order", ->
#
#  beforeEach ->
#    module 'ionic'
#    module 'Muzza.pizzas'
#    module 'Muzza.templates'
#    module 'Muzza.order'
#    module 'Muzza.promo'
#
#  beforeEach ->
#    module ($provide) ->
#      $provide.value "ShoppingCartService",
#        add: ()->
#          return null
#        getCart: ()->
#          return null
#        getTotalPrice: () ->
#          return null
#        get: ()->
#          return null
#
#      $provide.value "$state",
#        go: () ->
#          return null
#
#      $provide.value "$stateParams",
#        {}
#
#      $provide.value 'PromoTypeQuantity',
#        validate: () ->
#          return null
#
#      null
#
#
#  isolatedScope = $scope = element = Pizza = pizza1 = pizza2 = pizza3 = undefined
#
#  describe "Checkout Button", ->
#
#    it 'should '
#
#    describe "init", ->
#
#      ShoppingCartService  = undefined
#
#      beforeEach ->
#        inject ($compile, $rootScope, _ShoppingCartService_, _PromoTypeQuantity_) ->
#          ShoppingCartService = _ShoppingCartService_
#          PromoTypeQuantity = _PromoTypeQuantity_
#          $scope = $rootScope
#          element = angular.element('<checkout-button></checkout-button>')
#          spyOn(ShoppingCartService, 'getCart').and.returnValue  [{id:1, desc:'Muzza'},{id:2, desc:'Fugazzeta'}]
#          $compile(element)($rootScope)
#          $scope.$digest()
#          isolatedScope = element.isolateScope()
#
#      it "should have a cart element defined in the scope", ->
#        expect(isolatedScope.cart).toBeDefined()
#
#      it "should have steps defined in the scope", ->
#        expect(isolatedScope.checkoutSteps).toEqual ['contact', 'deliveryOption', 'promos']
#
#      it "should have a checkout function defined in the scope", ->
#        expect(isolatedScope.checkout).toBeDefined()
#
#      it "should have a click function bind", ->
#        onClickEvent = element.find('button')[0].attributes['data-ng-click'].nodeValue
#
#        expect(onClickEvent).toContain "checkout()"
#
#    describe "car NOT empty", ->
#
#      ShoppingCartService = undefined
#
#      it "should show button", ->
#        inject ($compile, $rootScope, _ShoppingCartService_) ->
#          ShoppingCartService = _ShoppingCartService_
#          $scope = $rootScope
#          element = angular.element('<checkout-button></checkout-button>')
#          spyOn(ShoppingCartService, 'getCart').and.returnValue  [{id:1, desc:'Muzza'},{id:2, desc:'Fugazzeta'}]
#          $compile(element)($rootScope)
#          $scope.$digest()
#
#          expect(element.find('button')).toBeDefined()
#          expect(element.find('button').html()).toMatch(/Pedido/)
#
#    describe "car empty", ->
#
#      ShoppingCartService = undefined
#
#      it "should NOT show button", ->
#        inject ($compile, $rootScope, _ShoppingCartService_) ->
#          ShoppingCartService = _ShoppingCartService_
#          $scope = $rootScope
#          element = angular.element('<checkout-button></checkout-button>')
#          spyOn(ShoppingCartService, 'getCart').and.returnValue []
#          $compile(element)($rootScope)
#          $scope.$digest()
#
#          expect(element.find('button')).toEqual {}
#
#    describe "when user clicks checkout button", ->
#
#      ShoppingCartService = OrderDetails = undefined
#
#      beforeEach ->
#        inject ($compile, $rootScope, _ShoppingCartService_) ->
#          ShoppingCartService = _ShoppingCartService_
#          $scope = $rootScope
#          element = angular.element('<checkout-button></checkout-button>')
#          spyOn(ShoppingCartService, 'getCart').and.returnValue [{id:1, desc:'Muzza'},{id:2, desc:'Fugazzeta'}]
#          $compile(element)($rootScope)
#          $scope.$digest()
#          isolatedScope = element.isolateScope()
#
#      it "should have a order object defined in the scope", ->
#        isolatedScope.checkout()
#        expect(isolatedScope.order).toBeDefined()
#
#
#      it "should load the templates for all the steps", ->
#        isolatedScope.steps = ['contact', 'deliveryOption', 'promos']
#        isolatedScope.checkout()
#        isolatedScope.$apply()
#
#        expect(isolatedScope.contact).toBeDefined()
#        expect(isolatedScope.deliveryOption).toBeDefined()
#        expect(isolatedScope.promos).toBeDefined()
#
#
#      xit "should show all modals for available steps", ->
#        isolatedScope.checkout()
#        $scope.$apply()
#
#        showContactForm = spyOn(isolatedScope.contact, 'show')
#        showDeliveryMethod = spyOn(isolatedScope.deliveryOption, 'show')
#        showPromos = spyOn(isolatedScope.promos, 'show')
#
#        expect(showContactForm).toHaveBeenCalled()
#        expect(showContactForm).toHaveBeenCalled()