angular.module("Muzza.product").service "ProductFileAdapter", ($http, $log, menu) ->

  retrieveMenuData = () ->
    menu.products

  getMenu: retrieveMenuData