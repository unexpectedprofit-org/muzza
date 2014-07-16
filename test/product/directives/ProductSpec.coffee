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

  Product = element = isolatedScope = $scope = $ionicModal = undefined

  beforeEach ->
    inject ($compile, $rootScope, $injector) ->
      $ionicModal = $injector.get '$ionicModal'

      Product = $injector.get 'Product'
      $scope = $rootScope
      $scope.menu = [
        id:1
        description: "Bebidas"
        products:[
          new Product {id:2}
        ,
          new Product {id:3}
        ,
          new Product {id:4}
        ]
      ,
        id:2
        description:"Pastas"
        products:[
          new Product {
            id:9
            options:[
              config:
                multipleQty:false
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
              config: {}
            ]
          }
        ,
          new Product {id:10}
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


  describe "chooseProduct functionality", ->

    beforeEach ->
      inject ($injector) ->
        spyOn($ionicModal, 'fromTemplateUrl').and.callFake( () ->  then: (callback) -> callback(show: () -> {}) )
        isolatedScope.chooseProduct $scope.menu[1].products[0]


    it "should call clearSelection on product object ", ->
      expect(isolatedScope.product.options[0].selection).toBeUndefined()
      expect(isolatedScope.product.options[0].items[0].isSelected).toBeUndefined()
      expect(isolatedScope.product.options[0].items[1].isSelected).toBeUndefined()

      expect(isolatedScope.product.options[1].selection).toBeUndefined()
      expect(isolatedScope.product.options[1].items[0].isSelected).toBeUndefined()

    it "should set a product Type object in the scope", ->
      expect(isolatedScope.product instanceof Product).toBeTruthy()

    it "should NOT define a selection array", ->
      expect(isolatedScope.product.options[0].selection).toBeUndefined()
      expect(isolatedScope.product.options[1].selection).toBeUndefined()

    it "should NOT set qty to zero / define function if NO multipleQty option type", ->

      expect(isolatedScope.product.options[0].items[0].qty).not.toBe 0
      expect(isolatedScope.product.options[0].items[1].qty).not.toBe 0
      expect(isolatedScope.product.options[0].items[0].updateQty).toBeUndefined()
      expect(isolatedScope.product.options[0].items[1].updateQty).toBeUndefined()

      expect(isolatedScope.product.options[1].items[0].qty).not.toBe 0
      expect(isolatedScope.product.options[1].items[0].updateQty).toBeUndefined()


    describe "multipleQty option type", ->

      beforeEach ->
        inject ($rootScope, $compile) ->
          $scope = $rootScope
          $scope.menu = [
            id:2
            description:"Pastas"
            products:[
              new Product {
                id:9
                options:[
                  config:
                    multipleQty:true
                  selection: [{}]
                  items:[
                    id:999
                    isSelected:true
                  ,
                    id:888
                    isSelected:false
                  ]
                ]
              }
            ]
          ]

          element = angular.element('<product data-ng-model="menu"></product>')
          $compile(element)($rootScope)
          $scope.$digest()
          isolatedScope = element.isolateScope()

          isolatedScope.chooseProduct $scope.menu[0].products[0]


      it "should set qty to zero / define function", ->
        expect(isolatedScope.product.options[0].items[0].qty).toBe 0
        expect(isolatedScope.product.options[0].items[0].updateQty).toBeDefined()

      it "should define a selection array", ->
        expect(isolatedScope.product.options[0].selection[0].id).toBe 999
        expect(isolatedScope.product.options[0].selection[1].id).toBe 888