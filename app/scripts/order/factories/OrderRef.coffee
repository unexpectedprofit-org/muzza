angular.module('Muzza.order').factory 'OrderRef', (Firebase, ORDERURL)->

  return (storeId, userPhone)->
    url = ORDERURL + 'local' + storeId + '/orders/' + userPhone
    new Firebase(url)