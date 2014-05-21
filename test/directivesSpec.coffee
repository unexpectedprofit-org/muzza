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
        showSize = spyOn(isolatedScope.size, 'show').and.callFake( ()-> 1 )
        showDough = spyOn(isolatedScope.dough, 'show').and.callFake( ()-> 1 )
        element.find('button')[0].click()

        expect(showSize).toHaveBeenCalled()
        expect(showSize.calls.count()).toBe 1
        expect(showDough).toHaveBeenCalled()
        expect(showDough.calls.count()).toBe 1

      it "should replace the previous selection", ->
        spyOn(isolatedScope.size, 'show').and.callFake( ()-> 1 )
        spyOn(isolatedScope.dough, 'show').and.callFake( ()-> 1 )

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
      expect(hideOrder.calls.count()).toBe 1
      expect(hideSize).toHaveBeenCalled()
      expect(hideSize.calls.count()).toBe 1


  describe "Empanadas", ->

    isolatedScope = $scope = element = undefined

    beforeEach ->
      inject ($compile, $rootScope) ->
        $scope = $rootScope
        $scope.menu = [
          {
            "id": 1,
            "desc": "Al Horno",
            "prod": [
              {
                "id": 1
                "desc": "Carne cortada a cuchillo"
                "topp": [ "Carne", "Huevo", "Morron" ]
                "price": 18
              },
              {
                "id": 2
                "desc": "Calabresa"
                "topp": [ "Muzzarella", "Longaniza", "Salsa" ]
                "price": 18
              }
            ]
          },
          {
            "id": 2,
            "desc": "Fritas",
            "prod": [
              {
                "id": 3
                "desc": "Jamon y Queso"
                "topp": [ "Jamon", "Queso" ]
                "price": 20
              },
              {
                "id": 4
                "desc": "Pollo"
                "topp": [ "Muzzarella", "Pollo", "Salsa" ]
                "price": 20
              },
              {
                "id": 5
                "desc": "Verdura"
                "topp": [ "Espinaca", "Salsa" ]
                "price": 20
              }
            ]
          }
        ]
        element = angular.element('<empanadas ng-model="menu"></empanadas>')
        $compile(element)($rootScope)
        $scope.$digest()
        isolatedScope = element.isolateScope()

    describe "init", ->
      it "should display the 2 empanadas menu items", ->
        expect(element.find('a').length).toBe 5
        expect(element.html()).toContain('Carne cortada a cuchillo')
        expect(element.html()).toContain('Calabresa')
        expect(element.html()).toContain('Jamon y Queso')
        expect(element.html()).toContain('Verdura')
        expect(element.html()).toContain('Pollo')

      it "should load the templates for the steps", ->
        isolatedScope.steps = ['qty']
        expect(isolatedScope.qty).toBeDefined()

    describe "When user chooses a product", ->

      it "should show all modals for available steps", ->
        isolatedScope.steps = ['order', 'qty']
        showType = spyOn(isolatedScope.qty, 'show')
        element.find('a')[0].click()

        expect(showType).toHaveBeenCalled()
        expect(showType.calls.count()).toBe 1

      xit "should replace the previous selection", ->
        inject (ShoppingCart) ->
          isolatedScope.steps = ['order','qty']
          addToCart = spyOn(ShoppingCart, 'addToCart')

          #Choose First Product
          element.find('a')[0].click()
          isolatedScope.empanada.qty = 2
          isolatedScope.qty.choose()
          isolatedScope.order.add()

          expect(addToCart).toHaveBeenCalledWith {"qty": 2,"desc": 'Carne cortada a cuchillo',"price": 18,"type": 'Al Horno', "id":1}
          expect(addToCart.calls.count()).toBe 1

          #Choose Second Product
          element.find('a')[1].click()
          expectedEmpanada =
            id: 2
            desc: "Humita"
            price: 80
            qty: 1

          expect(isolatedScope.empanada.id).toEqual expectedEmpanada.id

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
      expect(showDeliveryMethod.calls.count()).toBe 1
      expect(showContactForm).toHaveBeenCalled()
      expect(showContactForm.calls.count()).toBe 1

  #      TODO ADD TEST TO FILL IN DATA IN FIRST MODAL AND GET TO THE SECOND ONE