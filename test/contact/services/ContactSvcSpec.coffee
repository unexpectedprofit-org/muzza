describe 'ContactSvc', ->

  beforeEach ->
    module 'Muzza.contact'

  ContactSvc = undefined

  beforeEach ->
    inject (_Contact_)->
      ContactSvc = _Contact_

  describe 'chooseContactOption', ->

    it 'should save the option into the order', ->
      ContactSvc.addContactInfo('pickup')
      expect(ContactSvc.retrieveConnectionInfo()).toEqual 'pickup'

  describe 'retrieveContact', ->

    it 'should return the selected Contact option', ->
      ContactSvc.addContactInfo('pickup')
      option = ContactSvc.retrieveConnectionInfo()
      expect(option).toBe 'pickup'
