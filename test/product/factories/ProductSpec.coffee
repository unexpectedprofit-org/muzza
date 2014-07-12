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