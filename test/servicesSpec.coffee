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

    ShoppingCartService = undefined

    beforeEach ->
      inject ($injector) ->
        ShoppingCartService = $injector.get 'ShoppingCartService'

    it 'should get an initial empty cart', ->
      expect(ShoppingCartService.getCart().length).toBe 0
      expect(ShoppingCartService.getTotalPrice()).toBe 0

    it "should add product if not present", ->
      item =
        id: 1
        hash: "1-muzza-chica-alapiedra"
      ShoppingCartService.add item

      expect(ShoppingCartService.getCart().length).toBe 1
      expect(ShoppingCartService.getCart()[0]).toEqual item

      item =
        id: 2
        hash: "2-cebolla-grande-almolde"
      ShoppingCartService.add item

      expect(ShoppingCartService.getCart().length).toBe 2
      expect(ShoppingCartService.getCart()[1]).toEqual item


    it 'should NOT add product if already present', ->
      item =
        id: 5
        qty: 2
        hash: '5-humita-frita'
      ShoppingCartService.add item

      expect(ShoppingCartService.getCart().length).toBe 1
      expect(ShoppingCartService.getCart()[0]).toEqual item

      item =
        id: 5
        qty:3
        hash: '5-humita-frita'
      ShoppingCartService.add item

      expect(ShoppingCartService.getCart().length).toBe 1
      expect(ShoppingCartService.getCart()[0].qty).toBe 5

    it 'should return all items in the cart', ->
      ShoppingCartService.add {id: 1, hash:'1-alala'}
      ShoppingCartService.add {id: 2, hash:'2-jojojjo'}

      expect(ShoppingCartService.getCart().length).toBe 2

    it "should calculate total price, only one product", ->
      ShoppingCartService.add {id: 1, hash:'1-alala', qty: 2, totalPrice: 1000}

      expect(ShoppingCartService.getTotalPrice()).toBe 2000

    it "should calculate total price, several products", ->
      ShoppingCartService.add {id: 1, hash:'1-alala', qty: 2, totalPrice: 1000}
      ShoppingCartService.add {id: 2, hash:'2-alala', qty: 1, totalPrice: 2000}
      ShoppingCartService.add {id: 3, hash:'3-alala', qty: 3, totalPrice: 3000}

      expect(ShoppingCartService.getTotalPrice()).toBe 13000

    it "should remove specific item", ->
      product1 = {id: 1, hash:'1-alala', qty: 2, totalPrice: 1000}
      product2 = {id: 2, hash:'2-alala', qty: 1, totalPrice: 2000}
      product3 = {id: 3, hash:'3-alala', qty: 3, totalPrice: 3000}
      ShoppingCartService.add product1
      ShoppingCartService.add product2
      ShoppingCartService.add product3

      ShoppingCartService.remove product2.hash

      expect(ShoppingCartService.getCart().length).toBe 2
      expect(ShoppingCartService.getCart()).toContain product1
      expect(ShoppingCartService.getCart()).toContain product3

    it "should empty cart", ->
      ShoppingCartService.add {id: 1, hash:'1-alala', qty: 2, totalPrice: 1000}
      ShoppingCartService.add {id: 2, hash:'2-alala', qty: 1, totalPrice: 2000}
      ShoppingCartService.add {id: 3, hash:'3-alala', qty: 3, totalPrice: 3000}

      ShoppingCartService.emptyCart()

      expect(ShoppingCartService.getCart().length).toBe 0
      expect(ShoppingCartService.getTotalPrice()).toBe 0


  describe "Product Service", ->

    ProductService = undefined

    beforeEach ->
      inject(( _ProductService_ ) ->
        ProductService = _ProductService_
    )

    it "should get a menu of product objects", ->
      store =
        products:
          "empanada": [
            "id": 1,
            "desc": "Al Horno",
            "products": [
              "id": 1
              "desc": "Carne cortada a cuchillo"
              "toppings": [ "Carne", "Huevo", "Morron" ]
              "price": 1800
            ,
              "id": 2
              "desc": "Calabresa"
              "toppings": [ "Muzzarella", "Longaniza", "Salsa" ]
              "price": 1800
            ]
          ]
      spyOn(ProductService, 'listMenuByStore').and.returnValue store
      newMenuObject = ProductService.listMenuByStore 1
      expect( newMenuObject.products.empanada.length ).toBe 1
      expect( newMenuObject.products.empanada[0].products.length ).toBe 2


  describe "OrderService", ->
    OrderService = undefined

    beforeEach ->
      inject(( _OrderService_ ) ->
        OrderService = _OrderService_
    )

    it "should get an order details object", ->
      newMenuObject = OrderService.placeOrder {}
      expect( newMenuObject.number ).toBe "AXAHA263920"