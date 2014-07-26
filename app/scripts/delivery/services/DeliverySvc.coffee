angular.module('Muzza.delivery').service 'Delivery' , ()->

  @delivery = undefined

  setDelivery = (option)->
    @delivery = option

  getDelivery =  ->
    @delivery

  chooseDelivery: setDelivery
  retrieveDelivery: getDelivery
