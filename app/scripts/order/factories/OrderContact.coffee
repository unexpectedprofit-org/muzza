angular.module('Muzza.order').factory "OrderContact", ($state)->

  class OrderContact
    constructor: (modal) ->
      @modal = modal

  OrderContact::show = ->
    @modal.show()

  OrderContact::hide = ->
    @modal.hide()

  OrderContact::place = ()->
    @hide()
    $state.go('^.orderplace')


  return OrderContact