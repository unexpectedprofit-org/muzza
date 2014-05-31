describe 'ShoppingCart Service', ->

  beforeEach ->
    module 'Muzza.cart'
    module 'Muzza.empanadas'
    module 'Muzza.promo'

  ShoppingCartService = Empanada = undefined

  beforeEach ->
    inject ($injector) ->
      ShoppingCartService = $injector.get 'ShoppingCartService'
      Empanada = $injector.get 'Empanada'

  it 'should get an initial empty cart', ->
    expect(ShoppingCartService.getCart().length).toBe 0
    expect(ShoppingCartService.getTotalPrice()).toBe 0
    expect(ShoppingCartService.getPromotions().length).toBe 0


  describe "add functionality", ->

    it "should add product if not present", ->
      item = new Empanada {id:1,desc:'Pollo',type:'Frita',qty:2}
      ShoppingCartService.add item

      expect(ShoppingCartService.getCart().length).toBe 1
      expect(ShoppingCartService.getCart()[0]).toEqual item

      item = new Empanada {id:2,desc:'Humita',type:'Frita',qty:6}
      ShoppingCartService.add item
      addedItem = ShoppingCartService.getCart()[1]

      expect(ShoppingCartService.getCart().length).toBe 2
      expect(addedItem).toEqual item
      expect(addedItem.cartItemKey).toBeDefined()
      expect(addedItem.cartItemKey).toBe 'cart_2'

    it "should replace product if product is already in the cart", ->
#      Create product
      item = new Empanada {id:1,desc:'Pollo',type:'Frita',qty:2}
      ShoppingCartService.add item

#      edit product
      editedItem  = ShoppingCartService.get item.cartItemKey
      editedItem.updateQty(+1)

      ShoppingCartService.add editedItem
      updatedItem = ShoppingCartService.getCart()[0]
      expect(updatedItem.qty).toBe 3
      expect(ShoppingCartService.getCart().length).toBe 1

    it "should broadcast CART:PRICE_UPDATED event", ->
        inject ($rootScope) ->
          broadcastSpy = spyOn($rootScope, '$broadcast')
          ShoppingCartService.add new Empanada {id:1,desc:'Pollo',type:'Frita',qty:2,price:{base: 10}}

          expect(broadcastSpy).toHaveBeenCalledWith 'CART:PRICE_UPDATED', 20


  describe "retrieve functionality", ->

    it 'should return all items in the cart', ->
      item1 = new Empanada {id:12,desc:'Pollo',type:'Frita'}
      item2 = new Empanada {id:13,desc:'Carne',type:'Horno'}
      ShoppingCartService.add item1
      ShoppingCartService.add item2

      expect(ShoppingCartService.getCart().length).toBe 2
      expect(ShoppingCartService.getCart()).toContain item1
      expect(ShoppingCartService.getCart()).toContain item2

    it "should return specific item", ->
      item1 = new Empanada {id:15,desc:'Pollo',type:'Frita'}
      item2 = new Empanada {id:16,desc:'Carne suave',type:'Horno'}
      item3 = new Empanada {id:17,desc:'Cebolla y Queso',type:'Frita'}

      ShoppingCartService.add item1
      ShoppingCartService.add item2
      ShoppingCartService.add item3

      expect(ShoppingCartService.get( item2.cartItemKey )).toEqual item2


  describe "remove functionality", ->

    it "should remove specific item", ->
      item1 = new Empanada {id:15,desc:'Pollo',type:'Frita',qty:1}
      item2 = new Empanada {id:16,desc:'Carne suave',type:'Horno',qty:1}
      item3 = new Empanada {id:17,desc:'Cebolla y Queso',type:'Frita',qty:1}

      ShoppingCartService.add item1
      ShoppingCartService.add item2
      ShoppingCartService.add item3

      ShoppingCartService.remove item1.cartItemKey

      expect(ShoppingCartService.getCart().length).toBe 2
      expect(ShoppingCartService.getCart()).toContain item2
      expect(ShoppingCartService.getCart()).toContain item3

    it "should empty cart", ->
      ShoppingCartService.add new Empanada {id:20,desc:'Pollo',type:'Frita',qty:1}
      ShoppingCartService.add new Empanada {id:21,desc:'Carne suave',type:'Horno',qty:1}
      ShoppingCartService.add new Empanada {id:22,desc:'Cebolla y Queso',type:'Frita',qty:1}

      ShoppingCartService.emptyCart()

      expect(ShoppingCartService.getCart().length).toBe 0
      expect(ShoppingCartService.getTotalPrice()).toBe 0

    it "should broadcast CART:PRICE_UPDATED event", ->
      inject ($rootScope) ->
        broadcastSpy = spyOn($rootScope, '$broadcast')

        item1 = new Empanada {id:15,desc:'Pollo',type:'Frita',qty:1,price:{base:10}}
        item2 = new Empanada {id:16,desc:'Carne suave',type:'Horno',qty:1,price:{base:20}}
        item3 = new Empanada {id:17,desc:'Cebolla y Queso',type:'Frita',qty:1,price:{base:20}}

        ShoppingCartService.add item1
        ShoppingCartService.add item2
        ShoppingCartService.add item3
        expect(broadcastSpy).toHaveBeenCalled()

        ShoppingCartService.remove item1.cartItemKey
        expect(broadcastSpy).toHaveBeenCalledWith 'CART:PRICE_UPDATED', 40

        ShoppingCartService.emptyCart()
        expect(broadcastSpy).toHaveBeenCalledWith 'CART:PRICE_UPDATED', 0


  describe "calculate price functionality", ->

    it "should calculate total price, only one product", ->
      ShoppingCartService.add new Empanada {id:15,desc:'Pollo',type:'Frita',qty:2,price:{base:1000}}

      expect(ShoppingCartService.getTotalPrice()).toBe 2000

    it "should calculate total price, several products", ->
      ShoppingCartService.add new Empanada {id:20,desc:'Pollo',type:'Frita',qty:2, price:{base:1000}}
      ShoppingCartService.add new Empanada {id:21,desc:'Carne suave',type:'Horno',qty:3, price:{base:2000}}
      ShoppingCartService.add new Empanada {id:22,desc:'Cebolla y Queso',type:'Frita',qty:2, price:{base:3000}}

      expect(ShoppingCartService.getTotalPrice()).toBe 14000


  describe "Promotion module", ->


    it "should have funtions defined", ->
      expect(ShoppingCartService.getPromotions()).toBeDefined()
      expect(ShoppingCartService.getApplicablePromotions()).toBeDefined()

    it "should init promotions with empty object", ->
      expect(ShoppingCartService.getPromotions()).toEqual []
      expect(ShoppingCartService.getApplicablePromotions()).toEqual []

    it "should add promotion", ->
      ShoppingCartService.addPromotion {id:2}
      expect(ShoppingCartService.getPromotions().length).toBe 1
      expect(ShoppingCartService.getPromotions()[0].id).toBe 2

    it "should contain only one promotion", ->
      ShoppingCartService.addPromotion {id:2}
      expect(ShoppingCartService.getPromotions().length).toBe 1
      expect(ShoppingCartService.getPromotions()[0].id).toBe 2

      ShoppingCartService.addPromotion {id:3}
      expect(ShoppingCartService.getPromotions().length).toBe 1
      expect(ShoppingCartService.getPromotions()[0].id).toBe 3

    it "should remove specific promotion", ->
      ShoppingCartService.addPromotion {details:{id:2}}
      ShoppingCartService.removePromotion 2

      expect(ShoppingCartService.getPromotions().length).toBe 0

    describe "retrieveApplicablePromos functionality", ->

      PromoTypeQuantity = undefined

      beforeEach ->
        inject ($injector) ->
          PromoTypeQuantity = $injector.get 'PromoTypeQuantity'

      it "should retrieve no applicable promos", ->

        ShoppingCartService.add new Empanada {id:505,qty:1,desc: "description",price:{base: 1020},type: "horno"}
        ShoppingCartService.addPromotion new PromoTypeQuantity {id:2,price:50,rules:[{qty:6,cat:'EMPANADA',subcat:'|HORNO||'}]}

        expect(ShoppingCartService.getApplicablePromotions().length).toBe 0

      it "should retrieve 1 applicable promo", ->

        ShoppingCartService.add new Empanada {id:505,qty:6,desc: "description",price:{base: 1020},type: "horno"}
        ShoppingCartService.addPromotion new PromoTypeQuantity {id:3,price:100,rules:[{qty:6,cat:'EMPANADA',subcat:'|HORNO||'}]}

        expect(ShoppingCartService.getApplicablePromotions().length).toBe 1