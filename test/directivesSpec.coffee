describe "directives", ->

  beforeEach ->
    module 'ionic'
    module 'Muzza.directives'
    module 'Muzza.templates'

  describe "Pizzas", ->

    isolatedScope = $scope = element = undefined

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
        isolatedScope = element.isolateScope()

    describe "init", ->

      it "should display the 2 pizza menu items", ->
        expect(element.find('button').length).toBe 2
        expect(element.html()).toContain('Muzza')
        expect(element.html()).toContain('Fugazetta')

      it "should an empty selected pizzas collection", ->
        expect(isolatedScope.pizzas.length).toBe 0

      it "should load the templates for the steps", ->
        isolatedScope.steps = ['size', 'dough']
        expect(isolatedScope.size).toBeDefined()
        expect(isolatedScope.dough).toBeDefined()


    describe "When user chooses a product", ->

      it "should show all modals for available steps", ->
        isolatedScope.steps = ['size', 'dough']
        showSize = spyOn(isolatedScope.size, 'show')
        showDough = spyOn(isolatedScope.dough, 'show')
        element.find('button')[0].click()
        expect(showSize).toHaveBeenCalled()
        expect(showDough).toHaveBeenCalled()

      it "should log when user selected the add option on the order step", ->
        inject ($log) ->
          isolatedScope.steps = ['order','size', 'dough']
          log = spyOn($log, 'log')
          element.find('button')[0].click()
          isolatedScope.size.choose('b')
          isolatedScope.dough.choose('a')
          isolatedScope.order.add()
          expect(log).toHaveBeenCalledWith('added to cart: [{"title":"Muzza","id":1,"size":"b","dough":"a"}]')






