#describe 'PromotionService', ->
#
#  beforeEach ->
#    module 'Muzza.promo'
#    module 'Muzza.services'
#
#    module ($provide) ->
#      $provide.value 'ProductService',
#        getMenu: () -> null
#      null
#
#  Empanada = ProductService = PromotionService = productsSpy = undefined
#  empanada1 = empanada2 = empanada3 = empanada4 = empanada5 = undefined
#
#  beforeEach ->
#    inject ($injector) ->
#      PromotionService = $injector.get 'PromotionService'
#      ProductService = $injector.get 'ProductService'
#      Empanada = $injector.get 'Empanada'
#
#      empanada1 = new Empanada {id:1,desc:'Nombre uno',subcat:1,qty:1}
#      empanada2 = new Empanada {id:2,desc:'Nombre dos',subcat:1,qty:1}
#      empanada3 = new Empanada {id:3,desc:'Nombre tres',subcat:1,qty:1}
#      empanada4 = new Empanada {id:4,desc:'Nombre cuatro',subcat:2,qty:1}
#      empanada5 = new Empanada {id:5,desc:'Nombre cinco',subcat:2,qty:1}
#
#      response = [
#        id:1
#        description:"Al Horno"
#        products: [ empanada1, empanada2, empanada3 ]
#      ,
#        id:2
#        description:"Fritanga"
#        products: [ empanada4, empanada5 ]
#      ]
#
#      productsSpy = spyOn(ProductService, 'getMenu').and.callFake( () -> response )
#
#  describe "createPromotionComponentsList", ->
#
#    it "should call service", ->
#      rules = [
#        {properties:{cat:'EMPANADA',subcat:2}}
#      ]
#      PromotionService.createPromotionComponentsList rules
#
#      expect(productsSpy).toHaveBeenCalledWith undefined, rules[0].properties.cat
#
#    it "should retrieve only one empanadas subcat", ->
#      rules = [
#        {properties:{cat:'EMPANADA',subcat:2}}
#      ]
#      result = PromotionService.createPromotionComponentsList rules
#
#      expect(result['EMPANADA']).toBeDefined()
#      expect(result['EMPANADA'].length).toBe 1
#      expect(result['EMPANADA'][0].ruleId).toBe rules[0].id
#      expect(result['EMPANADA'][0].description).toBe "Fritanga"
#      expect(result['EMPANADA'][0].products.length).toBe 2