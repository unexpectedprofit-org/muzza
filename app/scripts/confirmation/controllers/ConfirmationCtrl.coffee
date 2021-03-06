angular.module('Muzza.confirmation').controller 'ConfirmationCtrl', ($scope, OrderService, ShoppingCartService)->
  $scope.order = OrderService.retrieveOrder()
  ShoppingCartService.emptyCart()
  OrderService.cleanOrder()

#  $scope.order = {"delivery":"pickup","contact":{"googleId":"google:117252553582497213280","name":"santiago esteva","email":"santiagoesteva@gmail.com","phone":"2341412341234"},"store":{"id":2,"name":"Pizzeria la tengo mas grande","address":"Av. Juan B. Alberdi 3200 - Flores (Capital Federal)","tel":"2222 8898 / 1234 4444 / 15 0000 2222"},"products":[{"cat":"EMPANADA","isEditable":{"options":false,"qty":true},"subcat":1,"type":"Al Horno","qty":7,"description":"Calabresa","totalPrice":1800,"toppings":"Muzzarella / Longaniza / Salsa","id":2,"price":{"base":1800},"cartItemKey":"cart_1","hashKey":"ID_BRAND|2|1||"},{"cat":"PIZZA","isEditable":{"options":true,"qty":true},"description":"Calabresa","subcat":1,"qty":1,"totalPrice":5500,"size":"individual","dough":"piedra","price":{"base":5000,"size":{"porcion":0,"individual":500,"chica":1000,"grande":2000},"dough":{"a la piedra":0,"al molde":0}},"id":93,"toppings":"Muzzarella / Longaniza / Salsa","cartItemKey":"cart_2","hashKey":"ID_BRAND|93|1|INDIVIDUAL|PIEDRA"}],"totalPrice":18100}

