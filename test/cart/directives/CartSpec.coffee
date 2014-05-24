describe "Cart", ->

  beforeEach ->
    module 'Muzza.cart'
    module 'Muzza.templates'
    module 'Muzza.directives'

    module ($provide) ->
      $provide.value "ShoppingCartService",
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

    it "should display items sorted by category - 1", ->
      pizza = {desc:'Muzza', qty:1,totalPrice: 1000,cat:'PIZZA'}
      empanada = {desc:'Humita',qty:1,totalPrice:2000,cat:'EMPANADA'}

      spyOn(ShoppingCartService, 'getCart').and.returnValue [pizza,empanada]
      $scope.$digest()
      items = element.find('ion-list').children()

      expect(items[0].innerHTML).toContain empanada.desc
      expect(items[1].innerHTML).toContain pizza.desc

    it "should display items sorted by category - 2", ->
      pizza = {desc:'Muzza', qty:1,totalPrice: 1000,cat:'PIZZA'}
      empanada = {desc:'Humita',qty:1,totalPrice:2000,cat:'EMPANADA'}

      spyOn(ShoppingCartService, 'getCart').and.returnValue [empanada,pizza]
      $scope.$digest()
      items = element.find('ion-list').children()

      expect(items[0].innerHTML).toContain empanada.desc
      expect(items[1].innerHTML).toContain pizza.desc


  describe 'when shopping cart is empty', ->

    it "should list no items", ->
      spyOn(ShoppingCartService, 'getCart').and.returnValue []
      $scope.$digest()
      items = element.find('ion-item')
      expect(items.length).toBe 0

    it 'should display the empty msg', ->
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