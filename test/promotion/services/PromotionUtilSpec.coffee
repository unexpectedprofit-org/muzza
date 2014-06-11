describe 'PromotionUtil', ->

  beforeEach ->
    module 'Muzza.promo'
    module 'Muzza.empanadas'
    module 'Muzza.pizzas'

  PromotionUtil = Empanada = Pizza = undefined
  empanada1 = empanada2 = empanada3 = undefined

  beforeEach ->
    inject ($injector) ->
      PromotionUtil = $injector.get 'PromotionUtil'
      Empanada = $injector.get 'Empanada'
      Pizza = $injector.get 'Pizza'

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


  describe "getPromotionProducts", ->

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

    describe "getApplicableProductsByRule", ->

      it "should get some products", ->
        result = PromotionUtil.getPromotionProducts prodMenu, {cat:'EMPANADA'}
        expect(result.length).toBe 2
        expect(result[0].products.length).toBe 2
        expect(result[1].products.length).toBe 1

        result = PromotionUtil.getPromotionProducts prodMenu, {cat:'EMPANADA',subcat:1}
        expect(result.length).toBe 1
        expect(result[0].products.length).toBe 2

        result = PromotionUtil.getPromotionProducts prodMenu, {cat:'EMPANADA',subcat:4}
        expect(result.length).toBe 1
        expect(result[0].products.length).toBe 1


      it "should get no products", ->

        result = PromotionUtil.getPromotionProducts prodMenu, {cat:'EMPANADA',subcat:2}
        expect(result.length).toBe 0

        result = PromotionUtil.getPromotionProducts prodMenu, {cat:'EMPANADA',subcat:1,something:"somevalue"}
        expect(result.length).toBe 0

        result = PromotionUtil.getPromotionProducts prodMenu, {cat:'EMPANADA',subcat:4,other:"othervalue",something:"somevalue"}
        expect(result.length).toBe 0


    describe "setDefaultValues", ->

      it "should set all quantities to zero", ->
        rule = {cat:'EMPANADA'}
        result = PromotionUtil.getPromotionProducts prodMenu, rule

        expect(result[0].products[0].qty).toBe 0
        expect(result[0].products[1].qty).toBe 0
        expect(result[1].products[0].qty).toBe 0


    describe "PIZZA model", ->

      prodMenu = undefined

      beforeEach ->
        pizza1 = new Pizza {id:2,subcat:100}
        pizza2 = new Pizza {id:3,subcat:200}
        pizza3 = new Pizza {id:4,subcat:200}

        prodMenu = [
          id:100
          description: "category 1"
          products: [ pizza1 ]
        ,
          id:200
          description: "category 2"
          products: [ pizza2, pizza3 ]
        ]

      it "should set size from rule", ->
        rule = {cat:'PIZZA',size:"grande"}
        result = PromotionUtil.getPromotionProducts prodMenu, rule

        expect(result.length).toBe prodMenu.length
        expect(result[0].products.length).toBe prodMenu[0].products.length
        expect(result[1].products.length).toBe prodMenu[1].products.length

        expect(result[0].products[0].size).toBe rule.size
        expect(result[1].products[0].size).toBe rule.size
        expect(result[1].products[1].size).toBe rule.size

  describe "sortRulesByRuleId", ->

    it "should sort and have rule1 first ", ->
      rule1 = {id:"rule:EMPANADA|1",properties:{cat:"EMPANADA",subcat:1}}
      rule2 = {id:"rule:EMPANADA|2",properties:{cat:"EMPANADA",subcat:2}}

      result = PromotionUtil.sortRulesByRuleId [rule1,rule2]
      expect(result.length).toBe 2
      expect(result[0].id).toBe "rule:EMPANADA|1"
      expect(result[1].id).toBe "rule:EMPANADA|2"

    it "should sort and have rule1 first", ->
      rule1 = {id:"rule:EMPANADA|1",properties:{cat:"EMPANADA",subcat:1}}
      rule2 = {id:"rule:EMPANADA|2",properties:{cat:"EMPANADA",subcat:2}}

      result = PromotionUtil.sortRulesByRuleId [rule2,rule1]
      expect(result.length).toBe 2
      expect(result[0].id).toBe "rule:EMPANADA|1"
      expect(result[1].id).toBe "rule:EMPANADA|2"

    it "should sort and show empanadas first", ->
      rule1 = {id:"rule:EMPANADA|1",properties:{cat:"EMPANADA",subcat:1}}
      rule2 = {id:"rule:PIZZA|2|GRANDE",properties:{cat:"PIZZA",subcat:2,size:"grande"}}
      rule3 = {id:"rule:PIZZA|1|CHICA",properties:{cat:"PIZZA",subcat:1,size:"chica"}}
      rule4 = {id:"rule:PIZZA|1|MEDIANA",properties:{cat:"PIZZA",subcat:1,size:"mediana"}}
      rule5 = {id:"rule:EMPANADA|2",properties:{cat:"EMPANADA",subcat:2}}

      result = PromotionUtil.sortRulesByRuleId [rule2,rule4,rule1,rule3,rule5]
      expect(result.length).toBe 5
      expect(result[0].id).toBe "rule:EMPANADA|1"
      expect(result[1].id).toBe "rule:EMPANADA|2"
      expect(result[2].id).toBe "rule:PIZZA|1|CHICA"
      expect(result[3].id).toBe "rule:PIZZA|1|MEDIANA"
      expect(result[4].id).toBe "rule:PIZZA|2|GRANDE"