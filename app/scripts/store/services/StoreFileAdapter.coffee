angular.module("Muzza.store").service "StoreFileAdapter", ($http, $log, branches) ->

  retrieveBranchesData = () ->
    branches.list

  getBranches: retrieveBranchesData