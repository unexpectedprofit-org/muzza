angular.module('Muzza.contact').service 'Contact', ()->

  @contact =  {}

  getContactInfo = ->
    @contact

  setContactInfo = (contact)->
    @contact = contact

  addContactInfo: setContactInfo
  retrieveConnectionInfo: getContactInfo
