describe 'Order Service', ->

  beforeEach ->
    module 'Muzza.order'
    module 'Muzza.cart'
    module 'Muzza.pizzas'

    module ($provide) ->
      $provide.value 'ShoppingCartService',
        getCart: () -> []
      return null

  OrderService = ShoppingCartService = getCartSpy = undefined

  beforeEach ->
    inject (_ShoppingCartService_, _OrderService_) ->
      ShoppingCartService = _ShoppingCartService_
      OrderService = _OrderService_

    getCartSpy = spyOn(ShoppingCartService, 'getCart').and.callThrough()

  describe "place functionality", ->

    it "should call Shopping cart to get product", ->
      OrderService.place {}

      expect(getCartSpy).toHaveBeenCalled()
      expect(getCartSpy.calls.count()).toBe 1


  describe 'chooseDeliveryOption', ->

    it 'should save the option into the order', ->
      OrderService.chooseDelivery('pickup')
      expect(OrderService.retrieveOrder()).toEqual { delivery: 'pickup'}

  describe 'addContactInfo', ->

    it 'should sabe the contact information into the order', ->
      contactInfo =
        name: 'Santiago'
        phone: '1234567890'
        email: 'test@test.com'
      OrderService.addContactInfo(contactInfo)
      expect(OrderService.retrieveOrder()).toEqual {contact: contactInfo}

  describe 'createOrder', ->

    it 'should create an order with a cart', ->
      inject (Pizza)->
        cart =
          products: [new Pizza {id:1, desc:'Muzza', qty:1}]
          promotions: null
          totalPrice: ()-> null
        OrderService.createOrder(cart)
        expect(OrderService.retrieveOrder()).toEqual cart

  describe 'submitOrder', ->

    it 'should log the order', ->
      inject (Pizza, $log)->
        cart =
          products: [new Pizza {id:1, desc:'Muzza', qty:1}]
          promotions: null
          totalPrice: ()-> null
        spyOn($log, 'log')
        OrderService.createOrder(cart)
        order = OrderService.retrieveOrder()
        OrderService.submitOrder()
        expect($log.log).toHaveBeenCalledWith(order)

