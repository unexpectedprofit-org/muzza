angular.module("Muzza.product").service "ProductFileAdapter", ($http, $log, menu, $q) ->

  retrieveMenuData = () ->
    deferred = $q.defer()
    deferred.resolve({data: menu.products})
    return deferred.promise


  getMenu: retrieveMenuData