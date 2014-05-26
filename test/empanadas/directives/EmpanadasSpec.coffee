describe "Empanadas", ->

  beforeEach ->
    module 'ionic'
    module 'Muzza.empanadas'
    module 'Muzza.templates'
    module 'Muzza.directives'

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

  isolatedScope = $scope = element = Empanada = $stateParams = undefined
  empanada1 = empanada2 = empanada3 = empanada4 = empanada5 = undefined

  beforeEach ->
    inject ($compile, $rootScope, _Empanada_, _$stateParams_ ) ->
      Empanada = _Empanada_
      $scope = $rootScope
      $stateParams = _$stateParams_

      empanada1 = new Empanada {id:1,desc:"Carne cortada a cuchillo",price: {base:1800},toppings:"Carne / Huevo / Morron"}
      empanada2 = new Empanada {id:2,desc:"Calabresa",price: {base:1900},toppings:"Muzzarella / Longaniza / Salsa"}
      empanada3 = new Empanada {id:3,desc:"Jamon y Queso",price:{base:2000},toppings:"Jamon / Queso"}
      empanada4 = new Empanada {id:4,desc:"Pollo",price: {base:2100},toppings:"Muzzarella / Pollo / Salsa"}
      empanada5 = new Empanada {id:5,desc:"Verdura",price: {base:2200},toppings:"Espinaca / Salsa"}

      $scope.menu =
        empanada: [
          "id": 1,
          "desc": "Al Horno",
          "products": [ empanada1, empanada2 ]
        ,
          "id": 2,
          "desc": "Fritas",
          "products": [ empanada3, empanada4, empanada5 ]
        ]
      element = angular.element('<empanadas ng-model="menu.empanada"></empanadas>')
      $compile(element)($rootScope)
      $scope.$digest()
      isolatedScope = element.isolateScope()



  describe "init", ->
    it "should display the 5 products listed on the menu", ->

      expect(element.find('ion-item').length).toBe 5

      expect(isolatedScope.menu[0].products[0] instanceof Empanada).toBeTruthy()
      expect(isolatedScope.menu[0].products[0]).toBe empanada1

      expect(element.html()).toContain 'Carne cortada a cuchillo'
      expect(element.html()).toContain "Carne / Huevo / Morron"
      expect(element.html()).toContain "18.00"

      expect(element.html()).toContain 'Calabresa'
      expect(element.html()).toContain "Muzzarella / Longaniza / Salsa"
      expect(element.html()).toContain "19.00"

      expect(element.html()).toContain 'Jamon y Queso'
      expect(element.html()).toContain "Jamon / Queso"
      expect(element.html()).toContain "20.00"

      expect(element.html()).toContain 'Pollo'
      expect(element.html()).toContain "Muzzarella / Pollo / Salsa"
      expect(element.html()).toContain "21.00"

      expect(element.html()).toContain 'Verdura'
      expect(element.html()).toContain "Espinaca / Salsa"
      expect(element.html()).toContain "22.00"

    it "should display the 2 categories", ->
      expect(element.html()).toContain "Al Horno"
      expect(element.html()).toContain "Fritas"

    it "should have a click function bind", ->
      onClickEvent = element.find('ion-item')[0].attributes['data-ng-click'].nodeValue

      expect(onClickEvent).toContain "choose(prod)"

    it "should have steps defined in the scope", ->
      expect(isolatedScope.steps).toEqual ['order']

    it "should load the templates for all the steps", ->
      isolatedScope.steps = ['order']
      expect(isolatedScope.order).toBeDefined()

    it "should have a product defined in the scope", ->
      expect(isolatedScope.empanada).toBeDefined()

    it "should have functions defined in the scope", ->
      expect(isolatedScope.choose).toBeDefined()
      expect(isolatedScope.remove).toBeDefined()


  describe "When user chooses a product", ->

    it "should show all modals for available steps", ->
      isolatedScope.steps = ['order']
      showType = spyOn(isolatedScope.order, 'show')
      element.find('ion-item')[0].click()

      expect(showType).toHaveBeenCalled()
      expect(showType.calls.count()).toBe 1

    it 'should create a Pizza model from the item picked form the menu', ->
      element.find('ion-item')[0].click()
      expect(isolatedScope.empanada instanceof Empanada).toBeTruthy()

    it "should replace the previous selection", ->
      inject (ShoppingCartService) ->
        isolatedScope.steps = ['order']
        showType = spyOn(isolatedScope.order, 'show')
        addToCart = spyOn(ShoppingCartService, 'add')

        #Choose First Product
        element.find('ion-item')[0].click()

        isolatedScope.empanada.qty = 2
        isolatedScope.order.add isolatedScope.empanada

        expected = empanada1
        expected.qty = 2

        expect(addToCart).toHaveBeenCalledWith jasmine.objectContaining
          id: expected.id
          qty: expected.qty
        expect(addToCart.calls.count()).toBe 1

        #Choose Second Product
        element.find('ion-item')[1].click()

        expect(isolatedScope.empanada).not.toBe empanada2
        expect(isolatedScope.empanada).toEqual jasmine.objectContaining
          id: empanada2.id
          qty: empanada2.qty
          desc: empanada2.desc


  describe "when system requests the menu an specific item view", ->

    getItemSpy = undefined

    describe "and the item is an EMPANADA", ->

      beforeEach ->
        inject ($compile, $rootScope, _ShoppingCartService_) ->
          ShoppingCartService = _ShoppingCartService_
          getItemSpy = spyOn(ShoppingCartService, 'get').and.returnValue empanada1
          $stateParams.empanadaId = 1
          element = angular.element('<empanadas ng-model="menu"></empanadas>')
          $compile(element)($rootScope)
          $scope.$digest()
          isolatedScope = element.isolateScope()

      it "should retrieve the item from the shopping cart", ->
        expect(getItemSpy).toHaveBeenCalled()

      it 'should copy the item from the shopping cart into a new one to avoid changing the cart item', ->
        inject (ShoppingCartService)->
          cartItem = ShoppingCartService.get $stateParams.empanadaId
          expect(cartItem).not.toEqual isolatedScope.empanada

    describe "and the item is not an empanada", ->

      beforeEach ->
        inject ($rootScope, $compile, _ShoppingCartService_) ->
          ShoppingCartService = _ShoppingCartService_
          $stateParams.empanadaId = undefined
          $stateParams.pizzaId = 2
          getItemSpy = spyOn(ShoppingCartService, 'get').and.returnValue empanada1
          element = angular.element('<empanadas ng-model="menu"></empanadas>')
          $compile(element)($rootScope)
          $scope.$digest()
          isolatedScope = element.isolateScope()

      it "should not retrieve the product", ->
        expect(getItemSpy).not.toHaveBeenCalled()


  describe "when user deletes a product", ->

    it "should remove the item from the modal scope", ->
      chooseSpy = spyOn(isolatedScope, 'choose').and.callThrough()
      element.find('ion-item')[0].click()
      isolatedScope.remove()

      expect(isolatedScope.empanada).toBeUndefined()
