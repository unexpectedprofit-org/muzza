angular.module('Muzza.order').factory 'OrderRef', (Firebase, ORDERURL)->

  return (storeId, userPhone)->
    today = new Date()
    year = today.getFullYear().toString()
    month = (today.getMonth() + 1).toString()
    day = today.getDate().toString()
    orderDate =  year + month + day
    url = ORDERURL + 'local' + storeId + '/orders/' + orderDate + '/' + userPhone
    new Firebase(url)