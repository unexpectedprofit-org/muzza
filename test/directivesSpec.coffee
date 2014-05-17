describe "directives", ->

  beforeEach ->
    module 'Muzza.directives'
    module 'Muzza.templates'

  describe "Pizzas", ->

    $scope = element = undefined

    beforeEach ->
      inject ($compile, $rootScope) ->
        $scope = $rootScope
        $scope.menu = [
          title: "Muzza"
          id: 1
        ,
          title: "Fugazetta"
          id: 2
        ]
        element = angular.element('<pizzas ng-model="menu"></pizzas>')
        $compile(element)($rootScope)
        $scope.$digest()

    it "should display the 2 pizza menu items", ->
      expect(element.find('button').length).toBe 2
      expect(element.html()).toContain('Muzza')
      expect(element.html()).toContain('Fugazetta')

    it "should log when user clicks on the ADD button", ->
      inject ($log) ->
        log = spyOn($log, 'log')
        element.find('button')[0].click()
        expect(log).toHaveBeenCalledWith('added to cart: Muzza')






