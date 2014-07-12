describe "directives", ->

  beforeEach ->
    module 'ionic'
    module 'Muzza.directives'
    module 'Muzza.pizzas'
    module 'Muzza.product'
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

    directiveScope = $scope = element = undefined

    beforeEach ->
      inject ($compile, $rootScope) ->
        $scope = $rootScope


    it 'should hide all modals included on current scope - case 1', ->
      inject ($rootScope, $compile) ->

        $scope.steps = ['step1', 'step2']
        $scope.step1 =
          hide: () -> null
        $scope.step2 =
          hide: () -> null

        element = angular.element('<cancel-selection></cancel-selection>')
        $compile(element)($rootScope)
        $scope.$digest()
        directiveScope = element.scope()


        hideStep1 = spyOn(directiveScope.step1, 'hide')
        hideStep2 = spyOn(directiveScope.step2, 'hide')

        directiveScope.cancel()

        expect(hideStep1).toHaveBeenCalled()
        expect(hideStep2).toHaveBeenCalled()

    it 'should hide all modals included on current scope - case 2', ->
      inject ($rootScope, $compile) ->

        $scope.steps = ['step1', 'step2']
        $scope.step1 =
          hide: () -> null

        element = angular.element('<cancel-selection></cancel-selection>')
        $compile(element)($rootScope)
        $scope.$digest()
        directiveScope = element.scope()


        hideStep1 = spyOn(directiveScope.step1, 'hide')

        directiveScope.cancel()

        expect(hideStep1).toHaveBeenCalled()
        expect(directiveScope.step2).toBeUndefined()

    describe "reset model", ->

      it "should call model to reset", ->
        inject ($rootScope, $compile,$injector) ->
          Product = $injector.get 'Product'

          $scope.steps = ['step1']
          $scope.step1 =
            hide: () -> null

          $scope.item = new Product {}

          element = angular.element('<cancel-selection data-reset-model="item"></cancel-selection>')
          $compile(element)($rootScope)
          $scope.$digest()
          directiveScope = element.scope()


          spyOn(directiveScope.step1, 'hide')
          resetSpy = spyOn(directiveScope.item, 'reset')

          directiveScope.cancel()

          expect(resetSpy).toHaveBeenCalled()

      it "should NOT call model to reset", ->
        inject ($rootScope, $compile,$injector) ->
          Product = $injector.get 'Product'

          $scope.steps = ['step1']
          $scope.step1 =
            hide: () -> null

          $scope.item = new Product {}

          element = angular.element('<cancel-selection></cancel-selection>')
          $compile(element)($rootScope)
          $scope.$digest()
          directiveScope = element.scope()


          hideStep1 = spyOn(directiveScope.step1, 'hide')
          resetSpy = spyOn(directiveScope.item, 'reset')

          directiveScope.cancel()

          expect(hideStep1).toHaveBeenCalled()
          expect(resetSpy).not.toHaveBeenCalled()

      it "should set qty to zero if promo", ->
        inject ($rootScope, $compile,$injector) ->
          Product = $injector.get 'Product'

          $scope.steps = ['step1']
          $scope.step1 =
            hide: () -> null

          $scope.item = new Product {qty:4}
          $scope.isPromoView = true

          element = angular.element('<cancel-selection data-reset-model="item"></cancel-selection>')
          $compile(element)($rootScope)
          $scope.$digest()
          directiveScope = element.scope()


          spyOn(directiveScope.step1, 'hide')
          spyOn(directiveScope.item, 'reset')

          directiveScope.cancel()

          expect($scope.item.qty).toBe 0

      it "should NOT set qty to zero if not promo", ->
        inject ($rootScope, $compile,$injector) ->
          Product = $injector.get 'Product'

          $scope.steps = ['step1']
          $scope.step1 =
            hide: () -> null

          $scope.item = new Product {qty:4}

          element = angular.element('<cancel-selection data-reset-model="item"></cancel-selection>')
          $compile(element)($rootScope)
          $scope.$digest()
          directiveScope = element.scope()


          spyOn(directiveScope.step1, 'hide')
          spyOn(directiveScope.item, 'reset')

          directiveScope.cancel()

          expect($scope.item.qty).toBe 4