describe 'Order Service', ->

  firebaseStub = ->
    # https://github.com/firebase/angularFire-seed/blob/master/test/unit/servicesSpec.js
    # firebase is invoked using new Firebase, but we need a static ref
    # to the functions before it is instantiated, so we cheat here by
    # attaching the functions as Firebase.fns, and ignore new (we don't use `this` or `prototype`)
    FirebaseStub = ->
      FirebaseStub.fns

    FirebaseStub.fns = callbackVal: null
    customSpy FirebaseStub.fns, "$set", (value, cb) ->
      cb and cb(FirebaseStub.fns.callbackVal)

    FirebaseStub

  customSpy = (obj, m, fn) ->
    obj[m] = fn
    spyOn(obj, m).and.callThrough()

  beforeEach ->
    module 'Muzza.order'
    module 'Muzza.cart'
    module 'Muzza.pizzas'

    module ($provide) ->
      $provide.value 'ShoppingCartService',
        getCart: () -> []
      $provide.value '$firebase', firebaseStub()
      $provide.value 'Firebase', firebaseStub()
      $provide.value 'OrderRef', firebaseStub()
      return null

  OrderService = ShoppingCartService = getCartSpy = undefined

  beforeEach ->
    inject (_ShoppingCartService_, _OrderService_) ->
      ShoppingCartService = _ShoppingCartService_
      OrderService = _OrderService_

    getCartSpy = spyOn(ShoppingCartService, 'getCart').and.callThrough()

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

    it 'should push the order to firebase', ->
      inject (Pizza, $firebase)->
        cart =
          products: [new Pizza {id:1, desc:'Muzza', qty:1}]
          promotions: null
          contact: {name: 'San'}
          totalPrice: ()-> null
        OrderService.createOrder(cart)
        order = OrderService.retrieveOrder()
        OrderService.submitOrder()
        expect($firebase.fns.$set).toHaveBeenCalledWith(order)

  describe 'retrieveDelivery', ->

    it ' should return the selected delivery option', ->
      OrderService.chooseDelivery('pickup')
      option = OrderService.retrieveDelivery()
      expect(option).toBe 'pickup'

