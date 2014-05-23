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
      return null
    module ($provide) ->
      $provide.value "$state",
        go: () ->
          return null
      return null

  isolatedScope = $scope = element = undefined

  beforeEach ->
    inject ($compile, $rootScope) ->
      $scope = $rootScope
      $scope.menu = [
        "id": 1,
        "desc": "Al Horno",
        "products": [
          "id": 1
          "desc": "Carne cortada a cuchillo"
          "toppings": "Carne / Huevo / Morron"
          "price": 1800
        ,
          "id": 2
          "desc": "Calabresa"
          "toppings": "Muzzarella / Longaniza / Salsa"
          "price": 1900
        ]
      ,
        "id": 2,
        "desc": "Fritas",
        "products": [
          "id": 3
          "desc": "Jamon y Queso"
          "toppings": "Jamon / Queso"
          "price": 2000
        ,
          "id": 4
          "desc": "Pollo"
          "toppings": "Muzzarella / Pollo / Salsa"
          "price": 2100
        ,
          "id": 5
          "desc": "Verdura"
          "toppings": "Espinaca / Salsa"
          "price": 2200
        ]
      ]
      element = angular.element('<empanadas ng-model="menu"></empanadas>')
      $compile(element)($rootScope)
      $scope.$digest()
      isolatedScope = element.isolateScope()



  describe "init", ->
    it "should display the 5 products listed on the menu", ->

      expect(element.find('ion-item').length).toBe 5
#      expect(element.find('.item.item-divider').length).toBe 2

      onClickEvent = element.find('ion-item')[0].attributes['ng-click'].nodeValue
      expect(onClickEvent).toContain "choose(prod, cat.desc)"

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
        toppings: "Carne / Huevo / Morron"
        price: 1800

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

        expect(addToCart).toHaveBeenCalledWith jasmine.objectContaining {"cat": 'EMPANADA', "qty": 2,"desc": 'Carne cortada a cuchillo Al Horno',"price": 1800,"type": 'Al Horno', "id":1,"hash":'1-carnecortadaacuchillo-alhorno',"totalPrice": 1800}
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