describe 'ContactSvc', ->

  beforeEach ->
    module 'Muzza.contact'

  ContactSvc = undefined

  beforeEach ->
    inject (_Contact_)->
      ContactSvc = _Contact_

  describe 'retrieveContact chooseContactOption', ->

    it 'should save and return the selected Contact option', ->
      inject ($rootScope)->
        userContact = undefined
        ContactSvc.addContactInfo('pickup')
        ContactSvc.retrieveContactInfo().then (contact)->
          userContact = contact
        $rootScope.$apply()
        expect(userContact).toBe 'pickup'
