#describe "PromotionDetails", ->
#
#  scope = rootScope = ProductService = PromotionService = ShoppingCartService = Empanada = PromotionTypeFactory = undefined
#  productSpy = promoSpy = createController = state = undefined
#
#  beforeEach ->
#    module "Muzza.promo"
#    module "Muzza.cart"
#
#    module ($provide) ->
#      $provide.value 'ProductService',
#        getMenu: (storeId, categoryId)->
#          inject (_PromotionTypeFactory_) ->
#            PromotionTypeFactory = _PromotionTypeFactory_
#
#          myRules1 = [{qty:10,properties:{cat:'EMPANADA',subcat:2}}]
#          myRules2 = [{qty:40,properties:{cat:'PIZZA',subcat:1}}]
#          promo1 = PromotionTypeFactory.createPromotion {cat:1,id:1,price:1,rules:myRules1}
#          promo2 = PromotionTypeFactory.createPromotion {cat:1,id:2,price:200,rules:myRules2}
#
#          {
#            promo: [promo1, promo2]
#          }
#
#      $provide.value 'PromotionService',
#        createPromotionComponentsList: (rules) ->
#          inject (_Empanada_) ->
#            Empanada = _Empanada_
#
#          response =
#            EMPANADA: [
#              id:2
#              products: [ new Empanada {id:1,cat:'EMPANADA',subcat:2}]
#            ]
#
#          response
#
#      $provide.value 'ShoppingCartService',
#        add: () -> null
#
#      $provide.value '$state',
#        go: () -> null
#
#      null
#
#  beforeEach ->
#    inject ($controller, $rootScope, $injector, $state) ->
#
#      ProductService = $injector.get 'ProductService'
#      PromotionService = $injector.get 'PromotionService'
#      ShoppingCartService = $injector.get 'ShoppingCartService'
#      state = $state
#
#      productSpy = spyOn(ProductService, 'getMenu').and.callThrough()
#      promoSpy = spyOn(PromotionService, 'createPromotionComponentsList').and.callThrough()
#
#      scope = $rootScope.$new()
#      createController = () ->
#        $controller "PromotionDetails",
#          $scope: scope
#          $stateParams: {promoId: 1}
#          ProductService: ProductService
#          PromotionService: PromotionService
#          ShoppingCartService: ShoppingCartService
#          $state: state
#
#  it "should call Product service", ->
#    createController()
#    expect(productSpy).toHaveBeenCalledWith('', 'promo')
#
#  it "should call Promotion service", ->
#    createController()
#    expect(promoSpy).toHaveBeenCalledWith [{id:"rule:EMPANADA|2",qty:10,properties:{cat:'EMPANADA',subcat:2}}]
#
#  xit "should watch on promotions", ->
#    createController()
#
#    expect(scope.isSelectionValid.success).toBeFalsy()
#    console.log "empanada: " + JSON.stringify scope.promotion.components['EMPANADA'][0].products[0]
#    scope.promotion.components['EMPANADA'][0].products[0].qty = 10
#    console.log "empanada: " + JSON.stringify scope.promotion.components['EMPANADA'][0].products[0]
#
#    scope.promotion.validate()
#    console.log JSON.stringify scope.isSelectionValid
#
#    expect(scope.isSelectionValid).toBeTruthy()
#
#  describe "choose functionality", ->
#
#    promo = undefined
#
#    beforeEach ->
#      inject (PromotionTypeFactory) ->
#        promo = PromotionTypeFactory.createPromotion {cat:1,id:1,price:1,rules:[{qty:10,properties:{cat:'EMPANADA',subcat:2}}]}
#
#    it "should call Shopping cart service", ->
#      addSpy = spyOn(ShoppingCartService, 'add')
#      createController()
#
#      scope.choose promo
#
#      expect(addSpy).toHaveBeenCalledWith jasmine.objectContaining
#        id: promo.details.id
#        rules: promo.rules
#
#    it "should redirect to promo view", ->
#      promo = PromotionTypeFactory.createPromotion {cat:1,id:1,price:1,rules:[{qty:10,properties:{cat:'EMPANADA',subcat:2}}]}
#
#      goSpy = spyOn(state, 'go')
#      createController()
#
#      scope.choose promo
#
#      expect(goSpy).toHaveBeenCalledWith( "app.category", {category: 'promo'})
