describe 'Order Service', ->

  beforeEach ->
    module 'Muzza.order'
    module 'Muzza.cart'
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

