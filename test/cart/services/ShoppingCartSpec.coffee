describe 'ShoppingCart Service', ->

  beforeEach ->
    module 'Muzza.cart'
    module 'Muzza.empanadas'

  ShoppingCartService = Empanada = undefined

  beforeEach ->
    inject ($injector) ->
      ShoppingCartService = $injector.get 'ShoppingCartService'
      Empanada = $injector.get 'Empanada'

  it 'should get an initial empty cart', ->
    expect(ShoppingCartService.getCart().length).toBe 0
    expect(ShoppingCartService.getTotalPrice()).toBe 0


  describe "add functionality", ->

    it "should add product if not present", ->
      item = new Empanada {id:1,desc:'Pollo',type:'Frita',qty:2}
      ShoppingCartService.add item

      expect(ShoppingCartService.getCart().length).toBe 1
      expect(ShoppingCartService.getCart()[0]).toEqual item

      item = new Empanada {id:2,desc:'Humita',type:'Frita',qty:6}
      ShoppingCartService.add item

      expect(ShoppingCartService.getCart().length).toBe 2
      expect(ShoppingCartService.getCart()[1]).toEqual item

    it "should replace product if product is already in the cart", ->
#      Create product
      item = new Empanada {id:1,desc:'Pollo',type:'Frita',qty:2}
      ShoppingCartService.add item

#      edit product
      editedItem  = ShoppingCartService.get item.getHash()
      editedItem.updateQty(+1)

      ShoppingCartService.add editedItem
      updatedItem = ShoppingCartService.getCart()[0]
      expect(updatedItem.qty).toBe 3

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

      expect(ShoppingCartService.get( item2.getHash() )).toEqual item2

  describe "remove functionality", ->

    it "should remove specific item", ->
      item1 = new Empanada {id:15,desc:'Pollo',type:'Frita',qty:1}
      item2 = new Empanada {id:16,desc:'Carne suave',type:'Horno',qty:1}
      item3 = new Empanada {id:17,desc:'Cebolla y Queso',type:'Frita',qty:1}

      ShoppingCartService.add item1
      ShoppingCartService.add item2
      ShoppingCartService.add item3

      ShoppingCartService.remove item1.getHash()

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

  describe "calculate price functionality", ->

    it "should calculate total price, only one product", ->
      ShoppingCartService.add new Empanada {id:15,desc:'Pollo',type:'Frita',qty:2,price:1000}

      expect(ShoppingCartService.getTotalPrice()).toBe 2000

    it "should calculate total price, several products", ->
      ShoppingCartService.add new Empanada {id:20,desc:'Pollo',type:'Frita',qty:2, price:1000}
      ShoppingCartService.add new Empanada {id:21,desc:'Carne suave',type:'Horno',qty:3, price:2000}
      ShoppingCartService.add new Empanada {id:22,desc:'Cebolla y Queso',type:'Frita',qty:2, price:3000}

      expect(ShoppingCartService.getTotalPrice()).toBe 14000