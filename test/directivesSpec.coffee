describe "directives", ->

  beforeEach ->
    module 'ionic'
    module 'Muzza.directives'
    module 'Muzza.templates'

    module ($provide) ->
      $provide.value "ShoppingCartService",
        add: ()->
          return null
        getCart: ()->
          return null
        getTotalPrice: () ->
          return null
      return null
    module ($provide) ->
      $provide.value "$state",
          go: () ->
            return null
      return null

  describe "Cart", ->
    $scope = element = ShoppingCartService = isolatedScope = undefined

    beforeEach ->
      inject ($compile, $rootScope, _ShoppingCartService_) ->
        ShoppingCartService = _ShoppingCartService_
        $scope = $rootScope
        element = angular.element('<cart></cart>')
        $compile(element)($rootScope)

    describe 'when shopping cart has at least one item', ->

      it 'should list all items in the shopping cart', ->
        spyOn(ShoppingCartService, 'getCart').and.returnValue [{id:1, desc:'Muzza', qty:1, totalPrice: 10},{id:2, desc:'Fugazzeta',qty:2, totalPrice:5}]
        $scope.$digest()
        items = element.find('ion-item')
        expect(items.length).toBe 2

      it 'should not display the empty msg', ->
        spyOn(ShoppingCartService, 'getCart').and.returnValue [{id:1, desc:'Muzza', qty:1, totalPrice: 10},{id:2, desc:'Fugazzeta',qty:2, totalPrice:5}]
        $scope.$digest()
        msg = element.find('div').html()
        expect(msg).not.toMatch(/vacio/)

      it "should show total price", ->
        spyOn(ShoppingCartService, 'getCart').and.returnValue [{id:1, desc:'Muzza', qty:1, totalPrice: 10},{id:2, desc:'Fugazzeta',qty:2, totalPrice:5}]
        spyOn(ShoppingCartService, 'getTotalPrice').and.returnValue 1211

        $scope.$digest()
        msg = element.find('ion-list').html()
        expect(msg).toMatch(/Total:/)
        expect(msg).toMatch(/12.11/)


    describe 'when shopping cart is empty', ->

      it 'should display a msg when shopping cart is empty', ->
        spyOn(ShoppingCartService, 'getCart').and.returnValue []
        $scope.$digest()
        items = element.find('ion-item')
        msg = element.find('div').html()
        expect(msg).toMatch(/vacio/)
        expect(items.length).toBe 0

      it "should not display totalPrice", ->
        spyOn(ShoppingCartService, 'getCart').and.returnValue []
        $scope.$digest()
        msg = element.find('ion-list').html()
        expect(msg).not.toMatch(/vacio/)

    describe 'when editting', ->

      describe "and hit edit button", ->

        it "should call the edit function with proper data", ->

          spyOn(ShoppingCartService, 'getCart').and.returnValue [{id:1, desc:'Muzza', qty:1, totalPrice: 10, cat: 'EMPANADA'},{id:2, desc:'Fugazzeta',qty:2, totalPrice:5, cat: 'EMPANADA'}]
          $scope.$digest()
          isolatedScope = element.isolateScope()

          editItem = spyOn(isolatedScope, 'edit').and.callFake( () -> 1 )

          element.find('button')[0].click()
          expect(editItem).toHaveBeenCalledWith jasmine.objectContaining {id:1, desc:'Muzza', qty:1, totalPrice: 10}

      describe "edit function show redirect to proper view", ->

        onState = $mystate = undefined

        beforeEach ->
          inject ($state) ->
            $mystate = $state


        it "should redirect to PIZZA edit view", ->

          spyOn(ShoppingCartService, 'getCart').and.returnValue [{hash: '1-Muzza-chica-alala',cat: 'PIZZA'}]
          $scope.$digest()
          isolatedScope = element.isolateScope()

          onState = spyOn($mystate, 'go').and.callFake( () -> 1 )
          editItem = spyOn(isolatedScope, 'edit').and.callThrough()

          element.find('button')[0].click()
          expect(onState).toHaveBeenCalledWith 'app.pizza', {id:'1-Muzza-chica-alala'}

        it "should redirect to EMPANADA edit view", ->

          spyOn(ShoppingCartService, 'getCart').and.returnValue [{hash: '45-Pollo-alhorno',cat: 'EMPANADA'}]
          $scope.$digest()
          isolatedScope = element.isolateScope()

          onState = spyOn($mystate, 'go').and.callFake( () -> 1 )
          editItem = spyOn(isolatedScope, 'edit').and.callThrough()

          element.find('button')[0].click()
          expect(onState).toHaveBeenCalledWith 'app.empanada', {id:'45-Pollo-alhorno'}

        it "should redirect to menu default view if no categ matches", ->

          spyOn(ShoppingCartService, 'getCart').and.returnValue [{hash: '45-newproduct',cat: 'NEW_CATEGORY'}]
          $scope.$digest()
          isolatedScope = element.isolateScope()

          onState = spyOn($mystate, 'go').and.callFake( () -> 1 )
          editItem = spyOn(isolatedScope, 'edit').and.callThrough()

          element.find('button')[0].click()
          expect(onState).toHaveBeenCalledWith 'app.menu'


  describe "Pizzas", ->

    isolatedScope = $scope = element = undefined

    beforeEach ->
      inject ($compile, $rootScope) ->
        $scope = $rootScope
        $scope.menu = [
          {
            id: 1
            desc: "Categ 1"
            products: [
              {
                id: 1
                desc: "Muzza"
                toppings: [ "Muzzarella", "tomate", "Aceitunas" ]
                price:
                  base: 8000
                  size:
                    individual: 0
                    chica: 1000
                    grande: 2000
                  dough:
                    "a la piedra": 2
                    "al molde": 3
              },
              {
                id: 2,
                desc: "Fugazetta"
                toppings: [ "Muzzarella", "Cebolla" ]
                price:
                  base: 7500
                  size:
                    individual: 0
                    chica: 1500
                    grande: 2000
                  dough:
                    "a la piedra": 0
                    "al molde": 0
              }
            ]
          },
          {
            id: 2
            desc: "Categ 2"
            products: [
              id: 3
              desc: "Calabresa"
              toppings: [ "Muzzarella", "Longaniza", "Salsa" ]
              price:
                base: 5000
                size:
                  individual: 0
                  chica: 1000
                  grande: 2000
                dough:
                  "a la piedra": 0
                  "al molde": 0
            ]
          }
        ]

        element = angular.element('<pizzas ng-model="menu"></pizzas>')
        $compile(element)($rootScope)
        $scope.$digest()
        isolatedScope = element.isolateScope()

    describe "init", ->

      it "should display the 3 pizza menu items", ->
        expect(element.find('ion-item').length).toBe 3
        expect(element.html()).toContain('Muzza')
        expect(element.html()).toContain('Fugazetta')
        expect(element.html()).toContain('Calabresa')

      it "should have steps defined in the scope", ->
        expect(isolatedScope.steps).toEqual ['order', 'dough', 'size']

      it "should load the templates for all the steps", ->
        isolatedScope.steps = ['order', 'dough', 'size']
        expect(isolatedScope.order).toBeDefined()
        expect(isolatedScope.dough).toBeDefined()
        expect(isolatedScope.size).toBeDefined()

      it "should have a product defined in the scope", ->
        expect(isolatedScope.pizza).toBeDefined()


      it "should have a choose function defined in the scope", ->
        expect(isolatedScope.choose).toBeDefined()


    describe "When user chooses a product", ->

      it "should show all modals for available steps", ->
        isolatedScope.steps = ['order', 'dough', 'size']
        showOrder = spyOn(isolatedScope.order, 'show').and.callFake( ()-> 1 )
        showSize = spyOn(isolatedScope.size, 'show').and.callFake( ()-> 1 )
        showDough = spyOn(isolatedScope.dough, 'show').and.callFake( ()-> 1 )
        element.find('ion-item')[0].click()

        expect(showOrder).toHaveBeenCalled()
        expect(showOrder.calls.count()).toBe 1
        expect(showSize).toHaveBeenCalled()
        expect(showSize.calls.count()).toBe 1
        expect(showDough).toHaveBeenCalled()
        expect(showDough.calls.count()).toBe 1

      it "should replace the previous selection", ->
        spyOn(isolatedScope.size, 'show').and.callFake( ()-> 1 )
        spyOn(isolatedScope.dough, 'show').and.callFake( ()-> 1 )

        #Choose First Product
        element.find('ion-item')[0].click()
        isolatedScope.pizza.size = 'b'
        isolatedScope.pizza.dough = 'a'

        #Choose Second Product
        element.find('ion-item')[1].click()
        expect(isolatedScope.pizza).toEqual jasmine.objectContaining
          desc : 'Fugazetta'
          id : 2

      it "should call choose function", ->
        isolatedScope.steps = ['order', 'dough', 'size']
        showOrder = spyOn(isolatedScope.order, 'show')
        showDough = spyOn(isolatedScope.dough, 'show')
        showSize = spyOn(isolatedScope.size, 'show')

        chooseSpy = spyOn(isolatedScope, 'choose').and.callThrough()

        element.find('ion-item')[0].click()

        expected =
          id: 1
          desc: "Muzza"
          toppings: [ "Muzzarella", "tomate", "Aceitunas" ]
          price:
            base: 8000
            size:
              individual: 0
              chica: 1000
              grande: 2000
            dough:
              "a la piedra": 2
              "al molde": 3

        expect(chooseSpy).toHaveBeenCalledWith jasmine.objectContaining expected
        expect(isolatedScope.pizza).not.toBeEmpty


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
      module ($provide) ->
        $provide.value "ShoppingCartService",
          add: () ->
            return null
          get: (id) ->
            return null
        return null

      inject ($compile, $rootScope) ->
        $scope = $rootScope
        $scope.menu = [
          {
            "id": 1,
            "desc": "Al Horno",
            "products": [
              {
                "id": 1
                "desc": "Carne cortada a cuchillo"
                "toppings": [ "Carne", "Huevo", "Morron" ]
                "price": 18
              },
              {
                "id": 2
                "desc": "Calabresa"
                "toppings": [ "Muzzarella", "Longaniza", "Salsa" ]
                "price": 18
              }
            ]
          },
          {
            "id": 2,
            "desc": "Fritas",
            "products": [
              {
                "id": 3
                "desc": "Jamon y Queso"
                "toppings": [ "Jamon", "Queso" ]
                "price": 20
              },
              {
                "id": 4
                "desc": "Pollo"
                "toppings": [ "Muzzarella", "Pollo", "Salsa" ]
                "price": 20
              },
              {
                "id": 5
                "desc": "Verdura"
                "toppings": [ "Espinaca", "Salsa" ]
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
      it "should display the 5 products listed on the menu", ->
        expect(element.find('ion-item').length).toBe 5
        expect(element.html()).toContain('Carne cortada a cuchillo')
        expect(element.html()).toContain('Calabresa')
        expect(element.html()).toContain('Jamon y Queso')
        expect(element.html()).toContain('Verdura')
        expect(element.html()).toContain('Pollo')

      it "should have steps defined in the scope", ->
        expect(isolatedScope.steps).toEqual ['order']

      it "should load the templates for all the steps", ->
        isolatedScope.steps = ['order']
        expect(isolatedScope.order).toBeDefined()

      it "should have a product defined in the scope", ->
        expect(isolatedScope.empanada).toBeDefined()


      it "should have a choose function defined in the scope", ->
        expect(isolatedScope.choose).toBeDefined()


    describe "When user chooses a product", ->

      it "should show all modals for available steps", ->
        isolatedScope.steps = ['order']
        showType = spyOn(isolatedScope.order, 'show')
        element.find('ion-item')[0].click()

        expect(showType).toHaveBeenCalled()
        expect(showType.calls.count()).toBe 1

      it "should call choose function", ->
        isolatedScope.steps = ['order']
        showType = spyOn(isolatedScope.order, 'show')
        chooseSpy = spyOn(isolatedScope, 'choose').and.callThrough()

        element.find('ion-item')[0].click()

        expected =
          id: 1
          desc: "Carne cortada a cuchillo"
          toppings: [ "Carne", "Huevo", "Morron" ]
          price: 18

        expect(chooseSpy).toHaveBeenCalledWith( jasmine.objectContaining(expected), "Al Horno" )
        expect(isolatedScope.empanada).not.toBeEmpty


      it "should replace the previous selection", ->
        inject (ShoppingCartService) ->
          isolatedScope.steps = ['order']
          showType = spyOn(isolatedScope.order, 'show')
          addToCart = spyOn(ShoppingCartService, 'add')

          #Choose First Product
          element.find('ion-item')[0].click()

          isolatedScope.empanada.qty = 2
          isolatedScope.order.add isolatedScope.empanada

          expect(addToCart).toHaveBeenCalledWith jasmine.objectContaining {"cat": 'EMPANADA', "qty": 2,"desc": 'Carne cortada a cuchillo Al Horno',"price": 18,"type": 'Al Horno', "id":1,"hash":'1-carnecortadaacuchillo-alhorno',"totalPrice": 18}
          expect(addToCart.calls.count()).toBe 1

          #Choose Second Product
          element.find('ion-item')[1].click()
          expectedEmpanada =
            id: 2
            desc: "Humita"
            price: 80
            qty: 1

          expect(isolatedScope.empanada.id).toEqual expectedEmpanada.id

    describe "when user edits a product", ->

      beforeEach ->
        isolatedScope.steps = ['order']
        showType = spyOn(isolatedScope.order, 'show')
        chooseSpy = spyOn(isolatedScope, 'choose').and.callThrough()

        element.find('ion-item')[0].click()
        isolatedScope.empanada.qty = 2
        isolatedScope.order.add isolatedScope.empanada

        isolatedScope

      it "should update qunatity", ->
        inject (ShoppingCartService) ->
          expected =
            id: 23
            hash:'23-Carnepicante-alhorno'
            qty:5

          getItem = spyOn(ShoppingCartService, 'get').and.returnValue expected
          isolatedScope.choose null, null, '23-Carnepicante-alhorno'

          isolatedScope.empanada.qty = 5


          expect(getItem).toHaveBeenCalledWith expected.hash
          expect(isolatedScope.empanada).toBe expected

        it "should retrieve the product from the cart", ->
          inject (ShoppingCartService) ->
            expected =
              id: 23
              hash:'23-Carnepicante-alhorno'
              qty:5

            getItem = spyOn(ShoppingCartService, 'get').and.returnValue expected
            isolatedScope.choose null, null, '23-Carnepicante-alhorno'

            expect(getItem).toHaveBeenCalledWith expected.hash
            expect(isolatedScope.empanada).toBe expected


  ##### need to put both below inside same describe block
  describe "Checkout Button, car not empty", ->

    $scope = element = ShoppingCartService = undefined

    beforeEach ->
      inject ($compile, $rootScope, _ShoppingCartService_) ->
        ShoppingCartService = _ShoppingCartService_
        $scope = $rootScope
        element = angular.element('<checkout-button></checkout-button>')
        spyOn(ShoppingCartService, 'getCart').and.returnValue  {items: [{id:1, desc:'Muzza'},{id:2, desc:'Fugazzeta'}], price: {total: 20}}
        $compile(element)($rootScope)

    it "should show if car is not empty", ->
      $scope.$digest()
      txt = element.find('button').html()
      expect(txt).toMatch(/Pedido/)

  describe "Checkout Button, car empty", ->

    $scope = element = ShoppingCartService = undefined

    beforeEach ->
      inject ($compile, $rootScope, _ShoppingCartService_) ->
        ShoppingCartService = _ShoppingCartService_
        $scope = $rootScope
        element = angular.element('<checkout-button></checkout-button>')
        spyOn(ShoppingCartService, 'getCart').and.returnValue( [] )
        $compile(element)($rootScope)

    it "should NOT show if car is empty", ->
      $scope.$digest()
      txt = element.find('button').html()
      expect(txt).not.toMatch(/Pedido/)


  describe "when user clicks checkout button", ->

    $scope = element = ShoppingCartService = isolatedScope = undefined

    beforeEach ->
      inject ($compile, $rootScope, _ShoppingCartService_) ->
        ShoppingCartService = _ShoppingCartService_
        $scope = $rootScope
        element = angular.element('<checkout-button></checkout-button>')
        spyOn(ShoppingCartService, 'getCart').and.returnValue {items: [{id:1, desc:'Muzza'},{id:2, desc:'Fugazzeta'}], price:{total:20}}
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