#describe "Empanadas", ->
#
#  beforeEach ->
#    module 'ionic'
#    module 'Muzza.empanadas'
#    module 'Muzza.templates'
#    module 'Muzza.directives'
#
#    module ($provide) ->
#      $provide.value "ShoppingCartService",
#        add: ()->
#          return null
#        getCart: ()->
#          return null
#        getTotalPrice: () ->
#         return null
#        get: ()->
#          return null
#      $provide.value "$state",
#        go: () ->
#          return null
#      $provide.value "$stateParams",
#        {}
#      return null
#
#  isolatedScope = $scope = element = Empanada = $stateParams = undefined
#  empanada1 = empanada2 = empanada3 = empanada4 = empanada5 = undefined
#
#  beforeEach ->
#    inject ($compile, $rootScope, _Empanada_, _$stateParams_ ) ->
#      Empanada = _Empanada_
#      $scope = $rootScope
#      $stateParams = _$stateParams_
#
#      empanada1 = new Empanada {id:1,desc:"Carne cortada a cuchillo",price: {base:1800},toppings:"Carne / Huevo / Morron"}
#      empanada2 = new Empanada {id:2,desc:"Calabresa",price: {base:1900},toppings:"Muzzarella / Longaniza / Salsa"}
#      empanada3 = new Empanada {id:3,desc:"Jamon y Queso",price:{base:2000},toppings:"Jamon / Queso"}
#      empanada4 = new Empanada {id:4,desc:"Pollo",price: {base:2100},toppings:"Muzzarella / Pollo / Salsa"}
#      empanada5 = new Empanada {id:5,desc:"Verdura",price: {base:2200},toppings:"Espinaca / Salsa"}
#
#      $scope.menu =
#        empanada: [
#          "id": 1,
#          "desc": "Al Horno",
#          "products": [ empanada1, empanada2 ]
#        ,
#          "id": 2,
#          "desc": "Fritas",
#          "products": [ empanada3, empanada4, empanada5 ]
#        ]
#      element = angular.element('<empanadas ng-model="menu.empanada"></empanadas>')
#      $compile(element)($rootScope)
#      $scope.$digest()
#      isolatedScope = element.isolateScope()
#
#
#
#  describe "init", ->
#    it "should display the 5 products listed on the menu", ->
#
#      expect(element.find('ion-item').length).toBe 5
#
#      expect(isolatedScope.menu[0].products[0] instanceof Empanada).toBeTruthy()
#      expect(isolatedScope.menu[0].products[0]).toBe empanada1
#
#    it "should have a click function bind", ->
#      onClickEvent = element.find('ion-item')[0].attributes['data-ng-click'].nodeValue
#
#      expect(onClickEvent).toContain "choose(product)"
#
#    it "should have steps defined in the scope", ->
#      expect(isolatedScope.steps).toEqual ['order']
#
#    it "should load the templates for all the steps", ->
#      isolatedScope.steps = ['order']
#      expect(isolatedScope.order).toBeDefined()
#
#    it "should have a product defined in the scope", ->
#      expect(isolatedScope.empanadaSelection).toBeDefined()
#
#    it "should have functions defined in the scope", ->
#      expect(isolatedScope.choose).toBeDefined()
#      expect(isolatedScope.remove).toBeDefined()
#
#
#  describe "When user chooses a product", ->
#
#    it "should show all modals for available steps", ->
#      isolatedScope.steps = ['order']
#      showType = spyOn(isolatedScope.order, 'show')
#      element.find('ion-item')[0].click()
#
#      expect(showType).toHaveBeenCalled()
#      expect(showType.calls.count()).toBe 1
#
#    it 'should create a Pizza model from the item picked form the menu', ->
#      element.find('ion-item')[0].click()
#      expect(isolatedScope.empanadaSelection instanceof Empanada).toBeTruthy()
#
#    it "should replace the previous selection", ->
#      inject (ShoppingCartService) ->
#        isolatedScope.steps = ['order']
#        showType = spyOn(isolatedScope.order, 'show')
#        addToCart = spyOn(ShoppingCartService, 'add')
#
#        #Choose First Product
#        element.find('ion-item')[0].click()
#
#        isolatedScope.empanadaSelection.qty = 2
#        isolatedScope.order.add isolatedScope.empanadaSelection
#
#        expected = empanada1
#        expected.qty = 2
#
#        expect(addToCart).toHaveBeenCalledWith jasmine.objectContaining
#          id: expected.id
#          qty: expected.qty
#        expect(addToCart.calls.count()).toBe 1
#
#        #Choose Second Product
#        element.find('ion-item')[1].click()
#
#        expect(isolatedScope.empanadaSelection).not.toBe empanada2
#        expect(isolatedScope.empanadaSelection).toEqual jasmine.objectContaining
#          id: empanada2.id
#          qty: empanada2.qty
#          desc: empanada2.desc
#
#
#  describe "when user deletes a product", ->
#
#    it "should remove the item from the modal scope", ->
#      chooseSpy = spyOn(isolatedScope, 'choose').and.callThrough()
#      element.find('ion-item')[0].click()
#      isolatedScope.remove()
#
#      expect(isolatedScope.empanadaSelection).toBeUndefined()
#
#
#  describe "when details are requested not to be shown", ->
#
#    beforeEach ->
#      inject ( $compile, $rootScope) ->
#        $scope = $rootScope
#        $scope.menu =
#          empanada: [
#            "id": 1,
#            "desc": "Al Horno",
#            "products": [ empanada1, empanada2 ]
#          ,
#            "id": 2,
#            "desc": "Fritas",
#            "products": [ empanada3, empanada4, empanada5 ]
#          ]
#        element = angular.element('<empanadas ng-model="menu.empanada" data-nodetails="true"></empanadas>')
#        $compile(element)($rootScope)
#        $scope.$digest()
#
#    it "should show minimum data", ->
#      expect(element.html()).toContain "product.description"
#      expect(element.html()).toContain "product.toppings"
#
#    it "should not show product details", ->
#      expect(element.html()).not.toContain "product.price"
#      expect(element.html()).not.toContain "item.qty"
#
#    it "should show qty buttons", ->
#      expect(element.html()).toContain "<qty"
#      expect(element.html()).toContain "isPromoValid[cat.ruleId].success"