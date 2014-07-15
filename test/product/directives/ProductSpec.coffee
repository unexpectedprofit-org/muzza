describe 'Product Directive', ->

  beforeEach ->
    module 'Muzza.product'
    module 'Muzza.templates'
    module 'Muzza.directives'
    module 'ionic'

    module ($provide) ->
      $provide.value 'ShoppingCartService',
        add: () ->
      null

  isolatedScope = undefined

  describe "init", ->

    Product = element = undefined

    beforeEach ->
      inject ($compile, $rootScope, $injector) ->
        Product = $injector.get 'Product'
        $scope = $rootScope
        $scope.menu = [
          id:1
          description: "Bebidas"
          products:[
            id:2
          ,
            id:3
          ,
            id:4
          ]
        ,
          id:2
          description:"Pastas"
          products:[
            id:9
          ,
            id:10
          ]
        ]

        element = angular.element('<product data-ng-model="menu"></product>')
        $compile(element)($rootScope)
        $scope.$digest()
        isolatedScope = element.isolateScope()

    it "should have a click function bound", ->
      onClickEvent = element.find('ion-item')[0].attributes['data-ng-click'].nodeValue

      expect(onClickEvent).toContain "chooseProduct(product)"

    it "should have functions defined in the scope", ->
      expect(isolatedScope.chooseProduct).toBeDefined()