describe "services", ->

  beforeEach ->
    module "Muzza.services"



  describe "Product Service", ->

    ProductService = undefined

    beforeEach ->
      inject(( _ProductService_ ) ->
        ProductService = _ProductService_
    )

    it 'should retrieve a list of categories with products and produce an array of models', ->
      menu = ProductService.getMenu undefined, undefined

      expect(menu.length).toBe 8
      expect(menu[0].products.length).toBe 4
      expect(menu[1].products.length).toBe 3
      expect(menu[2].products.length).toBe 1
      expect(menu[3].products.length).toBe 1
      expect(menu[4].products.length).toBe 4
      expect(menu[5].products.length).toBe 3
      expect(menu[6].products.length).toBe 2
      expect(menu[7].products.length).toBe 3


    it 'should return only the array from an specific category', ->
      categoryID = 1
      menu = ProductService.getMenu 1, categoryID

      expect(menu.length).toBe 1
      expect(menu[0].products.length).toBe 4
      expect(menu[0].id).toEqual categoryID



  describe "OrderService", ->
    OrderService = undefined

    beforeEach ->
      inject(( _OrderService_ ) ->
        OrderService = _OrderService_
    )

    it "should get an order details object", ->
      newMenuObject = OrderService.placeOrder {}
      expect( newMenuObject.number ).toBe "AXAHA263920"