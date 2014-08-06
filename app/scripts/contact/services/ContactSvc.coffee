angular.module('Muzza.contact').service 'Contact', ($q)->

  @contact =  {}

  getContactInfo = ->
    deferred = $q.defer()
    deferred.resolve(@contact)
    return deferred.promise

  setContactInfo = (contact)->
    @contact = contact

  addContactInfo: setContactInfo
  retrieveContactInfo: getContactInfo
