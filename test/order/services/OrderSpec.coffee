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
      $provide.value 'Geo',
        validateDeliveryRadio: ()-> null
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

    describe 'when the user has selected pikcup', ->

      it 'should save the contact information into the order', ->
        OrderService.chooseDelivery('pickup')
        contactInfo =
          name: 'Santiago'
          phone: '1234567890'
          email: 'test@test.com'
        OrderService.addContactInfo(contactInfo)
        expect(OrderService.retrieveOrder()).toEqual {delivery: 'pickup', contact: contactInfo}

    describe 'when the user has selected delivery', ->

      it 'should add the contact if the user is within the delivery radio', ->
        inject (Geo)->
          spyOn(Geo, 'validateDeliveryRadio').and.callFake ()-> {then: (callback, fallback)-> callback(true)}
          OrderService.chooseDelivery('delivery')
          contactInfo =
            address:
              street: 'Junin'
              door: '1477'
              area: 'Buenos Aires'
            name: 'San'
            phone: '12345678'
            email: 'test@test.com'
          OrderService.addContactInfo(contactInfo)
          expect(OrderService.retrieveOrder()).toEqual {delivery: 'delivery', contact: contactInfo}

      describe 'but the user is not within the delivery radio', ->

        it 'should not add the contact', ->
          inject (Geo, $rootScope)->
            spyOn(Geo, 'validateDeliveryRadio').and.callFake ()-> {then: (callback, fallback)-> callback(false)}
            OrderService.chooseDelivery('delivery')
            contactInfo =
              address:
                street: 'Junin'
                door: '1477'
                area: 'Buenos Aires'
              name: 'San'
              phone: '12345678'
              email: 'test@test.com'
            OrderService.addContactInfo(contactInfo)
            expect(OrderService.retrieveOrder()).toEqual {delivery: 'delivery'}

        it 'should send an error msg upwards', ->
          inject (Geo, $rootScope)->
            spyOn(Geo, 'validateDeliveryRadio').and.callFake ()-> {then: (callback, fallback)-> callback(false)}
            OrderService.chooseDelivery('delivery')
            contactInfo =
              address:
                street: 'Junin'
                door: '1477'
                area: 'Buenos Aires'
              name: 'San'
              phone: '12345678'
              email: 'test@test.com'
            promise  = OrderService.addContactInfo(contactInfo)

            error = undefined

            promise.then null, (errorMsg)->
              error = errorMsg

            # forcing digest so promises get resolved
            $rootScope.$digest()
            expect(error).toBe 'No esta en el radio de delivery del local'

      describe 'when Geo is not able to validate the address for any reason', ->

        it 'should not add the contact', ->
          inject (Geo, $rootScope)->
            spyOn(Geo, 'validateDeliveryRadio').and.callFake ()-> {then: (callback, fallback)-> fallback('Error 101')}
            OrderService.chooseDelivery('delivery')
            contactInfo =
              address:
                street: 'Junin'
                door: '1477'
                area: 'Buenos Aires'
              name: 'San'
              phone: '12345678'
              email: 'test@test.com'
            OrderService.addContactInfo(contactInfo)
            expect(OrderService.retrieveOrder()).toEqual {delivery: 'delivery'}

      it 'should reject passing the error upwards', ->
        inject (Geo, $rootScope)->
          spyOn(Geo, 'validateDeliveryRadio').and.callFake ()-> {then: (callback, fallback)-> fallback('Error 101')}
          OrderService.chooseDelivery('delivery')
          contactInfo =
            address:
              street: 'Junin'
              door: '1477'
              area: 'Buenos Aires'
            name: 'San'
            phone: '12345678'
            email: 'test@test.com'
          promise  = OrderService.addContactInfo(contactInfo)

          error = undefined

          promise.then null, (errorMsg)->
            error = errorMsg

          # forcing digest so promises get resolved
          $rootScope.$digest()

          expect(error).toBe 'Error 101'

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

    it 'should return the selected delivery option', ->
      OrderService.chooseDelivery('pickup')
      option = OrderService.retrieveDelivery()
      expect(option).toBe 'pickup'

  describe 'getContactInfo', ->

    it 'should return the filled contact information', ->
      OrderService.chooseDelivery('pickup')
      OrderService.addContactInfo({name:'San'})
      expect(OrderService.retrieveConnectionInfo()).toEqual {name:'San'}

  describe 'chooseStore', ->

    it 'should save the selected pickup store into the order', ->
      store =
        id: 1
      OrderService.chooseStore(store)
      expect(OrderService.retrieveOrder()).toEqual { pickupStore: {id: 1}}

