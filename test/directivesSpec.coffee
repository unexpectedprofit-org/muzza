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

      it "should replace the previous selection", ->
        #Choose First Product
        element.find('button')[0].click()
        isolatedScope.pizza.size = 'b'
        isolatedScope.pizza.dough = 'a'

        #Choose Second Product
        element.find('button')[1].click()
        expect(isolatedScope.pizza).toEqual { desc : 'Fugazetta', id : 2 }


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
      expect(hideSize).toHaveBeenCalled()


  describe "Empanadas", ->

    isolatedScope = $scope = element = undefined

    beforeEach ->
      inject ($compile, $rootScope) ->
        $scope = $rootScope
        $scope.menu = [
          desc: "Jamon y Queso"
          id: 1
          price: 100
        ,
          desc: "Humita"
          id: 2
          price: 80
        ,
          desc: "Pollo"
          id: 3
          price: 90
        ]
        element = angular.element('<empanadas ng-model="menu"></empanadas>')
        $compile(element)($rootScope)
        $scope.$digest()
        isolatedScope = element.isolateScope()

    describe "init", ->
      it "should display the 2 empanadas menu items", ->
        expect(element.find('button').length).toBe 3
        expect(element.html()).toContain('Jamon y Queso')
        expect(element.html()).toContain('Humita')
        expect(element.html()).toContain('Pollo')

      it "should load the templates for the steps", ->
        isolatedScope.steps = ['type']
        expect(isolatedScope.type).toBeDefined()

    describe "When user chooses a product", ->
      it "should show all modals for available steps", ->
        isolatedScope.steps = ['order', 'type']
        showType = spyOn(isolatedScope.type, 'show')
        element.find('button')[0].click()
        expect(showType).toHaveBeenCalled()

      xit "should add to ShoppingCart when user selected the add option on the order step", ->
        inject (ShoppingCart) ->
          hideType = spyOn(isolatedScope.type, 'hide')
          addToCart = spyOn(ShoppingCart, 'addToCart')

          isolatedScope.steps = ['order','type']
          element.find('button')[0].click()

          isolatedScope.empanada.qty = 5
          isolatedScope.type.choose()
          isolatedScope.order.add()

          expect(hideType).toHaveBeenCalled()
          expect(hideType.calls.count()).toBe 1

          expect(addToCart).toHaveBeenCalledWith  { qty : 5, desc : 'Jamon y Queso', price : 100, id : 1 }
          expect(addToCart.calls.count()).toBe 1

      xit "should replace the previous selection", ->
        inject (ShoppingCart) ->
          isolatedScope.steps = ['order','type']
          addToCart = spyOn(ShoppingCart, 'addToCart')

          #Choose First Product
          element.find('button')[0].click()
          isolatedScope.empanada.qty = 2
          isolatedScope.type.choose
          isolatedScope.order.add()

          expect(addToCart.calls.count()).toBe 1
          expect(addToCart).toHaveBeenCalledWith {"qty": 2,"desc": 'Jamon y Queso',"price": 100,"id":1}

          #Choose Second Product
          element.find('button')[1].click()
          expectedEmpanada =
            id: 2
            desc: "Humita"
            price: 80
            qty: 1


          expect(isolatedScope.empanada.id).toEqual expectedEmpanada.id

    describe "When user eliminates selected product and options", ->

      it "should hide confirmation modal", ->
        isolatedScope.steps = ['order','type']
        hideOrder = spyOn(isolatedScope.order, 'hide')
        element.find('button')[0].click()
        isolatedScope.type.choose 2, 3
        isolatedScope.order.cancel()
        expect(hideOrder).toHaveBeenCalled()

    describe "When user decides to edit the selected product and options", ->

      it "should display all option modals", ->
        isolatedScope.steps = ['order','type']
        showType = spyOn(isolatedScope.type, 'show')
        element.find('button')[0].click()
        isolatedScope.type.choose
        isolatedScope.order.edit()
        expect(isolatedScope.empanada.qty).toBe 1
        isolatedScope.empanada.qty = 5
        isolatedScope.type.choose
        expect(showType.calls.count()).toBe 2
        expect(isolatedScope.empanada.qty).toBe 5


  ##### need to put both below inside same describe block
  describe "Checkout Button, car not empty", ->

    $scope = element = ShoppingCart = undefined

    beforeEach ->
      inject ($compile, $rootScope, _ShoppingCart_) ->
        ShoppingCart = _ShoppingCart_
        $scope = $rootScope
        element = angular.element('<checkout-button></checkout-button>')
        spyOn(ShoppingCart, 'getCart').and.returnValue( [{id:1, desc:'Muzza'},{id:2, desc:'Fugazzeta'}] )
        $compile(element)($rootScope)

    it "should show if car is not empty", ->
      $scope.$digest()
      txt = element.find('button').html()
      expect(txt).toMatch(/Pedido/)

  describe "Checkout Button, car empty", ->

    $scope = element = ShoppingCart = undefined

    beforeEach ->
      inject ($compile, $rootScope, _ShoppingCart_) ->
        ShoppingCart = _ShoppingCart_
        $scope = $rootScope
        element = angular.element('<checkout-button></checkout-button>')
        spyOn(ShoppingCart, 'getCart').and.returnValue( [] )
        $compile(element)($rootScope)

    it "should NOT show if car is empty", ->
      $scope.$digest()
      txt = element.find('button').html()
      expect(txt).not.toMatch(/Pedido/)


  describe "when user clicks checkout button", ->

    $scope = element = ShoppingCart = isolatedScope = undefined

    beforeEach ->
      inject ($compile, $rootScope, _ShoppingCart_) ->
        ShoppingCart = _ShoppingCart_
        $scope = $rootScope
        element = angular.element('<checkout-button></checkout-button>')
        spyOn(ShoppingCart, 'getCart').and.returnValue( [{id:1, desc:'Muzza'},{id:2, desc:'Fugazzeta'}] )
        $compile(element)($rootScope)
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
