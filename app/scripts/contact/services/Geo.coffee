angular.module('Muzza.contact').service 'Geo', ($q, $log)->

  geocoder = new google.maps.Geocoder()

  geoCode = (address)->
    deferred = $q.defer()

    geocoder.geocode {address: address}, (results, status) ->
      if status is google.maps.GeocoderStatus.OK
        latLong = results[0].geometry.location
        deferred.resolve(latLong)
      else
        $log.log "Geocode was not successful for the following reason: " + status
        deferred.reject(status)

    deferred.promise

  isUserWithinRadio = (address, storeDelivery)->

    userAddress = address.street + ' ' + address.door + ' , ' + address.area
    storeLatLong = storeDelivery.latLong
    storeDeliveryRadio = storeDelivery.radio

    deferred = $q.defer()

    geoCode(userAddress).then (userLatLong)->
      distanceBetweenUserAndStore = calculateDistance(storeLatLong.k, storeLatLong.A, userLatLong.k, userLatLong.B)
      isWithinRadio = distanceBetweenUserAndStore <= storeDeliveryRadio
      deferred.resolve(isWithinRadio)
    , (status)->
      deferred.reject('No se pudo resolver la direccion la ingresada')


    deferred.promise


  calculateDistance = (lat1, lon1, lat2, lon2)->
    R = 6371 # Radius of the earth in km
    dLat = deg2rad(lat2 - lat1) # deg2rad below
    dLon = deg2rad(lon2 - lon1)
    a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    distance = R * c # Distance in km
    distance

  deg2rad = (deg) ->
    deg * (Math.PI / 180)

  validateDeliveryRadio: isUserWithinRadio