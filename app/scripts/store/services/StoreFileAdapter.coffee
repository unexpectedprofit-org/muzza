angular.module("Muzza.store").service "StoreFileAdapter", ($http, $log, branches, $q) ->

  retrieveBranchesData = () ->
    deferred = $q.defer()
    deferred.resolve({data: branches.list})
    return deferred.promise

  getBranches: retrieveBranchesData