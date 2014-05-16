describe "controllers", ->

  beforeEach ->
    module "Muzza.controllers"

  it "should create a valid test", ->
    expect(true).toBe(true)

  describe "Menu", ->

    scope = undefined

    beforeEach ->
      inject ($controller, $rootScope) ->
        scope = $rootScope.$new()
        $controller "MenuCtrl",
          $scope: scope

    it "should get the menu items", ->
      expected = [
        {
          title: "Muzza"
          id: 1
        }
        {
          title: "Fugazetta"
          id: 2
        }
        {
          title: "Jamon y Morron"
          id: 3
        }
      ]

      expect(scope.menu).toEqual(expected)





