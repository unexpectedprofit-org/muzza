describe "directives", ->

  beforeEach ->
    module 'ionic'
    module 'Muzza.directives'
    module 'Muzza.templates'

    module ($provide) ->
      $provide.value "ShoppingCart",
        addToCart: ()->
          return null
        getCart: ()->
          return null
      return null

  describe "Cart", ->
    $scope = element = ShoppingCart = undefined

    beforeEach ->
      inject ($compile, $rootScope, _ShoppingCart_) ->
        ShoppingCart = _ShoppingCart_
        $scope = $rootScope
        element = angular.element('<cart></cart>')
        $compile(element)($rootScope)

    describe 'when shopping cart has at least on item', ->

      it 'should list all items in the shopping cart', ->
        spyOn(ShoppingCart, 'getCart').and.returnValue( [{id:1, desc:'Muzza'},{id:2, desc:'Fugazzeta'}] )
        $scope.$digest()
        items = element.find('ion-item')
        expect(items.length).toBe 2

      it 'should not display the empty msg', ->
        spyOn(ShoppingCart, 'getCart').and.returnValue( [{id:1, desc:'Muzza'},{id:2, desc:'Fugazzeta'}] )
        $scope.$digest()
        msg = element.find('div').html()
        expect(msg).not.toMatch(/vacio/)

    describe 'when shopping cart is empty', ->

      it 'should display a msg when shopping cart is empty', ->
        spyOn(ShoppingCart, 'getCart').and.returnValue( [] )
        $scope.$digest()
        items = element.find('ion-item')
        msg = element.find('div').html()
        expect(msg).toMatch(/vacio/)
        expect(items.length).toBe 0

  describe "Pizzas", ->

    isolatedScope = $scope = element = undefined

    beforeEach ->
      inject ($compile, $rootScope) ->
        $scope = $rootScope
        $scope.menu = [
          desc: "Muzza"
          id: 1
        ,
          desc: "Fugazetta"
          id: 2
        ]
        element = angular.element('<pizzas ng-model="menu"></pizzas>')
        $compile(element)($rootScope)
        $scope.$digest()
        isolatedScope = element.isolateScope()

    describe "init", ->

      it "should display the 2 pizza menu items", ->
        expect(element.find('button').length).toBe 2
        expect(element.html()).toContain('Muzza')
        expect(element.html()).toContain('Fugazetta')

      it "should an empty selected pizzas collection", ->
        expect(isolatedScope.pizzas.length).toBe 0

      it "should load the templates for the steps", ->
        isolatedScope.steps = ['size', 'dough']
        expect(isolatedScope.size).toBeDefined()
        expect(isolatedScope.dough).toBeDefined()


    describe "When user chooses a product", ->

      it "should show all modals for available steps", ->
        isolatedScope.steps = ['size', 'dough']
        showSize = spyOn(isolatedScope.size, 'show')
        showDough = spyOn(isolatedScope.dough, 'show')
        element.find('button')[0].click()
        expect(showSize).toHaveBeenCalled()
        expect(showDough).toHaveBeenCalled()

      it "should add to ShoppingCart when user selected the add option on the order step", ->
        inject (ShoppingCart) ->
          isolatedScope.steps = ['order','size', 'dough']
          addToCart = spyOn(ShoppingCart, 'addToCart')
          element.find('button')[0].click()
          isolatedScope.size.choose('b')
          isolatedScope.dough.choose('a')
          isolatedScope.order.add()
          expect(addToCart).toHaveBeenCalledWith({"desc":"Muzza","id":1,"size":"b","dough":"a"})

      it "should replace the previous selection", ->
        inject (ShoppingCart) ->
          isolatedScope.steps = ['order','size', 'dough']
          addToCart = spyOn(ShoppingCart, 'addToCart')

          #Choose First Product
          element.find('button')[0].click()
          isolatedScope.size.choose('b')
          isolatedScope.dough.choose('a')
          isolatedScope.order.add()
          expect(addToCart).toHaveBeenCalledWith({"desc":"Muzza","id":1,"size":"b","dough":"a"})

          #Choose Second Product
          element.find('button')[1].click()
          expect(isolatedScope.pizza).toEqual { desc : 'Fugazetta', id : 2 }

  describe "Checkout Button", ->

    $scope = element = ShoppingCart = undefined

    beforeEach ->
      inject ($compile, $rootScope, _ShoppingCart_) ->
        ShoppingCart = _ShoppingCart_
        $scope = $rootScope
        element = angular.element('<checkout-button></checkout-button>')
        $compile(element)($rootScope)

    it "should show if car is not empty", ->
      spyOn(ShoppingCart, 'getCart').and.returnValue( [{id:1, desc:'Muzza'},{id:2, desc:'Fugazzeta'}] )
      $scope.$digest()
      txt = element.find('button').html()
      expect(txt).toMatch(/CHECKOUT/)

#    it "should NOT show if car is empty", ->
#      spyOn(ShoppingCart, 'getCart').and.returnValue( [] )
#      $scope.$digest()
#      txt = element.find('button').html()
#      expect(txt).not.toMatch(/CHECKOUT/)


    describe "when user clicks checkout button", ->

      isolatedScope = undefined

      beforeEach ->
        spyOn(ShoppingCart, 'getCart').and.returnValue( [{id:1, desc:'Muzza'},{id:2, desc:'Fugazzeta'}] )
        $scope.$digest()
        isolatedScope = element.isolateScope()

      it "should show all modals for available steps", ->

        isolatedScope.steps = ['contact', 'delivery']
        showDeliveryMethod = spyOn(isolatedScope.delivery, 'show')
        showContactForm = spyOn(isolatedScope.contact, 'show')

        element.find('button')[0].click()
        expect(showDeliveryMethod).toHaveBeenCalled()
        expect(showContactForm).toHaveBeenCalled()

    #      TODO ADD TEST TO FILL IN DATA IN FIRST MODAL AND GET TO THE SECOND ONE




