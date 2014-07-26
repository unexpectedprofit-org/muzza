angular.module("Muzza.store").service "StoreService", (StoreFileAdapter, $q, Store) ->

  @store = undefined

  getStores = () ->
    StoreFileAdapter.getBranches().then (response) ->
      createStore = (elem) -> new Store elem
      return _.map(response.data, createStore)

  setStore = (store)->
    deferred = $q.defer()
    @store = store
    deferred.resolve()
    deferred.promise

  getStore = ->
    @store

  listStores: getStores
  chooseStore: setStore
  retrieveSelectedStore: getStore
