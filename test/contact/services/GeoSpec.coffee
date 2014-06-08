geoCodeResponse = ''
google =
  maps:
    GeocoderStatus:
      OK: 'ok'
    Geocoder: ()->
      geocode: (address, callback)->
        callback([
          geometry:
            location:
              k: -33.591809
              A: -58.3959331
        ], geoCodeResponse)


describe 'Geo', ->

  beforeEach ->
    module 'Muzza.contact'

  Geo = $rootScope = undefined

  beforeEach ->
    inject (_Geo_, _$rootScope_)->
      Geo = _Geo_
      $rootScope = _$rootScope_

  describe 'isUserWithinRadio', ->

    it 'should resolve if a user is within a store delivery radio', ->

      geoCodeResponse = 'ok'

      address =
        street: 'Junin'
        door: '1477'
        area: 'Buenos Aires'
      store =
        latLong:
          k: -33.591709
          A: -58.3959331
        radio: 2

      isWithin = undefined
      promise = Geo.validateDeliveryRadio address, store
      promise.then (result)->
        isWithin = result
      $rootScope.$digest()

      expect(isWithin).toBe true

    it 'should resolve if a user is not within a store delivery radio', ->

      geoCodeResponse = 'ok'

      address =
        street: 'Junin'
        door: '1477'
        area: 'Buenos Aires'
      store =
        latLong:
          k: -34.591709
          A: -58.3959331
        radio: 2

      isWithin = undefined
      promise = Geo.validateDeliveryRadio address, store
      promise.then (result)->
        isWithin = result
      $rootScope.$digest()

      expect(isWithin).toBe false

    it 'should reject with an error if it is not able to geocode the user address', ->

      geoCodeResponse = 'error'

      address =
        street: 'Junin'
        door: '1477'
        area: 'Buenos Aires'
      store =
        latLong:
          k: -33.591709
          A: -58.3959331
        radio: 2

      error = undefined
      promise = Geo.validateDeliveryRadio address, store
      promise.then null, (errorMsg)->
        error = errorMsg
      $rootScope.$digest()

      expect(error).toBe 'No se pudo resolver la direccion la ingresada'


