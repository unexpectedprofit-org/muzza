describe 'Product Options Directive', ->

  beforeEach ->

    module 'Muzza.product'
    module 'Muzza.templates'
    module 'Muzza.directives'


  describe "selectOptionAndRecalculatePrice functionality", ->

    isolatedScope = undefined

    describe "product with one option", ->

      describe "and single selection", ->

        beforeEach ->
          inject ($compile, $rootScope) ->
            $scope = $rootScope
            $scope.product =
              id:1
              description: "Aquarius 500 cc"
              price:
                base: 2000
              options: [
                description: "Sabor"
                config:
                  min: 1
                  max:1
                items: [
                  description: "Naranja"
                  price: 0
                ,
                  description: "Pomelo"
                  price: 99
                ,
                  description: "Manzana"
                  price: 0
                ]
              ]

            element = angular.element('<product-options data-ng-model="product"></product-options>')
            $compile(element)($rootScope)
            $scope.$digest()
            isolatedScope = element.isolateScope()

        it "should show same price if no additional price", ->

          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
          expect(isolatedScope.productTotalPrice).toBe 2000

          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[2]
          expect(isolatedScope.productTotalPrice).toBe 2000

        it "should update product price if item selection has additional price", ->

          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[1]
          expect(isolatedScope.productTotalPrice).toBe 2099

      describe "and multiple selection", ->

        beforeEach ->
          inject ($compile, $rootScope) ->
            $scope = $rootScope
            $scope.product =
              id:1
              description: "Ensalada de la casa"
              price:
                base:8500
              options: [
                config:
                  min:1
                  max:3
                items: [
                  description: "Lechuga"
                  price: 55
                ,
                  description: "Tomate"
                  price: 0
                ,
                  description: "Hongos"
                  price: 30
                ,
                  description: "Zanahoria"
                  price: 0
                ]
              ]

            element = angular.element('<product-options data-ng-model="product"></product-options>')
            $compile(element)($rootScope)
            $scope.$digest()
            isolatedScope = element.isolateScope()

        it "should show same price if no additional price - only one selection", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[1]
          expect(isolatedScope.productTotalPrice).toBe 8500

        it "should show same price if no additional price - more than one selection", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[1]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[3]
          expect(isolatedScope.productTotalPrice).toBe 8500

        it "should update product price if item selection has additional price - only one selection", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
          expect(isolatedScope.productTotalPrice).toBe 8555

        it "should update product price if item selection has additional price - more than one selection", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[2]
          expect(isolatedScope.productTotalPrice).toBe 8585


    describe "product with multiple options", ->

      describe "and all options are single selection", ->

        beforeEach ->
          inject ($compile, $rootScope) ->
            $scope = $rootScope
            $scope.product =
              id:1
              description:"SANDWICH CALIENTE DE LOMITO CON PAPAS FRITAS"
              price:
                base:3000
              options: [
                description: "Pan"
                config:
                  min: 1
                  max:1
                items: [
                  description: "Baguette"
                  price: 0
                ,
                  description: "Frances"
                  price: 0
                ,
                  description: "Arabe Salvado"
                  price: 30
                ]
              ,
                description: "Tipo de Papas fritas"
                config:
                  min: 1
                  max:1
                items: [
                  description: "Baston"
                  price: 10
                ,
                  description: "Pay"
                  price: 0
                ,
                  description: "Rejilla"
                  price: 25
                ]
              ]

            element = angular.element('<product-options data-ng-model="product"></product-options>')
            $compile(element)($rootScope)
            $scope.$digest()
            isolatedScope = element.isolateScope()

        it "should show same price if no additional price", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[1]
          expect(isolatedScope.productTotalPrice).toBe 3000

        it "should update product price if item selection has additional price", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[2]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[2]
          expect(isolatedScope.productTotalPrice).toBe 3055

      describe "and options are single and multiple selection", ->

        beforeEach ->
          inject ($compile, $rootScope) ->
            $scope = $rootScope
            $scope.product =
              id:1
              description:"SANDWICH CALIENTE DE LOMITO CON PAPAS FRITAS"
              price:
                base:6000
              options: [
                description: "Pan"
                config:
                  min: 1
                  max:1
                items: [
                  description: "Baguette"
                  price: 0
                ,
                  description: "Frances"
                  price: 0
                ,
                  description: "Arabe Salvado"
                  price: 30
                ]
              ,
                description: "Adicionales"
                config:
                  min: 1
                  max:3
                items: [
                  description: "Huevo Frito"
                  price: 40
                ,
                  description: "Jamon"
                  price: 0
                ,
                  description: "Tomate"
                  price: 10
                ,
                  description: "Lechuga"
                  price: 0
                ]
              ]

            element = angular.element('<product-options data-ng-model="product"></product-options>')
            $compile(element)($rootScope)
            $scope.$digest()
            isolatedScope = element.isolateScope()

        it "should show same price if no additional price", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[1]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[3]
          expect(isolatedScope.productTotalPrice).toBe 6000

        it "should update product price if item selection has additional price", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[2]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[0]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[2]
          expect(isolatedScope.productTotalPrice).toBe 6080


  describe "isSelectionValid functionality", ->

    isolatedScope = undefined

    describe "product with one option", ->

      describe "and single selection", ->

        beforeEach ->
          inject ($compile, $rootScope) ->
            $scope = $rootScope
            $scope.product =
              id:1
              price:10
              description: "Aquarius 500 cc"
              options: [
                description: "Sabor"
                config:
                  min: 1
                  max:1
                items: [
                  description: "Naranja"
                ,
                  description: "Pomelo"
                ,
                  description: "Manzana"
                ]
              ]

            element = angular.element('<product-options data-ng-model="product"></product-options>')
            $compile(element)($rootScope)
            $scope.$digest()
            isolatedScope = element.isolateScope()

        it "should NOT validate if no selection done", ->
          expect(isolatedScope.isSelectionValid()).toBeFalsy()
          expect(isolatedScope.productSelected.options[0].selectionValid.status).toBeFalsy()
          expect(isolatedScope.productSelected.options[0].selectionValid.error).toEqual "OPTION_ERROR_NO_SELECTION"


        it "should validate if selection done", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]

          expect(isolatedScope.isSelectionValid()).toBeTruthy()
          expect(isolatedScope.productSelected.options[0].selectionValid.status).toBeTruthy()
          expect(isolatedScope.productSelected.options[0].selectionValid.error).toBeUndefined()


      describe "and multiple selection", ->

        beforeEach ->
          inject ($compile, $rootScope) ->
            $scope = $rootScope
            $scope.product =
              id:1
              price:10
              description: "Ensalada"
              options: [
                description: "Ingredientes"
                config:
                  min: 2
                  max:4
                items: [
                  description: "Tomate"
                ,
                  description: "Lechuga"
                ,
                  description: "Zanahoria"
                ,
                  description: "Huevo"
                ,
                  description: "Cebolla"
                ]
              ]

            element = angular.element('<product-options data-ng-model="product"></product-options>')
            $compile(element)($rootScope)
            $scope.$digest()
            isolatedScope = element.isolateScope()

        it "should NOT validate if no selection done", ->
          expect(isolatedScope.isSelectionValid()).toBeFalsy()
          expect(isolatedScope.productSelected.options[0].selectionValid.status).toBeFalsy()
          expect(isolatedScope.productSelected.options[0].selectionValid.error).toEqual "OPTION_ERROR_NO_SELECTION"

        it "should NOT validate if number of items less than min", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[3]

          expect(isolatedScope.isSelectionValid()).toBeFalsy()
          expect(isolatedScope.productSelected.options[0].selectionValid.status).toBeFalsy()
          expect(isolatedScope.productSelected.options[0].selectionValid.error).toEqual "OPTION_ERROR_MIN"
          expect(isolatedScope.productSelected.options[0].selectionValid.params.min).toEqual 2

        it "should NOT validate if number of items more than max - 5 items", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[1]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[2]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[3]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[4]

          expect(isolatedScope.isSelectionValid()).toBeFalsy()
          expect(isolatedScope.productSelected.options[0].selectionValid.status).toBeFalsy()
          expect(isolatedScope.productSelected.options[0].selectionValid.error).toEqual "OPTION_ERROR_MAX"
          expect(isolatedScope.productSelected.options[0].selectionValid.params.max).toEqual 4

        it "should validate if number of items between min and max - 2 items", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[1]

          expect(isolatedScope.isSelectionValid()).toBeTruthy()
          expect(isolatedScope.productSelected.options[0].selectionValid.status).toBeTruthy()
          expect(isolatedScope.productSelected.options[0].selectionValid.error).toBeUndefined()

        it "should validate if number of items between min and max - 3 items", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[1]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[2]

          expect(isolatedScope.isSelectionValid()).toBeTruthy()
          expect(isolatedScope.productSelected.options[0].selectionValid.status).toBeTruthy()
          expect(isolatedScope.productSelected.options[0].selectionValid.error).toBeUndefined()

        it "should validate if number of items between min and max - 4 items", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[1]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[2]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[3]

          expect(isolatedScope.isSelectionValid()).toBeTruthy()
          expect(isolatedScope.productSelected.options[0].selectionValid.status).toBeTruthy()
          expect(isolatedScope.productSelected.options[0].selectionValid.error).toBeUndefined()


    describe "product with multiple options", ->

      describe "and all single selection", ->

        beforeEach ->
          inject ($compile, $rootScope) ->
            $scope = $rootScope
            $scope.product =
              id:1
              price:10
              description: "Sandwich de Milanesa"
              options: [
                description: "Tipo de Pan"
                config:
                  min: 1
                  max:1
                items: [
                  description: "Blanco"
                ,
                  description: "Salvado"
                ]
              ,
                description: "Guarnicion"
                config:
                  min: 1
                  max:1
                items: [
                  description: "Papas Fritas"
                ,
                  description: "Pure de papas"
                ,
                  description: "Ensalada"
                ]
              ]

            element = angular.element('<product-options data-ng-model="product"></product-options>')
            $compile(element)($rootScope)
            $scope.$digest()
            isolatedScope = element.isolateScope()

        it "should NOT validate if no selection done", ->
          expect(isolatedScope.isSelectionValid()).toBeFalsy()

          expect(isolatedScope.productSelected.options[0].selectionValid.status).toBeFalsy()
          expect(isolatedScope.productSelected.options[0].selectionValid.error).toEqual "OPTION_ERROR_NO_SELECTION"

          expect(isolatedScope.productSelected.options[1].selectionValid.status).toBeFalsy()
          expect(isolatedScope.productSelected.options[1].selectionValid.error).toEqual "OPTION_ERROR_NO_SELECTION"

        it "should NOT validate if some selection done", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]

          expect(isolatedScope.isSelectionValid()).toBeFalsy()

          expect(isolatedScope.productSelected.options[0].selectionValid.status).toBeTruthy()
          expect(isolatedScope.productSelected.options[0].selectionValid.error).toBeUndefined()

          expect(isolatedScope.productSelected.options[1].selectionValid.status).toBeFalsy()
          expect(isolatedScope.productSelected.options[1].selectionValid.error).toEqual "OPTION_ERROR_NO_SELECTION"

        it "should validate if all selection done", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[1]

          expect(isolatedScope.isSelectionValid()).toBeTruthy()

          expect(isolatedScope.productSelected.options[0].selectionValid.status).toBeTruthy()
          expect(isolatedScope.productSelected.options[0].selectionValid.error).toBeUndefined()

          expect(isolatedScope.productSelected.options[1].selectionValid.status).toBeTruthy()
          expect(isolatedScope.productSelected.options[1].selectionValid.error).toBeUndefined()

      describe "and multiple selection", ->

        beforeEach ->
          inject ($compile, $rootScope) ->
            $scope = $rootScope
            $scope.product =
              id:1
              price:10
              description: "Sandwich de Milanesa"
              options: [
                description: "Otros"
                config:
                  min: 1
                  max:2
                items: [
                  description: "Algo"
                ,
                  description: "Otra cosa"
                ]
              ,
                description: "Adicionales"
                config:
                  min: 0
                  max:2
                items: [
                  description: "Jamon"
                ,
                  description: "Queso"
                ,
                  description: "Huevo"
                ,
                  description: "Morron"
                ]
              ]

            element = angular.element('<product-options data-ng-model="product"></product-options>')
            $compile(element)($rootScope)
            $scope.$digest()
            isolatedScope = element.isolateScope()

        it "should NOT validate if not all options validate - first option", ->
          expect(isolatedScope.isSelectionValid()).toBeFalsy()

          expect(isolatedScope.productSelected.options[0].selectionValid.status).toBeFalsy()
          expect(isolatedScope.productSelected.options[0].selectionValid.error).toEqual "OPTION_ERROR_NO_SELECTION"

          expect(isolatedScope.productSelected.options[1].selectionValid.status).toBeTruthy()

        it "should NOT validate if not all options validate - second option", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]

          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[0]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[1]
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[2]

          expect(isolatedScope.isSelectionValid()).toBeFalsy()

          expect(isolatedScope.productSelected.options[0].selectionValid.status).toBeTruthy()

          expect(isolatedScope.productSelected.options[1].selectionValid.status).toBeFalsy()
          expect(isolatedScope.productSelected.options[1].selectionValid.error).toEqual "OPTION_ERROR_MAX"
          expect(isolatedScope.productSelected.options[1].selectionValid.params.max).toEqual 2

        it "should validate if selection done on first option only", ->
          isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]

          expect(isolatedScope.isSelectionValid()).toBeTruthy()

          expect(isolatedScope.productSelected.options[0].selectionValid.status).toBeTruthy()
          expect(isolatedScope.productSelected.options[0].selectionValid.error).toBeUndefined()

          expect(isolatedScope.productSelected.options[1].selectionValid.status).toBeTruthy()
          expect(isolatedScope.productSelected.options[1].selectionValid.error).toBeUndefined()


  describe "addProductSelectionToCart" , ->

    broadcastSpy = isolatedScope = undefined

    beforeEach ->
      inject ($compile, $rootScope) ->
        $scope = $rootScope
        $scope.product =
          id:1
          price:10
          description: "Aquarius 500 cc"
          options: [
            description: "Sabor"
            config:
              min: 1
              max:1
            items: [
              description: "Naranja"
            ,
              description: "Pomelo"
            ,
              description: "Manzana"
            ]
          ]

        broadcastSpy = spyOn($rootScope, '$broadcast')

        element = angular.element('<product-options data-ng-model="product"></product-options>')
        $compile(element)($rootScope)
        $scope.$digest()
        isolatedScope = element.isolateScope()


    it "should broadcast event if selection is valid", ->
      isolatedScope.selectOptionAndRecalculatePrice isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
      isolatedScope.addProductSelectionToCart isolatedScope.productSelected

      expect(broadcastSpy).toHaveBeenCalledWith 'PRODUCT_SELECTED_TO_BE_ADDED_TO_CART', isolatedScope.productSelected

    it "should NOT broadcast event if selection not valid", ->
      isolatedScope.addProductSelectionToCart isolatedScope.productSelected

      expect(broadcastSpy).not.toHaveBeenCalled()