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

  isolatedScope = undefined

  describe "init", ->

    Product = element = undefined

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
          ,
            id:10
          ]
        ]

        element = angular.element('<product data-ng-model="menu"></product>')
        $compile(element)($rootScope)
        $scope.$digest()
        isolatedScope = element.isolateScope()

    it "should display the 5 products listed on the menu", ->
      expect(element.find('ion-item').length).toBe 5
      expect(isolatedScope.menu[0].products.length).toBe 3
      expect(isolatedScope.menu[1].products.length).toBe 2

    it "should have a click function bound", ->
      onClickEvent = element.find('ion-item')[0].attributes['data-ng-click'].nodeValue

      expect(onClickEvent).toContain "chooseProduct(product)"

    it "should have functions defined in the scope", ->
      expect(isolatedScope.chooseProduct).toBeDefined()


  describe "setCurrentOptionsSelectedForDisplay functionality", ->

      it "should set values for only one single selection", ->
        inject ($compile, $rootScope) ->
          $scope = $rootScope
          $scope.menu = [
            id:1
            description: "Bebidas"
            products:[
              id:2
              options:[
                config:
                  min:1
                  max:1
                items:[
                  description:"Coca zero"
                ,
                  description:"Sprite"
                ]
                selection: [
                  description: 'Sprite'
                ]
              ]
            ]
          ]

          element = angular.element('<product data-ng-model="menu"></product>')
          $compile(element)($rootScope)
          $scope.$digest()
          isolatedScope = element.isolateScope()

          isolatedScope.setCurrentOptionsSelectedForDisplay $scope.menu[0].products[0]

          expect($scope.menu[0].products[0].options[0].items[0].isSelected).toBeFalsy()
          expect($scope.menu[0].products[0].options[0].items[1].isSelected).toBeTruthy()

      it "should set values for only one multiple selection", ->
        inject ($compile, $rootScope) ->
          $scope = $rootScope
          $scope.menu = [
            id:1
            description: "Bebidas"
            products:[
              id:2
              options:[
                config:
                  min:1
                  max:2
                items:[
                  description:"Pollo"
                ,
                  description:"Verdura"
                ,
                  description:"Ricota"

                ]
                selection: [
                  description:'Verdura'
                ,
                  description:'Pollo'
                ]
              ]
            ]
          ]

          element = angular.element('<product data-ng-model="menu"></product>')
          $compile(element)($rootScope)
          $scope.$digest()
          isolatedScope = element.isolateScope()

          isolatedScope.setCurrentOptionsSelectedForDisplay $scope.menu[0].products[0]

          expect($scope.menu[0].products[0].options[0].items[0].isSelected).toBeTruthy()
          expect($scope.menu[0].products[0].options[0].items[1].isSelected).toBeTruthy()
          expect($scope.menu[0].products[0].options[0].items[2].isSelected).toBeFalsy()

      it "should set values for one single + one multiple selection", ->
        inject ($compile, $rootScope) ->
          $scope = $rootScope
          $scope.menu = [
            id:1
            description: "Bebidas"
            products:[
              id:2
              options: [
                config:
                  min:1
                  max:1
                items:[
                  description:"Coca"
                ,
                  description:"Sprite"
                ,
                  description:"Fanta"
                ]
                selection:[
                  description:"Fanta"
                ]
              ,
                config:
                  min:1
                  max:3
                items:[
                  description:"Tomate"
                ,
                  description:"Lechuga"
                ,
                  description:"Huevo duro"
                ,
                  description:"Jamon"
                ,
                  description:"Queso"
                ]
                selection:[
                  description:"Tomate"
                ,
                  description:"Queso"
                ]
              ]
            ]
          ]

          element = angular.element('<product data-ng-model="menu"></product>')
          $compile(element)($rootScope)
          $scope.$digest()
          isolatedScope = element.isolateScope()

          isolatedScope.setCurrentOptionsSelectedForDisplay $scope.menu[0].products[0]

          expect($scope.menu[0].products[0].options[0].items[0].isSelected).toBeFalsy()
          expect($scope.menu[0].products[0].options[0].items[1].isSelected).toBeFalsy()
          expect($scope.menu[0].products[0].options[0].items[2].isSelected).toBeTruthy()

          expect($scope.menu[0].products[0].options[1].items[0].isSelected).toBeTruthy()
          expect($scope.menu[0].products[0].options[1].items[1].isSelected).toBeFalsy()
          expect($scope.menu[0].products[0].options[1].items[2].isSelected).toBeFalsy()
          expect($scope.menu[0].products[0].options[1].items[3].isSelected).toBeFalsy()
          expect($scope.menu[0].products[0].options[1].items[4].isSelected).toBeTruthy()