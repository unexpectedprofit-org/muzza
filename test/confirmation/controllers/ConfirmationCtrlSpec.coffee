describe "Confirmation Controller", ->

  beforeEach ->
    module 'Muzza.confirmation'
    module ($provide) ->

      $provide.value 'OrderService',
        retrieveOrder: ()-> {"delivery":"pickup","contact":{"googleId":"google:117252553582497213280","name":"santiago esteva","email":"santiagoesteva@gmail.com","phone":"2341412341234"},"store":{"id":2,"name":"Pizzeria la tengo mas grande","address":"Av. Juan B. Alberdi 3200 - Flores (Capital Federal)","tel":"2222 8898 / 1234 4444 / 15 0000 2222"},"products":[{"cat":"EMPANADA","isEditable":{"options":false,"qty":true},"subcat":1,"type":"Al Horno","qty":7,"description":"Calabresa","totalPrice":1800,"toppings":"Muzzarella / Longaniza / Salsa","id":2,"price":{"base":1800},"cartItemKey":"cart_1","hashKey":"ID_BRAND|2|1||"},{"cat":"PIZZA","isEditable":{"options":true,"qty":true},"description":"Calabresa","subcat":1,"qty":1,"totalPrice":5500,"size":"individual","dough":"piedra","price":{"base":5000,"size":{"porcion":0,"individual":500,"chica":1000,"grande":2000},"dough":{"a la piedra":0,"al molde":0}},"id":93,"toppings":"Muzzarella / Longaniza / Salsa","cartItemKey":"cart_2","hashKey":"ID_BRAND|93|1|INDIVIDUAL|PIEDRA"}],"totalPrice":18100}
        cleanOrder: ()-> null

      $provide.value 'ShoppingCartService',
        emptyCart: ()-> null

      null

  scope = OrderService = ShoppingCartService = undefined

  beforeEach ->
    inject ($controller, $rootScope, _OrderService_, _ShoppingCartService_) ->
      scope = $rootScope.$new()
      OrderService = _OrderService_
      ShoppingCartService = _ShoppingCartService_

      spyOn(OrderService, 'retrieveOrder').and.callThrough()
      spyOn(OrderService, 'cleanOrder').and.callThrough()
      spyOn(ShoppingCartService, 'emptyCart').and.callThrough()

      $controller "ConfirmationCtrl",
        $scope: scope

  it "should call the order service to retrieve the order", ->
    expect(OrderService.retrieveOrder).toHaveBeenCalled()

  it "should clear the order once it was retrieved", ->
    expect(OrderService.cleanOrder).toHaveBeenCalled()

  it "should clear the cart once it was retrieved", ->
    expect(ShoppingCartService.emptyCart).toHaveBeenCalled()
