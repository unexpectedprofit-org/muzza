describe 'Product Directive', ->

  beforeEach ->
    module 'Muzza.product'
    module 'Muzza.templates'
    module 'Muzza.directives'
    module 'ionic'

    module ($provide) ->
      $provide.value 'ShoppingCartService',
        add: () ->
      null

  Product = element = isolatedScope = $scope = undefined

  beforeEach ->
    inject ($compile, $rootScope, $injector) ->
      Product = $injector.get 'Product'
      $scope = $rootScope
      $scope.menu = [
        id:1
        description: "Bebidas"
        products:[
          id:2
        ,
          id:3
        ,
          id:4
        ]
      ,
        id:2
        description:"Pastas"
        products:[
          id:9
          options:[
            selection: [{}]
            items:[
              id:1
              isSelected:true
            ,
              id:2
              isSelected:false
            ]
          ,
            selection: [{}]
            items:[
              id:1
              isSelected:true
            ]
          ]
        ,
          id:10
        ]
      ]

      element = angular.element('<product data-ng-model="menu"></product>')
      $compile(element)($rootScope)
      $scope.$digest()
      isolatedScope = element.isolateScope()


  describe "init", ->

    it "should have a click function bound", ->
      onClickEvent = element.find('ion-item')[0].attributes['data-ng-click'].nodeValue

      expect(onClickEvent).toContain "chooseProduct(product)"

    it "should have functions defined in the scope", ->
      expect(isolatedScope.chooseProduct).toBeDefined()


  xdescribe "chooseProduct functionality", ->

    beforeEach ->
      isolatedScope.chooseProduct $scope.menu[1].products[0]

    it "should call clearSelection on product object ", ->

      expect(isolatedScope.product.options[0].selection).toBeUndefined()
      expect(isolatedScope.product.options[0].items[0].isSelected).toBeUndefined()
      expect(isolatedScope.product.options[0].items[1].isSelected).toBeUndefined()

      expect(isolatedScope.product.options[1].selection).toBeUndefined()
      expect(isolatedScope.product.options[1].items[0].isSelected).toBeUndefined()

    it "should set a product Type object in the scope", ->

      expect(isolatedScope.product instanceof Product).toBeTruthy()

    it "should NOT set qty to zero / define function if NO multipleQty option type", ->

      expect(isolatedScope.product.options[0].items[0].qty).not.toBe 0
      expect(isolatedScope.product.options[0].items[1].qty).not.toBe 0
      expect(isolatedScope.product.options[0].items[0].updateQty()).toBeUndefined()
      expect(isolatedScope.product.options[0].items[1].updateQty()).toBeUndefined()

      expect(isolatedScope.product.options[1].items[0].qty).not.toBe 0
      expect(isolatedScope.product.options[1].items[0].updateQty()).toBeUndefined()

    it "should set qty to zero / define function if multipleQty option type", ->

      $scope.menu[1].products[0].options[0].config = {multipleQty: true}
      $scope.menu[1].products[0].options[1].config = {multipleQty: true}

      isolatedScope.chooseProduct $scope.menu[1].products[0]


      expect(isolatedScope.product.options[0].items[0].qty).toBe 0
      expect(isolatedScope.product.options[0].items[1].qty).toBe 0
      expect(isolatedScope.product.options[0].items[0].updateQty()).toBeDefined()
      expect(isolatedScope.product.options[0].items[1].updateQty()).toBeDefined()

      expect(isolatedScope.product.options[1].items[0].qty).toBe 0
      expect(isolatedScope.product.options[1].items[0].updateQty()).toBeDefined()