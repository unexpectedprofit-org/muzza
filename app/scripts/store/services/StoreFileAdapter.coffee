angular.module("Muzza.stores").service "StoreFileAdapter", ($http, $log) ->

  retrieveBranchesData = () ->

    $http(
      method: 'GET'
      url: '/data/branches.json'
    ).success( (data) ->
      return data

    ).error( (errors) ->
      $log.error "StoreFileAdapter:getBranches - ERROR"
      $log.error errors
    )


  getBranches: retrieveBranchesData