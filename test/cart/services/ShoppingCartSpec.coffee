describe 'ShoppingCart Service', ->

  beforeEach ->
    module 'Muzza.cart'

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