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

      it "should add to ShoppingCart when user selected the add option on the order step", ->
        inject (ShoppingCart) ->
          isolatedScope.steps = ['order','size', 'dough']
          addToCart = spyOn(ShoppingCart, 'addToCart')
          element.find('button')[0].click()
          isolatedScope.size.choose('b')
          isolatedScope.dough.choose('a')
          isolatedScope.pizza.size = 'b'
          isolatedScope.pizza.dough = 'a'
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
          isolatedScope.pizza.size = 'b'
          isolatedScope.pizza.dough = 'a'
          isolatedScope.order.add()
          expect(addToCart).toHaveBeenCalledWith({"desc":"Muzza","id":1,"size":"b","dough":"a"})

          #Choose Second Product
          element.find('button')[1].click()
          expect(isolatedScope.pizza).toEqual { desc : 'Fugazetta', id : 2 }

      describe "When user eliminates selected product and options", ->

        it "should hide confirmation modal", ->
          isolatedScope.steps = ['order','size', 'dough']
          hideOrder = spyOn(isolatedScope.order, 'hide')
          element.find('button')[0].click()
          isolatedScope.size.choose('b')
          isolatedScope.dough.choose('a')
          isolatedScope.pizza.size = 'b'
          isolatedScope.pizza.dough = 'a'
          isolatedScope.order.cancel()
          expect(hideOrder).toHaveBeenCalled()

      describe "When user decides to edit the selected product and options", ->

        it "should display all option modals", ->
          isolatedScope.steps = ['size', 'dough']
          showSize = spyOn(isolatedScope.size, 'show')
          showDough = spyOn(isolatedScope.dough, 'show')
          element.find('button')[0].click()
          isolatedScope.size.choose('b')
          isolatedScope.dough.choose('a')
          isolatedScope.pizza.size = 'b'
          isolatedScope.pizza.dough = 'a'
          isolatedScope.order.edit()
          isolatedScope.pizza.size = 'a'
          expect(showSize.calls.count()).toBe 2
          expect(showDough.calls.count()).toBe 2
          expect(isolatedScope.pizza.size).toBe 'a'
          expect(isolatedScope.pizza.dough).toBe 'a'

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
        ,
          desc: "Humita"
          id: 2
        ,
          desc: "Pollo"
          id: 3
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
        isolatedScope.steps = ['type']
        showType = spyOn(isolatedScope.type, 'show')
        element.find('button')[0].click()
        expect(showType).toHaveBeenCalled()

      it "should add to ShoppingCart when user selected the add option on the order step", ->
        inject (ShoppingCart) ->
          isolatedScope.steps = ['order','type']
          addToCart = spyOn(ShoppingCart, 'addToCart')
          element.find('button')[0].click()
          isolatedScope.type.choose 0, 10
          isolatedScope.order.add()
          expect(addToCart).toHaveBeenCalledWith {"desc":"Jamon y Queso","id":1, "type": {"f":0,"h": 10}}

      it "should replace the previous selection", ->
        inject (ShoppingCart) ->
          isolatedScope.steps = ['order','type']
          addToCart = spyOn(ShoppingCart, 'addToCart')

          #Choose First Product
          element.find('button')[0].click()
          isolatedScope.type.choose 2, 3
          isolatedScope.order.add()
          expect(addToCart).toHaveBeenCalledWith {"desc":"Jamon y Queso","id":1, "type": {"f":2,"h": 3}}

          #Choose Second Product
          element.find('button')[1].click()
          expect(isolatedScope.empanada).toEqual { desc : 'Humita', id : 2 }

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
        isolatedScope.type.choose 2, 3
        isolatedScope.order.edit()
        expect(isolatedScope.empanada.type.h).toBe 3
        expect(isolatedScope.empanada.type.f).toBe 2
        isolatedScope.type.choose 5, 6
        expect(showType.calls.count()).toBe 2
        expect(isolatedScope.empanada.type.h).toBe 6
        expect(isolatedScope.empanada.type.f).toBe 5


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



  describe "Validate Empanadas", ->

    $scope = element = form = undefined

    beforeEach ->
      inject ($compile, $rootScope) ->
        $scope = $rootScope
        element = angular.element(
          '<form name="form" data-validate-empanada-selection data-ng-model="empanada">' +
          '<input type="number" name="empanada_f_qty" data-ng-model="empanada.fri"/>' +
          '<input type="number" name="empanada_h_qty" data-ng-model="empanada.hor"/>' +
          '</form>'
        )
        $scope.model = { empanada: {} }
        $compile(element)($scope)
        $scope.$digest()
        form = $scope.form

    it "should not validate if both empanada types have 0 quantity", ->
      form.empanada_f_qty.$setViewValue 0
      form.empanada_h_qty.$setViewValue 0
      $scope.$digest()
      expect(form.$error.missingQty).toBeTruthy()

    it "should validate if empanada type 'F' has 0 quantity and 'H' has more than 0", ->
      form.empanada_f_qty.$setViewValue 0
      form.empanada_h_qty.$setViewValue 1
      $scope.$digest()
      expect(form.$error.missingQty).toBeFalsy()

    it "should validate if empanada type 'F' has more than 0 quantity and 'H' has 0", ->
      form.empanada_f_qty.$setViewValue 5
      form.empanada_h_qty.$setViewValue 0
      $scope.$digest()
      expect(form.$error.missingQty).toBeFalsy()

    it "should validate if both empanada types have more than 0", ->
      form.empanada_f_qty.$setViewValue 8
      form.empanada_h_qty.$setViewValue 20
      $scope.$digest()
      expect(form.$error.missingQty).toBeFalsy()
