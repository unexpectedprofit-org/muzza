#xdescribe "Promotions", ->
#
#  beforeEach ->
#    module 'Muzza.promo'
#    module 'Muzza.templates'
#
#    module ($provide) ->
#      $provide.value 'ShoppingCartService',
#        null
#      null
#
#  PromotionTypeFactory = isolatedScope = $scope = element = undefined
#  promo1 = promo2 = promo3 = undefined
#
#  beforeEach ->
#    inject ($compile, $rootScope, _PromotionTypeFactory_) ->
#      PromotionTypeFactory = _PromotionTypeFactory_
#      $scope = $rootScope
#
#      promo1 = PromotionTypeFactory.createPromotion {id:3434,cat:1,desc:'1 docena de empanadas',rules:[{cat:'EMPANADA',qty:12,subcat:'|||'}]}
#      promo2 = PromotionTypeFactory.createPromotion {id:1100,cat:1,desc:'1 pizza grande + 6 empanadas al horno',rules:[{cat:'EMPANADA',qty:6,subcat:'|1||'},{cat:'PIZZA',qty:1,subcat:'||GRANDE|'}]}
#      promo3 = PromotionTypeFactory.createPromotion {id:2222,cat:1,desc:'6 empanadas fritas + 1 pizza INDIVIDUAL',rules:[{cat:'EMPANADA',qty:6,subcat:'|2||'},{cat:'PIZZA',qty:1,subcat:'||INVIDUAL|'}]}
#
#      $scope.menu = [
#        promo1
#        promo2
#        promo3
#      ]
#
#      element = angular.element('<promotions ng-model="menu"></promotions>')
#      $compile(element)($rootScope)
#      $scope.$digest()
#      isolatedScope = element.isolateScope()
#
#
#
#  describe "init", ->
#    it "should display the 3 promos listed on the menu", ->
#
#      expect(element.find('ion-item').length).toBe 3
#      expect(isolatedScope.menu[0].details.id).toBe 3434
#
#    it "should have a href bind", ->
#      onClickEvent = element.find('ion-item')[0].attributes['href'].nodeValue
#      expect(onClickEvent).toContain "#/app/menu/promo/3434"
#
#      onClickEvent = element.find('ion-item')[1].attributes['href'].nodeValue
#      expect(onClickEvent).toContain "#/app/menu/promo/1100"
#
#      onClickEvent = element.find('ion-item')[2].attributes['href'].nodeValue
#      expect(onClickEvent).toContain "#/app/menu/promo/2222"