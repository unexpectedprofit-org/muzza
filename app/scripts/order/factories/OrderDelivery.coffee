#angular.module('Muzza.order').factory "OrderDelivery", ()->
#
#  class OrderDelivery
#    constructor: (modal) ->
#      @modal = modal
#
#  OrderDelivery::show = ->
#    @modal.show()
#
#  OrderDelivery::hide = ->
#    @modal.hide()
#
#  OrderDelivery::choose = (deliveryType)->
#    @modal.scope.order.deliveryOption = deliveryType
#    @hide()
#
#  return OrderDelivery