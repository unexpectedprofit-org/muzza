describe "Config", ->

  beforeEach ->
    module 'Muzza.config'

  it "should be configured (ORDERURL was set)", ->
    inject (ORDERURL) ->
      expect(ORDERURL).not.toEqual "https://INSTANCE.firebaseio.com"

  it "should have FBURL beginning with https", ->
    inject (ORDERURL) ->
      expect(ORDERURL).toMatch /^https:\/\/[a-zA-Z_-]+\.firebaseio\.com/i

  it "should have a valid SEMVER version", ->
    inject (version) ->
      expect(version).toMatch /^\d\d*(\.\d+)+$/