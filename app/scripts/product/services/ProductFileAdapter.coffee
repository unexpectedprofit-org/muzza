angular.module("Muzza.product").service "ProductFileAdapter", ($http, $log) ->

  retrieveMenuData = () ->

    $http(
      method: 'GET'
      url: '/data/menu.json'
    ).success( (data) ->
      return data

    ).error( (errors) ->
      $log.error "ProductFileAdapter:getMenu - ERROR"
      $log.error errors
    )


  getMenu: retrieveMenuData