describe "Promotions", ->

  beforeEach ->
    module 'ionic'
    module 'Muzza.promo'
    module 'Muzza.templates'
    module 'Muzza.directives'
    module 'Muzza.services'

    module ($provide) ->
      $provide.value 'ShoppingCartService',
        null
      null

  PromotionTypeFactory = isolatedScope = $scope = element = undefined
  promo1 = promo2 = promo3 = undefined

  beforeEach ->
    inject ($compile, $rootScope, _PromotionTypeFactory_) ->
      PromotionTypeFactory = _PromotionTypeFactory_
      $scope = $rootScope

      promo1 = PromotionTypeFactory.createPromotion {id:3434,cat:1,desc:'1 docena de empanadas',rules:[{cat:'EMPANADA',qty:12,subcat:'|||'}]}
      promo2 = PromotionTypeFactory.createPromotion {id:1100,cat:1,desc:'1 pizza grande + 6 empanadas al horno',rules:[{cat:'EMPANADA',qty:6,subcat:'|1||'},{cat:'PIZZA',qty:1,subcat:'||GRANDE|'}]}
      promo3 = PromotionTypeFactory.createPromotion {id:2222,cat:1,desc:'6 empanadas fritas + 1 pizza INDIVIDUAL',rules:[{cat:'EMPANADA',qty:6,subcat:'|2||'},{cat:'PIZZA',qty:1,subcat:'||INVIDUAL|'}]}

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
      expect(isolatedScope.menu[0].details.id).toBe 3434

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

    it 'should set to the scope the Promotion model picked from the menu', ->
      element.find('ion-item')[0].click()
      expect(isolatedScope.promotion).toBe promo1

    it "should replace the previous selection", ->
      isolatedScope.steps = ['details']
      showType = spyOn(isolatedScope.details, 'show')

      #Choose First Product
      element.find('ion-item')[0].click()

      expect(isolatedScope.promotion.id).toEqual promo1.id

      #Choose Second Product
      element.find('ion-item')[1].click()

      expect(isolatedScope.promotion.id).toEqual promo2.id


  describe "setQuantitiesToZero", ->

    it "should return all products with zero quantities", ->

      prod = [
        {
          id:1
          description:"Category 1"
          products: [ {id:1,qty:2},{id:2,qty:3} ]
        },
        {
          id:2
          description:"Category 2"
          products: [{id:9,qty:5}]
        }
      ]

      updatedProducts = isolatedScope.setQuantitiesToZero prod
      expect(updatedProducts[0].products[0].qty).toBe 0
      expect(updatedProducts[0].products[1].qty).toBe 0
      expect(updatedProducts[1].products[0].qty).toBe 0

  describe "createPromoComponentsList functionality", ->

    ProductService = undefined

    beforeEach ->
      inject ($injector) ->
        ProductService = $injector.get 'ProductService'

    it "should retrieve all empanadas products", ->
      rules = [
        cat: 'EMPANADA'
        qty: 12
        subcat: '|||'
      ]

      productsList = isolatedScope.createPromoComponentsList rules

      expect(productsList.length).toBe 1
      expect(productsList[0].cat).toBe rules[0].cat
      expect(productsList[0].items.length).toBe 2
      expect(productsList[0].items[0].products.length).toBe 6
      expect(productsList[0].items[1].products.length).toBe 3


    it "should retrieve only empanadas FRITAS products", ->
      rules = [
        cat: 'EMPANADA'
        qty: 12
        subcat: '|2||'
      ]

      productsList = isolatedScope.createPromoComponentsList rules

      expect(productsList.length).toBe 1
      expect(productsList[0].cat).toBe rules[0].cat
      expect(productsList[0].items.length).toBe 1
      expect(productsList[0].items[0].products.length).toBe 3

    it "should retrieve only empanadas HORNO + all pizzas", ->
      rules = [
        cat: 'EMPANADA'
        qty: 12
        subcat: '|1||'
      ,
        cat: 'PIZZA'
        qty: 1
        subcat: '|||'
      ]

      productsList = isolatedScope.createPromoComponentsList rules

      expect(productsList.length).toBe 2
      expect(productsList[0].cat).toBe rules[0].cat
      expect(productsList[0].items.length).toBe 1
      expect(productsList[0].items[0].products.length).toBe 6

      expect(productsList[1].cat).toBe rules[1].cat
      expect(productsList[1].items.length).toBe 2
      expect(productsList[1].items[0].products.length).toBe 4
      expect(productsList[1].items[1].products.length).toBe 2

    it "should retrieve only empanadas HORNO + only pizzas de la casa", ->
      rules = [
        cat: 'EMPANADA'
        qty: 12
        subcat: '|1||'
      ,
        cat: 'PIZZA'
        qty: 1
        subcat: '|2||'
      ]

      productsList = isolatedScope.createPromoComponentsList rules

      expect(productsList.length).toBe 2
      expect(productsList[0].cat).toBe rules[0].cat
      expect(productsList[0].items.length).toBe 1
      expect(productsList[0].items[0].products.length).toBe 6

      expect(productsList[1].cat).toBe rules[1].cat
      expect(productsList[1].items.length).toBe 1
      expect(productsList[1].items[0].products.length).toBe 2