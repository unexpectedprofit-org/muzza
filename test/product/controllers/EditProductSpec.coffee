describe "EditProductCtrl", ->

  beforeEach ->
    module 'ionic'
    module 'Muzza.product'

  scope = rootScope = createController = Product = undefined

  beforeEach ->
    inject ($controller, $rootScope, $injector)->
      Product = $injector.get 'Product'
      scope = $rootScope.$new()
      rootScope = $rootScope
      createController = (product)->
        $controller "EditProductCtrl",
          $scope: scope
          $rootScope: $rootScope
          product: product

  describe "setCurrentOptionsSelectedForDisplay", ->

    it "should set values for only one single selection", ->
      product = new Product
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

      createController product
      expect(scope.product.options[0].items[0].isSelected).toBeFalsy()
      expect(scope.product.options[0].items[1].isSelected).toBeTruthy()

    it "should set values for only one multiple selection", ->
      product = new Product
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

      createController product
      expect(scope.product.options[0].items[0].isSelected).toBeTruthy()
      expect(scope.product.options[0].items[1].isSelected).toBeTruthy()
      expect(scope.product.options[0].items[2].isSelected).toBeFalsy()

    it "should set values for one single + one multiple selection", ->
      product = new Product
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

      createController product
      expect(scope.product.options[0].items[0].isSelected).toBeFalsy()
      expect(scope.product.options[0].items[1].isSelected).toBeFalsy()
      expect(scope.product.options[0].items[2].isSelected).toBeTruthy()
      expect(scope.product.options[1].items[0].isSelected).toBeTruthy()
      expect(scope.product.options[1].items[1].isSelected).toBeFalsy()
      expect(scope.product.options[1].items[2].isSelected).toBeFalsy()
      expect(scope.product.options[1].items[3].isSelected).toBeFalsy()
      expect(scope.product.options[1].items[4].isSelected).toBeTruthy()

    it "should set values for multipleQty option type", ->
      product = new Product
        id:2
        options:[
          config:
            min:3
            max:3
            multipleQty:true
          items:[
            description:"Pollo"
          ,
            description:"Verdura"
          ,
            description:"Ricota"
          ]
          selection: [
            description:'Verdura'
            qty:2
          ,
            description:'Pollo'
            qty:1
          ]
        ]

      createController product

      expect(scope.product.options[0].items[0].isSelected).toBeTruthy()
      expect(scope.product.options[0].items[0].qty).toBe 1

      expect(scope.product.options[0].items[1].isSelected).toBeTruthy()
      expect(scope.product.options[0].items[1].qty).toBe 2

      expect(scope.product.options[0].items[2].isSelected).toBeFalsy()
      expect(scope.product.options[0].items[2].qty).toBe 0