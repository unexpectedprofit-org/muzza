describe "Promotions", ->

  beforeEach ->
    module 'ionic'
    module 'Muzza.promo'
    module 'Muzza.templates'
    module 'Muzza.directives'

    module ($provide) ->
      $provide.value 'ShoppingCartService',
        null
      null

  Promotion = isolatedScope = $scope = element = undefined
  promo1 = promo2 = promo3 = undefined

  beforeEach ->
    inject ($compile, $rootScope, _Promotion_) ->
      Promotion = _Promotion_
      $scope = $rootScope

      promo1 = new Promotion {id:3434,desc:'1 docena de empanadas',rules:[{cat:'EMPANADA',qty:12,subcat:'|||'}]}
      promo2 = new Promotion {id:1100,desc:'1 pizza grande + 6 empanadas al horno',rules:[{cat:'EMPANADA',qty:6,subcat:'|HORNO||'},{cat:'PIZZA',qty:1,subcat:'||GRANDE|'}]}
      promo3 = new Promotion {id:2222,desc:'6 empanadas fritas + 1 pizza al molde',rules:[{cat:'EMPANADA',qty:6,subcat:'|||MOLDE'}]}

      $scope.menu = [
        promo1
        promo2
        promo3
      ]

      element = angular.element('<promotions ng-model="menu"></promotions>')
      $compile(element)($rootScope)
      $scope.$digest()
      isolatedScope = element.isolateScope()



  describe "init", ->
    it "should display the 3 promos listed on the menu", ->

      expect(element.find('ion-item').length).toBe 3

      expect(isolatedScope.menu[0] instanceof Promotion).toBeTruthy()
      expect(isolatedScope.menu[0].id).toBe 3434

    it "should have a click function bind", ->
      onClickEvent = element.find('ion-item')[0].attributes['data-ng-click'].nodeValue

      expect(onClickEvent).toContain "choose(promo)"

    it "should have steps defined in the scope", ->
      expect(isolatedScope.steps).toEqual ['details']

    it "should load the templates for all the steps", ->
      isolatedScope.steps = ['details']
      expect(isolatedScope.details).toBeDefined()

    it "should have a product defined in the scope", ->
      expect(isolatedScope.promotion).toBeDefined()

    it "should have functions defined in the scope", ->
      expect(isolatedScope.choose).toBeDefined()


  describe "When user chooses a promotion", ->

    it "should show all modals for available steps", ->
      isolatedScope.steps = ['details']
      showDetails = spyOn(isolatedScope.details, 'show')
      element.find('ion-item')[0].click()

      expect(showDetails).toHaveBeenCalled()

    it 'should create a Promotion model from the item picked from the menu', ->
      element.find('ion-item')[0].click()
      expect(isolatedScope.promotion instanceof Promotion).toBeTruthy()

    it "should replace the previous selection", ->
      isolatedScope.steps = ['details']
      showType = spyOn(isolatedScope.details, 'show')

      #Choose First Product
      element.find('ion-item')[0].click()

      expect(isolatedScope.promotion.id).toEqual promo1.id

      #Choose Second Product
      element.find('ion-item')[1].click()

      expect(isolatedScope.promotion.id).toEqual promo2.id