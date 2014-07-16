describe 'Product Options Directive', ->

  beforeEach ->
    module 'Muzza.product'
    module 'Muzza.templates'
    module 'Muzza.directives'

  Product = undefined

  beforeEach ->
    inject ($injector) ->
      Product = $injector.get 'Product'


  describe "init", ->

    it "should have option type checks to display appropiate sections", ->
      inject ($compile, $rootScope) ->
        $scope = $rootScope
        $scope.product = new Product
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
            ]
          ]

        element = angular.element('<product-options data-ng-model="product"></product-options>')
        $compile(element)($rootScope)
        $scope.$digest()
        isolatedScope = element.isolateScope()

        expect(element.html()).toContain "option.type == 'SINGLE'"
        expect(element.html()).toContain "option.type == 'MULTIPLE'"
        expect(element.html()).toContain "option.type == 'MULTIPLE_QTY'"


  describe "selectOption functionality", ->

    isolatedScope = undefined

    describe "product with one option", ->

      describe "and single selection", ->

        beforeEach ->
          inject ($compile, $rootScope) ->
            $scope = $rootScope
            $scope.product = new Product
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

        describe "when add product selection and selected options is empty", ->

          it "should add selected itm", ->

            isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
            expect(isolatedScope.productSelected.options[0].selection).toContain jasmine.objectContaining {description:"Naranja"}

        describe "when add product selection and selected options has a previous selected item", ->

          it "should replace the item for the selected one", ->

            isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
            isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[2]
            expect(isolatedScope.productSelected.options[0].selection).toContain jasmine.objectContaining {description:"Manzana"}



      describe "and multiple selection", ->

        beforeEach ->
          inject ($compile, $rootScope) ->
            $scope = $rootScope
            $scope.product = new Product
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

        it "should add product selection", ->
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[1]
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[2]
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[3]

          expect(isolatedScope.productSelected.options[0].selection).toContain jasmine.objectContaining {description:"Tomate"}
          expect(isolatedScope.productSelected.options[0].selection).toContain jasmine.objectContaining {description:"Hongos"}
          expect(isolatedScope.productSelected.options[0].selection).toContain jasmine.objectContaining {description:"Zanahoria"}


    describe "product with multiple options", ->

      describe "and all options are single selection", ->

        beforeEach ->
          inject ($compile, $rootScope) ->
            $scope = $rootScope
            $scope.product = new Product
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


        describe "and selection is so far empty", ->

          it "should add product selection", ->

            isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
            expect(isolatedScope.productSelected.options[0].selection).toContain jasmine.objectContaining {description:"Baguette"}

            isolatedScope.selectOption isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[2]
            expect(isolatedScope.productSelected.options[1].selection).toContain jasmine.objectContaining {description:"Rejilla"}

        describe "and selection is not empty", ->

          it "should add product selection", ->

            isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
            isolatedScope.selectOption isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[2]
            isolatedScope.selectOption isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[1]
            expect(isolatedScope.productSelected.options[1].selection).toContain jasmine.objectContaining {description:"Pay"}


      describe "and options are single and multiple selection", ->

        beforeEach ->
          inject ($compile, $rootScope) ->
            $scope = $rootScope
            $scope.product = new Product
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

        it "should add product selection", ->
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
          expect(isolatedScope.productSelected.options[0].selection).toContain jasmine.objectContaining {description:"Baguette"}

          isolatedScope.selectOption isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[1]
          isolatedScope.selectOption isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[3]
          expect(isolatedScope.productSelected.options[1].selection).toContain jasmine.objectContaining {description:"Jamon"}
          expect(isolatedScope.productSelected.options[1].selection).toContain jasmine.objectContaining {description:"Lechuga"}


  describe "isSelectionValid", ->

    isolatedScope = undefined

    describe "when a product with one option", ->

      describe "and single selection", ->

        beforeEach ->
          inject ($compile, $rootScope) ->
            $scope = $rootScope
            $scope.product = new Product
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
          expect(isolatedScope.productSelected.options[0].selectionError).toEqual "OPTION_ERROR_NO_SELECTION"


        it "should validate if selection done", ->
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]

          expect(isolatedScope.isSelectionValid()).toBeTruthy()
          expect(isolatedScope.productSelected.options[0].selectionError).toBeUndefined()


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
          expect(isolatedScope.productSelected.options[0].selectionError).toEqual "OPTION_ERROR_NO_SELECTION"

        it "should NOT validate if number of items less than min", ->
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[3]

          expect(isolatedScope.isSelectionValid()).toBeFalsy()
          expect(isolatedScope.productSelected.options[0].selectionError).toEqual "OPTION_ERROR_MIN"

        it "should NOT validate if number of items more than max - 5 items", ->
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[1]
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[2]
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[3]
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[4]

          expect(isolatedScope.isSelectionValid()).toBeFalsy()
          expect(isolatedScope.productSelected.options[0].selectionError).toEqual "OPTION_ERROR_MAX"

        it "should validate if number of items between min and max - 2 items", ->
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[1]

          expect(isolatedScope.isSelectionValid()).toBeTruthy()
          expect(isolatedScope.productSelected.options[0].selectionError).toBeUndefined()

        it "should validate if number of items between min and max - 3 items", ->
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[1]
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[2]

          expect(isolatedScope.isSelectionValid()).toBeTruthy()
          expect(isolatedScope.productSelected.options[0].selectionError).toBeUndefined()

        it "should validate if number of items between min and max - 4 items", ->
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[1]
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[2]
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[3]

          expect(isolatedScope.isSelectionValid()).toBeTruthy()
          expect(isolatedScope.productSelected.options[0].selectionError).toBeUndefined()


    describe "when a product with multiple options", ->

      describe "and all its options require a single selection", ->

        beforeEach ->
          inject ($compile, $rootScope) ->
            $scope = $rootScope
            $scope.product = new Product
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

        it "should fail validation if no selection is done", ->
          expect(isolatedScope.isSelectionValid()).toBeFalsy()

          expect(isolatedScope.productSelected.options[0].selectionError).toEqual "OPTION_ERROR_NO_SELECTION"
          expect(isolatedScope.productSelected.options[1].selectionError).toEqual "OPTION_ERROR_NO_SELECTION"

        it "should fail validation if some selection is done but not all", ->
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]

          expect(isolatedScope.isSelectionValid()).toBeFalsy()

          expect(isolatedScope.productSelected.options[0].selectionError).toBeUndefined()
          expect(isolatedScope.productSelected.options[1].selectionError).toEqual "OPTION_ERROR_NO_SELECTION"

        it "should succeed validation if all selection done", ->
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
          isolatedScope.selectOption isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[1]

          expect(isolatedScope.isSelectionValid()).toBeTruthy()

          expect(isolatedScope.productSelected.options[0].selectionError).toBeUndefined()
          expect(isolatedScope.productSelected.options[1].selectionError).toBeUndefined()

      describe "and all its options require a multiple selection", ->

        beforeEach ->
          inject ($compile, $rootScope) ->
            $scope = $rootScope
            $scope.product = new Product
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

        it "should fail validation if first option does not validate succesfully", ->
          expect(isolatedScope.isSelectionValid()).toBeFalsy()
          expect(isolatedScope.productSelected.options[0].selectionError).toEqual "OPTION_ERROR_NO_SELECTION"

        it "should fail validation if second option does not validate succesfully", ->
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]

          isolatedScope.selectOption isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[0]
          isolatedScope.selectOption isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[1]
          isolatedScope.selectOption isolatedScope.productSelected.options[1], isolatedScope.productSelected.options[1].items[2]

          expect(isolatedScope.isSelectionValid()).toBeFalsy()

          expect(isolatedScope.productSelected.options[1].selectionError).toEqual "OPTION_ERROR_MAX"

        it "should succeed validation if first option is selected and second option is not (min=0)", ->
          isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]

          expect(isolatedScope.isSelectionValid()).toBeTruthy()

          expect(isolatedScope.productSelected.options[0].selectionError).toBeUndefined()
          expect(isolatedScope.productSelected.options[1].selectionError).toBeUndefined()


    describe "when a product with multiple options and multiple quantities", ->

      beforeEach ->
        inject ($compile, $rootScope) ->
          $scope = $rootScope
          $scope.product = new Product
            id:1
            price:10
            description: "Promo 1 docena de empanadas"
            options: [
              description: "Empanadas"
              config:
                min: 12
                max:12
                multipleQty:true
              items: [
                description: "Jamon y Queso"
                qty:0
              ,
                description: "Carne picante"
                qty:0
              ,
                description: "Pollo"
                qty:0
              ,
                description: "Verdura"
                qty:0
              ]
            ]

          element = angular.element('<product-options data-ng-model="product"></product-options>')
          $compile(element)($rootScope)
          $scope.$digest()
          isolatedScope = element.isolateScope()

      it "should fail validation if no selection is done", ->
        expect(isolatedScope.isSelectionValid()).toBeFalsy()
        expect(isolatedScope.productSelected.options[0].selectionError).toEqual "OPTION_ERROR_MIN_MAX"

      it "should fail validation if some selection is done but not all", ->
        isolatedScope.productSelected.options[0].items[0].qty = 4

        expect(isolatedScope.isSelectionValid()).toBeFalsy()
        expect(isolatedScope.productSelected.options[0].selectionError).toEqual "OPTION_ERROR_MIN_MAX"

      it "should succeed validation if all selection done", ->
        isolatedScope.productSelected.options[0].items[0].qty = 5
        isolatedScope.productSelected.options[0].items[1].qty = 1
        isolatedScope.productSelected.options[0].items[2].qty = 6

        expect(isolatedScope.isSelectionValid()).toBeTruthy()
        expect(isolatedScope.productSelected.options[0].selectionError).toBeUndefined()


  describe "addProductSelectionToCart" , ->

    broadcastSpy = isolatedScope = undefined

    beforeEach ->
      inject ($compile, $rootScope) ->
        $scope = $rootScope
        $scope.product = new Product
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
      isolatedScope.selectOption isolatedScope.productSelected.options[0], isolatedScope.productSelected.options[0].items[0]
      isolatedScope.addProductSelectionToCart isolatedScope.productSelected

      expect(broadcastSpy).toHaveBeenCalledWith 'PRODUCT_SELECTED_TO_BE_ADDED_TO_CART', isolatedScope.productSelected

    it "should NOT broadcast event if selection not valid", ->
      isolatedScope.addProductSelectionToCart isolatedScope.productSelected

      expect(broadcastSpy).not.toHaveBeenCalled()