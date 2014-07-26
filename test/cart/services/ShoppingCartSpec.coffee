describe 'ShoppingCart Service', ->

  beforeEach ->
    module 'Muzza.cart'
    module 'Muzza.product'
    module 'Muzza.promo'

    module ($provide) ->
      $provide.value 'StoreService',
        retrieveSelectedStore: ()-> null
      $provide.value 'Delivery',
        retrieveDelivery: ()-> null
      $provide.value 'Contact',
        retrieveConnectionInfo: ()-> null
      $provide.value 'OrderService',
        createOrder: ()-> null


      null

  ShoppingCartService = Product = undefined

  beforeEach ->
    inject ($injector) ->
      ShoppingCartService = $injector.get 'ShoppingCartService'
      Product = $injector.get 'Product'

  it 'should get an initial empty cart', ->
    expect(ShoppingCartService.getCart().length).toBe 0
    expect(ShoppingCartService.getTotalPrice()).toBe 0


  describe "add functionality", ->

    it "should add product if not present", ->
      item = new Product {id:1,desc:'Pollo',type:'Frita',qty:2}
      ShoppingCartService.add item

      expect(ShoppingCartService.getCart().length).toBe 1
      expect(ShoppingCartService.getCart()[0]).toEqual item

      item = new Product {id:2,desc:'Humita',type:'Frita',qty:6}
      ShoppingCartService.add item
      addedItem = ShoppingCartService.getCart()[1]

      expect(ShoppingCartService.getCart().length).toBe 2
      expect(addedItem).toEqual item
      expect(addedItem.cartItemKey).toBeDefined()
      expect(addedItem.cartItemKey).toBe 'cart_2'

    it "should replace product if product is already in the cart", ->
#      Create product
      item = new Product {id:1,desc:'Pollo',type:'Frita',qty:2}
      ShoppingCartService.add item

#      edit product
      editedItem  = ShoppingCartService.get item.cartItemKey
      editedItem.updateQty(+1)

      ShoppingCartService.add editedItem
      updatedItem = ShoppingCartService.getCart()[0]
      expect(updatedItem.qty).toBe 3
      expect(ShoppingCartService.getCart().length).toBe 1

  describe "retrieve functionality", ->

    it 'should return all items in the cart', ->
      item1 = new Product {id:12,desc:'Pollo',type:'Frita'}
      item2 = new Product {id:13,desc:'Carne',type:'Horno'}
      ShoppingCartService.add item1
      ShoppingCartService.add item2

      expect(ShoppingCartService.getCart().length).toBe 2
      expect(ShoppingCartService.getCart()).toContain item1
      expect(ShoppingCartService.getCart()).toContain item2

    it "should return specific item", ->
      item1 = new Product {id:15,desc:'Pollo',type:'Frita'}
      item2 = new Product {id:16,desc:'Carne suave',type:'Horno'}
      item3 = new Product {id:17,desc:'Cebolla y Queso',type:'Frita'}

      ShoppingCartService.add item1
      ShoppingCartService.add item2
      ShoppingCartService.add item3

      expect(ShoppingCartService.get( item2.cartItemKey )).toEqual item2


  describe "remove functionality", ->

    it "should remove specific item", ->
      item1 = new Product {id:15,desc:'Pollo',type:'Frita',qty:1}
      item2 = new Product {id:16,desc:'Carne suave',type:'Horno',qty:1}
      item3 = new Product {id:17,desc:'Cebolla y Queso',type:'Frita',qty:1}

      ShoppingCartService.add item1
      ShoppingCartService.add item2
      ShoppingCartService.add item3

      ShoppingCartService.remove item1.cartItemKey

      expect(ShoppingCartService.getCart().length).toBe 2
      expect(ShoppingCartService.getCart()).toContain item2
      expect(ShoppingCartService.getCart()).toContain item3

    it "should empty cart", ->
      ShoppingCartService.add new Product {id:20,desc:'Pollo',type:'Frita',qty:1}
      ShoppingCartService.add new Product {id:21,desc:'Carne suave',type:'Horno',qty:1}
      ShoppingCartService.add new Product {id:22,desc:'Cebolla y Queso',type:'Frita',qty:1}

      ShoppingCartService.emptyCart()

      expect(ShoppingCartService.getCart().length).toBe 0
      expect(ShoppingCartService.getTotalPrice()).toBe 0

    describe "when item not found", ->

      it "should not remove any", ->
        item1 = new Product {id:15,desc:'Pollo',type:'Frita',qty:1,price:{base:10}}
        item2 = new Product {id:16,desc:'Carne suave',type:'Horno',qty:1,price:{base:20}}

        ShoppingCartService.add item1
        ShoppingCartService.add item2

        expect(ShoppingCartService.getCart().length).toBe 2

        ShoppingCartService.remove "someid"

        expect(ShoppingCartService.getCart().length).toBe 2


      it "should NOT broadcast CART:PRICE_UPDATED event", ->
        inject ($rootScope) ->
          broadcastSpy = spyOn($rootScope, '$broadcast')

          item1 = new Product {id:15,desc:'Pollo',type:'Frita',qty:1,price:{base:10}}
          item2 = new Product {id:16,desc:'Carne suave',type:'Horno',qty:1,price:{base:20}}

          ShoppingCartService.add item1
          ShoppingCartService.add item2

          ShoppingCartService.remove "someid"
          expect(broadcastSpy).not.toHaveBeenCalled


  describe "calculate price functionality", ->

    it "should return 0 if no products", ->
      expect(ShoppingCartService.getTotalPrice()).toBe 0

    it "should calculate total price, only one product", ->
      ShoppingCartService.add new Product {id:15,desc:'Pollo',type:'Frita',qty:2,price:{base:1000}}

      expect(ShoppingCartService.getTotalPrice()).toBe 2000

    it "should calculate total price, several products", ->
      ShoppingCartService.add new Product {id:20,desc:'Pollo',type:'Frita',qty:2, price:{base:1000}}
      ShoppingCartService.add new Product {id:21,desc:'Carne suave',type:'Horno',qty:3, price:{base:2000}}
      ShoppingCartService.add new Product {id:22,desc:'Cebolla y Queso',type:'Frita',qty:2, price:{base:3000}}

      expect(ShoppingCartService.getTotalPrice()).toBe 14000

  describe "check order eligibility", ->

    it "should return error if cart empty", ->
      response = ShoppingCartService.checkEligibility()
      expect(response.success).toBeFalsy()
      expect(response.reason).toBe "NO_PRODUCTS"

    it "should return error if no store selected", ->
      inject (StoreService)->
        spyOn(StoreService, 'retrieveSelectedStore').and.returnValue null
        ShoppingCartService.add new Product {id:20,desc:'Pollo',type:'Frita',qty:2, price:{base:1000}}
        response = ShoppingCartService.checkEligibility()
        expect(response.success).toBeFalsy()
        expect(response.reason).toBe "NO_STORE"

    it "should return error if no minimum reached", ->
      inject (StoreService, Delivery)->
        store =
          order:
            minPrice:
              delivery: 100
              pickup: 50
        spyOn(StoreService, 'retrieveSelectedStore').and.returnValue store
        spyOn(Delivery, 'retrieveDelivery').and.returnValue 'delivery'
        ShoppingCartService.add new Product {id:20,desc:'Pollo',type:'Frita',qty:2, price:{base:10}}
        response = ShoppingCartService.checkEligibility()
        expect(response.success).toBeFalsy()
        expect(response.reason).toBe "NO_MIN_AMOUNT"

    it "should return ok if all conditions met", ->
      inject (StoreService, Delivery)->
        store =
          order:
            minPrice:
              delivery: 100
              pickup: 50
        spyOn(StoreService, 'retrieveSelectedStore').and.returnValue store
        spyOn(Delivery, 'retrieveDelivery').and.returnValue 'delivery'
        ShoppingCartService.add new Product {id:20,desc:'Pollo',type:'Frita',qty:2, price:{base:10000}}
        response = ShoppingCartService.checkEligibility()
        expect(response.success).toBeTruthy()

  describe 'checkout', ->

    it 'should add the saved store to the cart', ->
      inject (StoreService)->
        cart = {}
        store =
          order:
            minPrice:
              delivery: 100
              pickup: 50
        spyOn(StoreService, 'retrieveSelectedStore').and.returnValue store
        ShoppingCartService.checkout(cart)
        expect(cart.store).toEqual store

    it 'should add the saved delivery to the cart', ->
      inject (Delivery)->
        cart = {}
        spyOn(Delivery, 'retrieveDelivery').and.returnValue 'delivery'
        ShoppingCartService.checkout cart
        expect(cart.delivery).toBe 'delivery'

    it 'should add the saved contact to the cart', ->
      inject (Contact)->
        cart = {}
        user  =
          name: 'Santiago'
        spyOn(Contact, 'retrieveConnectionInfo').and.returnValue user
        ShoppingCartService.checkout cart
        expect(cart.contact.name).toEqual 'Santiago'

    it 'should delegate the cart to OrderService', ->
      inject (OrderService)->
        cart =
          products: []
          contact:
            name: 'Santiago'
          delivery: 'pickup'
          store:
            order:
              minPrice:
                delivery: 100
                pickup: 50
        spyOn(OrderService, 'createOrder').and.callThrough()
        ShoppingCartService.checkout cart
        expect(OrderService.createOrder).toHaveBeenCalled()

