describe "services", ->

  beforeEach ->
    module "Muzza.services"

  describe "store service", ->
    StoreService = undefined

    beforeEach ->
      inject ($injector) ->
        StoreService = $injector.get 'StoreService'

    it "should create a list of store objects", ->

#      jasmine.getJSONFixtures().fixturesPath = 'test/fixtures'
#      dataResponse = getJSONFixture('store.json')

      expected = {
        name: "La pizzeria de Juancho"
        address: "Av. Rivadavia 5100 - Caballito (Capital Federal)"
        tel: "4444 5555 / 1111 2222 / 15 4444 9999"
      }

      newObject = StoreService.listStores()
      expect( newObject[0].name ).toBe expected.name
      expect( newObject[0].address).toBe expected.address
      expect( newObject[0].tel ).toBe expected.tel

  describe 'ShoppingCart Service', ->

    ShoppingCart = undefined

    beforeEach ->
      inject ($injector) ->
        ShoppingCart = $injector.get 'ShoppingCart'

    it 'should add product if not present', ->
      item =
        id: 1
        hash: "1-muzza-chica-alapiedra"
      ShoppingCart.addToCart(item)

      expect(ShoppingCart.getCart().length).toBe 1
      expect(ShoppingCart.getCart()[0]).toEqual(item)

      item =
        id: 2
        hash: "2-cebolla-grande-almolde"
      ShoppingCart.addToCart(item)

      expect(ShoppingCart.getCart().length).toBe 2
      expect(ShoppingCart.getCart()[1]).toEqual(item)


    it 'should NOT add product if already present', ->
      item =
        id: 5
        qty: 2
        hash: '5-humita-frita'
      ShoppingCart.addToCart(item)

      expect(ShoppingCart.getCart().length).toBe 1
      expect(ShoppingCart.getCart()[0]).toEqual(item)

      item =
        id: 5
        qty:3
        hash: '5-humita-frita'
      ShoppingCart.addToCart(item)

      expect(ShoppingCart.getCart().length).toBe 1
      expect(ShoppingCart.getCart()[0].qty).toBe 5


    it 'should return all items in the cart', ->
      ShoppingCart.addToCart({id: 1, hash:'1-alala'})
      ShoppingCart.addToCart({id: 2, hash:'2-jojojjo'})
      cart = ShoppingCart.getCart()
      expect(cart.length).toBe 2

  describe "Product Service", ->

    ProductService = undefined

    beforeEach ->
      inject(( _ProductService_ ) ->
        ProductService = _ProductService_
    )

    it "should get a menu of product objects", ->

      newMenuObject = ProductService.listMenuByStore 1
      expect( newMenuObject.products.pizza.length ).toBe 4
      expect( newMenuObject.products.empanada.length ).toBe 2
      expect( newMenuObject.products.empanada[0].prod.length ).toBe 6
      expect( newMenuObject.products.empanada[1].prod.length ).toBe 3

      newMenuObject = ProductService.listMenuByStore 2
      expect( newMenuObject.products.pizza.length ).toBe 3
      expect( newMenuObject.products.empanada.length ).toBe 2
      expect( newMenuObject.products.empanada[0].prod.length ).toBe 4
      expect( newMenuObject.products.empanada[1].prod.length ).toBe 3

  describe "OrderService", ->
    OrderService = undefined

    beforeEach ->
      inject(( _OrderService_ ) ->
        OrderService = _OrderService_
    )

    it "should get an order details object", ->
      newMenuObject = OrderService.placeOrder {}
      expect( newMenuObject.number ).toBe "AXAHA263920"