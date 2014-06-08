describe 'PromotionUtil', ->

  beforeEach ->
    module 'Muzza.promo'
    module 'Muzza.empanadas'

  PromotionUtil = Empanada = undefined
  empanada1 = empanada2 = empanada3 = undefined

  beforeEach ->
    inject ($injector) ->
      PromotionUtil = $injector.get 'PromotionUtil'
      Empanada = $injector.get 'Empanada'

      empanada1 = new Empanada {id:1,desc:'Nombre uno',subcat:1,qty:3}
      empanada2 = new Empanada {id:2,desc:'Nombre dos',subcat:1,qty:22}
      empanada3 = new Empanada {id:3,desc:'Nombre tres',subcat:4,qty:11,other:"othervalue"}


  describe "isProductApplicableToRule", ->

    it "should match", ->
      result = PromotionUtil.productMatchesRule empanada1, {cat:'EMPANADA',subcat:1}
      expect(result).toBeTruthy()

      result = PromotionUtil.productMatchesRule empanada1, {cat:'EMPANADA'}
      expect(result).toBeTruthy()

      result = PromotionUtil.productMatchesRule empanada2, {cat:'EMPANADA',subcat:1}
      expect(result).toBeTruthy()

      result = PromotionUtil.productMatchesRule empanada3, {cat:'EMPANADA',subcat:4}
      expect(result).toBeTruthy()

      result = PromotionUtil.productMatchesRule empanada3, {cat:'EMPANADA',subcat:4,other:"othervalue"}
      expect(result).toBeTruthy()

    it "should NOT match", ->
      result = PromotionUtil.productMatchesRule empanada2, {cat:'PIZZA'}
      expect(result).toBeFalsy()

      result = PromotionUtil.productMatchesRule empanada1, {cat:'EMPANADA',subcat:2}
      expect(result).toBeFalsy()

      result = PromotionUtil.productMatchesRule empanada3, {cat:'EMPANADA',subcat:4,other:"othervalue",onemore:"onemorevalue"}
      expect(result).toBeFalsy()


  describe "getApplicableProductsByRule", ->
    prodMenu = undefined

    beforeEach ->
      prodMenu = [
        id:1
        description: "category 1"
        products: [ empanada1, empanada2 ]
      ,
        id:4
        description: "category 2"
        products: [ empanada3 ]
      ]

    it "should get some products", ->
      result = PromotionUtil.filterProductsBySelection prodMenu, {cat:'EMPANADA'}
      expect(result.length).toBe 2
      expect(result[0].products.length).toBe 2
      expect(result[1].products.length).toBe 1

      result = PromotionUtil.filterProductsBySelection prodMenu, {cat:'EMPANADA',subcat:1}
      expect(result.length).toBe 1
      expect(result[0].products.length).toBe 2

      result = PromotionUtil.filterProductsBySelection prodMenu, {cat:'EMPANADA',subcat:4}
      expect(result.length).toBe 1
      expect(result[0].products.length).toBe 1


    it "should get no products", ->

      result = PromotionUtil.filterProductsBySelection prodMenu, {cat:'EMPANADA',subcat:2}
      expect(result.length).toBe 0

      result = PromotionUtil.filterProductsBySelection prodMenu, {cat:'EMPANADA',subcat:1,something:"somevalue"}
      expect(result.length).toBe 0

      result = PromotionUtil.filterProductsBySelection prodMenu, {cat:'EMPANADA',subcat:4,other:"othervalue",something:"somevalue"}
      expect(result.length).toBe 0