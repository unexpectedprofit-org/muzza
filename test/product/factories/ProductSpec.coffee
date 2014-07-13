describe 'Product Factory', ->

  Product = undefined

  beforeEach ->
    module 'Muzza.product'

  beforeEach ->
    inject ($injector) ->
      Product = $injector.get 'Product'


  describe 'constructor', ->

    it 'should construct a Product model from param - case 1', ->
      param =
        id: 8099
        description: 'Product name here'
        catId: 44
        qty: 2
        price:
          base: 50

      product = new Product param
      expect(product.id).toBe param.id
      expect(product.description).toBe param.description
      expect(product.categoryId).toBe param.catId
      expect(product.qty).toBe param.qty
      expect(product.price.base).toBe param.price.base
      expect(product.totalPrice).toBe param.price.base

    it 'should construct a Product model from param - case 2', ->
      param =
        id: 8099
        catId: 44
        other:"thing"

      product = new Product param
      expect(product.id).toBe param.id
      expect(product.description).toBe ''
      expect(product.categoryId).toBe param.catId
      expect(product.qty).toBe 1
      expect(product.price).toBe undefined
      expect(product.totalPrice).toBe undefined
      expect(product.other).toBe param.other

    it 'should have functions defined', ->
      product = new Product {}
      expect(product.getDescription).toBeDefined()
      expect(product.updateQty).toBeDefined()
      expect(product.getHash).toBeDefined()
      expect(product.reset).toBeDefined()
      expect(product.isEditable()).toBeDefined()


  describe "isEditable functionality", ->

    it 'should always have qty editable as true', ->
      param =
        id: 8099
        description: 'Product name here'
        catId: 44
        qty: 2
        price:
          base: 50

      product = new Product param
      expect(product.isEditable().qty).toBeTruthy()

    it 'should have options NOT editable if no options', ->
      param =
        id: 8099
        catId: 44
        other:"thing"

      product = new Product param
      expect(product.isEditable().options).toBeFalsy()

    it 'should construct a Product model from param - case 3', ->
      param =
        id: 8099
        catId: 44
        other:"thing"

      product = new Product param

      product.options = []
      product.options.push {selection:[{'naranja'}]}

      expect(product.isEditable().options).toBeTruthy()


  describe "getHash functionality", ->

    it "should generate hash - no selection", ->

      param =
        id: 8099
        catId: 44
        price:
          base: 50

      product = new Product param

      expect(product.getHash()).toEqual "ID_BRAND|ID:" + param.id + "|CAT_ID:" + param.catId + "|"

    it "should generate hash - single selection", ->

      param =
        id: 8099
        catId: 44
        price:
          base: 50
        options: [
          description: "Sabor"
          selection: [
            description: "Naranja"
          ]
        ]

      product = new Product param

      expected = "ID_BRAND|ID:" + param.id + "|CAT_ID:" + param.catId + "|"
      expected += "OPT:" + param.options[0].description + '|'
      expected += param.options[0].selection[0].description + '|'

      expect(product.getHash()).toEqual expected

    it "should generate hash - single selection + multiple selection", ->

      param =
        id: 777
        description: 'Product name here'
        catId: 33
        qty: 2
        price:
          base: 50
        options: [
          description: "Pan"
          selection: [
            description: "Salvado"
          ]
        ,
          description: "Adicionales"
          selection: [
            description: "Tomate"
          ,
            description: "Lechuga"
          ,
            description: "Queso"
          ]
        ]

      product = new Product param

      expected = "ID_BRAND|ID:" + param.id + "|CAT_ID:" + param.catId + "|"
      expected += "OPT:" + param.options[0].description + '|'
      expected += param.options[0].selection[0].description + '|'
      expected += "OPT:" + param.options[1].description + '|'
      expected += param.options[1].selection[0].description + '|'
      expected += param.options[1].selection[1].description + '|'
      expected += param.options[1].selection[2].description + '|'

      expect(product.getHash()).toEqual expected


  describe "getDetails functionality", ->

    it "should generate hash - no selection", ->

      param =
        id: 8099
        catId: 44
        price:
          base: 50

      product = new Product param

      expect(product.getDetails()).toEqual ''

    it "should generate hash - single selection", ->

      param =
        id: 8099
        catId: 44
        price:
          base: 50
        options: [
          description: "Sabor"
          selection: [
            description: "Naranja"
          ]
        ]

      product = new Product param

      expect(product.getDetails()).toEqual "Sabor: Naranja/||"

    it "should generate hash - single selection + multiple selection", ->

      param =
        id: 777
        catId: 33
        qty: 2
        price:
          base: 50
        options: [
          description: "Pan"
          selection: [
            description: "Salvado"
          ]
        ,
          description: "Adicionales"
          selection: [
            description: "Tomate"
          ,
            description: "Lechuga"
          ,
            description: "Queso"
          ]
        ]

      product = new Product param

      expect(product.getDetails()).toEqual "Pan: Salvado/||Adicionales: Tomate/Lechuga/Queso/||"


  describe "calculateTotalPrice functionality", ->

    it "should be zero if no base price", ->
      product = new Product {id:2}

      expect(product.calculateTotalPrice()).toBe 0

    it "should get base price if no options selected", ->
      product = new Product {id:2, price:{base:50}}

      expect(product.calculateTotalPrice()).toBe 50

    it "should get calculated price when options selected - only one single selection", ->

      param =
        id:2
        price:
          base: 100
        options: [
          selection:[
            price:20
          ]
        ]
      product = new Product param

      expect(product.calculateTotalPrice()).toBe 120

    it "should get calculated price when options selected - only one multiple selection", ->

      param =
        id:2
        price:
          base: 100
        options: [
          selection:[
            price:20
          ,
            price:0
          ,
            price:30
          ]
        ]
      product = new Product param

      expect(product.calculateTotalPrice()).toBe 150

    it "should get calculated price when options selected - single selection + multiple selection", ->

      param =
        id:2
        price:
          base: 100
        options: [
          selection:[
            price:20
          ]
        ,
          selection: [
            price:10
          ,
            price:0
          ,
            price:20
          ,
            price:5
          ]
        ]
      product = new Product param

      expect(product.calculateTotalPrice()).toBe 155