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

    it "should generate hash", ->

      param =
        id: 8099
        description: 'Product name here'
        catId: 44
        qty: 2
        price:
          base: 50

      product = new Product param

      expect(product.getHash()).toEqual "ID_BRAND|" + param.id + "|" + param.catId + "|"