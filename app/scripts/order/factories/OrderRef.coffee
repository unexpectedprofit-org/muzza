angular.module('Muzza.order').factory 'OrderRef', (Firebase, ORDERURL)->

  return (toAppend)->
    new Firebase(ORDERURL + toAppend)