describe 'PromoTypeQuantity', ->

  beforeEach ->
    module 'Muzza.promo'
    module 'Muzza.empanadas'
    module 'Muzza.pizzas'

  PromoTypeQuantity = Empanada = Pizza = promo = promoDetails = promoRules = undefined

  beforeEach ->
    inject ($injector) ->
      PromoTypeQuantity = $injector.get 'PromoTypeQuantity'
      Empanada = $injector.get 'Empanada'
      Pizza = $injector.get 'Pizza'

      promoDetails = {id:1,price:50,desc:"jojojo",details:"alalal"}
      promoRules = [qty:6,cat:'EMPANADA',subcat:'|||']

      promo = new PromoTypeQuantity {id:1,price:50,desc:"jojojo",details:"alalal",rules:promoRules}

  describe "init", ->

    it "should create an object from a different object", ->

      expect(promo.details.id).toEqual promoDetails.id
      expect(promo.details.price).toEqual promoDetails.price
      expect(promo.details.description.short).toEqual promoDetails.desc
      expect(promo.details.description.long).toEqual promoDetails.details
      expect(promo.rules).toEqual promoRules


  describe "Promo1: 12 empanadas cualquiera", ->

    beforeEach ->
      promo = new PromoTypeQuantity {price:767,rules:[{qty:12,cat:'EMPANADA',subcat:'|||'}]}


    describe "Basic Case", ->

      it "should validate if quantity met, same subcat", ->
        empanada = new Empanada {id:1,subcat:1,qty:12}

        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1"
            products: [ empanada ]
          ]

        response = promo.validate()
        expect(response.success).toBeTruthy()


    describe "More Cases", ->

      it "should validate when all same subcat: 1, different flavors", ->
        empanada1 = new Empanada {id:1,subcat:1,qty:6}
        empanada2 = new Empanada {id:2,subcat:1,qty:6}
        empanada3 = new Empanada {id:3,subcat:1,qty:0}

        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1"
            products: [ empanada1, empanada2, empanada3 ]
          ]

        response = promo.validate()
        expect(response.success).toBeTruthy()

      it "should validate when more than 1 subcat, different flavors", ->
        empanada1 = new Empanada {id:1,subcat:1,qty:4}
        empanada2 = new Empanada {id:2,subcat:2,qty:4}
        empanada3 = new Empanada {id:3,subcat:2,qty:4}
        empanada4 = new Empanada {id:4,subcat:2,qty:0}

        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1"
            products: [ empanada1, empanada2, empanada3 ]
          ,
            id:2
            description:"Another category"
            products: [ empanada4 ]
          ]

        response = promo.validate()
        expect(response.success).toBeTruthy()

      it "should NOT validate if quantity not met, only one product", ->
        empanada1 = new Empanada {id:1,subcat:1,qty:4}

        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1"
            products: [ empanada1 ]
          ]

        response = promo.validate()
        expect(response.success).toBeFalsy()
        expect(response.details).toContain {rule:promo.rules[0],cause:"quantity",qty:4}

      it "should NOT validate if quantity not met, several products", ->
        empanada1 = new Empanada {id:1,subcat:1,qty:8}
        empanada2 = new Empanada {id:2,subcat:1,qty:1}
        empanada3 = new Empanada {id:3,subcat:1,qty:0}

        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1"
            products: [ empanada1, empanada2, empanada3 ]
          ]

        response = promo.validate()
        expect(response.success).toBeFalsy()
        expect(response.details).toContain {rule:promo.rules[0],cause:"quantity",qty:9}

  describe "Promo2: 6 empanadas Fritas", ->

    beforeEach ->
      promo = new PromoTypeQuantity {price:555,rules:[{qty:6,cat:'EMPANADA',subcat:'|2||'}]}


    describe "Basic Case", ->

      it "should validate when all same subcat '2', only one product", ->
        empanada1 = new Empanada {id:1,subcat:2,qty:6}

        promo.components =
          EMPANADA: [
            id:2
            description:"Categoria 2 Ejemplo Fritas"
            products: [ empanada1 ]
          ]

        response = promo.validate()
        expect(response.success).toBeTruthy()


    describe "More Cases", ->

      it "should validate when all same subcat '2', several products", ->
        empanada1 = new Empanada {id:1,subcat:2,qty:2}
        empanada2 = new Empanada {id:2,subcat:2,qty:2}
        empanada3 = new Empanada {id:3,subcat:2,qty:2}

        promo.components =
          EMPANADA: [
            id:2
            description:"Categoria 2"
            products: [ empanada1, empanada2, empanada3 ]
          ]

        response = promo.validate()
        expect(response.success).toBeTruthy()

      it "should validate when more than 1 subcat, different flavors", ->
        empanada1 = new Empanada {id:1,subcat:2,qty:1}
        empanada2 = new Empanada {id:2,subcat:2,qty:2}
        empanada3 = new Empanada {id:3,subcat:1,qty:1}

        promo.components =
          EMPANADA: [
            id:2
            description:"Categoria 2"
            products: [ empanada1, empanada2 ]
          ,
            id:1
            description:"Another category"
            products: [ empanada3 ]
          ]

        response = promo.validate()
        expect(response.success).toBeFalsy()

  describe "Promo3: 2 empanadas cualquiera y 1 pizza especial", ->

    beforeEach ->
      promo = new PromoTypeQuantity {price:777,rules:[{qty:1,cat:'PIZZA',subcat:'|33||'},{qty:2,cat:'EMPANADA',subcat:'|||'}]}


    describe "Basic Case", ->

      it "should validate when 1 pizza especial and 2 any empanadas ", ->
        empanada1 = new Empanada {id:1,subcat:1,qty:0}
        empanada2 = new Empanada {id:2,subcat:1,qty:1}
        empanada3 = new Empanada {id:3,subcat:2,qty:1}

        pizza1 = new Pizza {id:1,subcat:33,qty:0}
        pizza2 = new Pizza {id:2,subcat:33,qty:1}

        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1"
            products: [ empanada1, empanada2 ]
          ,
            id:2
            description:"Another category"
            products: [ empanada3 ]
          ]
          PIZZA: [
            id:33
            description:"Categoria 1 Ejemplo pizzas especial"
            products: [ pizza1, pizza2 ]
          ]

        response = promo.validate()
        expect(response.success).toBeTruthy()


    describe "More Cases", ->

      it "should validate when 1 pizza especial and 2 any empanadas ", ->
        empanada1 = new Empanada {id:1,subcat:1,qty:1}
        empanada2 = new Empanada {id:2,subcat:1,qty:1}
        empanada3 = new Empanada {id:3,subcat:2,qty:0}

        pizza1 = new Pizza {id:1,subcat:33,qty:1}
        pizza2 = new Pizza {id:2,subcat:33,qty:0}

        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1"
            products: [ empanada1, empanada2 ]
          ,
            id:2
            description:"Another category"
            products: [ empanada3 ]
          ]
          PIZZA: [
            id:33
            description:"Categoria 1 Ejemplo pizzas especial"
            products: [ pizza1, pizza2 ]
          ]

        response = promo.validate()
        expect(response.success).toBeTruthy()

      it "should NOT validate if not pizza especial", ->
        empanada1 = new Empanada {id:1,subcat:1,qty:1}
        empanada2 = new Empanada {id:2,subcat:1,qty:2}

        pizza1 = new Pizza {id:1,subcat:22,qty:1}


        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1"
            products: [ empanada1, empanada2 ]
          ]
          PIZZA: [
            id:22
            description:"Another category not especial"
            products: [ pizza1 ]
          ]

        response = promo.validate()
        expect(response.success).toBeFalsy()

  describe "Promo4: 6 empanadas horno y 1 pizza especial grande", ->

    beforeEach ->
      promo = new PromoTypeQuantity {price:444,rules:[{qty:1,cat:'PIZZA',subcat:'|99|GRANDE|'},{qty:6,cat:'EMPANADA',subcat:'|1||'}]}


    describe "Basic Case", ->

      it "should validate when exaclty same products", ->
        empanada1 = new Empanada {id:1,subcat:1,qty:6}
        pizza1 = new Pizza {id:1,subcat:99,qty:1,size:"grande"}

        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1 - Horno"
            products: [ empanada1 ]
          ]
          PIZZA: [
            id:991
            description:"Categoria 1 Ejemplo pizzas especial"
            products: [ pizza1 ]
          ]

        response = promo.validate()
        expect(response.success).toBeTruthy()

    describe "More Cases", ->

      it "should validate when 6 empanadas horno y 1 pizza especial grande, several more products", ->
        empanada1 = new Empanada {id:1,subcat:1,qty:4}
        empanada2 = new Empanada {id:2,subcat:1,qty:2}
        empanada3 = new Empanada {id:3,subcat:2,qty:3}

        pizza1 = new Pizza {id:1,subcat:99,qty:1,size:"grande"}
        pizza2 = new Pizza {id:2,subcat:99,qty:0}

        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1"
            products: [ empanada1, empanada2 ]
          ,
            id:2
            description:"Another category"
            products: [ empanada3 ]
          ]
          PIZZA: [
            id:99
            description:"Categoria 1 Ejemplo pizzas especial"
            products: [ pizza1, pizza2 ]
          ]

        response = promo.validate()
        expect(response.success).toBeTruthy()

      it "should NOT validate when empanadas not horno", ->
        empanada1 = new Empanada {id:2,subcat:2,qty:6}
        pizza1 = new Pizza {id:1,subcat:99,qty:0}

        promo.components =
          EMPANADA: [
            id:2
            description:"Another category"
            products: [ empanada1 ]
          ]
          PIZZA: [
            id:99
            description:"Categoria 1 Ejemplo pizzas especial"
            products: [ pizza1 ]
          ]

        response = promo.validate()
        expect(response.success).toBeFalsy()

      it "should NOT validate when not 1 pizza grande", ->
        empanada1 = new Empanada {id:3,subcat:1,qty:6}
        empanada2 = new Empanada {id:2,subcat:1,qty:1}
        empanada3 = new Empanada {id:3,subcat:2,qty:1}

        pizza1 = new Pizza {id:2,subcat:99,qty:1}

        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1"
            products: [ empanada1 ]
          ]
          PIZZA: [
            id:99
            description:"Categoria 1 Ejemplo pizzas especial"
            products: [ pizza1 ]
          ]

        response = promo.validate()
        expect(response.success).toBeFalsy()

      it "should NOT validate when not 1 pizza especial", ->
        empanada1 = new Empanada {id:1,subcat:1,qty:6}
        pizza1 = new Pizza {id:2,subcat:7,qty:1}

        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1"
            products: [ empanada1 ]
          ]
          PIZZA: [
            id:7
            description:"Another Categoria"
            products: [ pizza1 ]
          ]

        response = promo.validate()
        expect(response.success).toBeFalsy()

  describe "Promo5: 12 empanadas horno y 2 pizza chica", ->

    beforeEach ->
      promo = new PromoTypeQuantity {price:333,rules:[{qty:2,cat:'PIZZA',subcat:'||CHICA|'},{qty:12,cat:'EMPANADA',subcat:'|1||'}]}


    describe "Basic case", ->

      it "should validate when exact same products", ->
        empanada1 = new Empanada {id:1,subcat:1,qty:12}
        pizza1 = new Pizza {id:9,subcat:1,qty:2,size:"chica"}

        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1"
            products: [ empanada1 ]
          ]
          PIZZA: [
            id:1
            description:"Another category not especial"
            products: [ pizza1 ]
          ]

        response = promo.validate()
        expect(response.success).toBeTruthy()


    describe "More cases", ->

      it "should validate when any empanadas and 2 pizzas chicas, different type", ->
        empanada1 = new Empanada {id:8,subcat:1,qty:4}
        empanada2 = new Empanada {id:9,subcat:1,qty:8}

        pizza1 = new Pizza {id:21,subcat:1,qty:1,size:"chica"}
        pizza2 = new Pizza {id:22,subcat:2,qty:1,size:"chica"}

        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1"
            products: [ empanada1, empanada2 ]
          ]
          PIZZA: [
            id:1
            description:"Another category not especial"
            products: [ pizza1, pizza2 ]
          ]

        response = promo.validate()
        expect(response.success).toBeTruthy()

      it "should NOT validate when no pizza chica", ->
        empanada1 = new Empanada {id:8,subcat:1,qty:12}
        pizza1 = new Pizza {id:22,subcat:1,qty:1,size:"mediana"}

        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1"
            products: [ empanada1 ]
          ]
          PIZZA: [
            id:1
            description:"Another category not especial"
            products: [ pizza1 ]
          ]

        response = promo.validate()
        expect(response.success).toBeFalsy()

      it "should NOT validate when only one pizza chica", ->
        empanada1 = new Empanada {id:8,subcat:1,qty:12}

        pizza1 = new Pizza {id:21,subcat:2,qty:1,size:"chica"}
        pizza2 = new Pizza {id:22,subcat:2,qty:1,size:"mediana"}

        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1"
            products: [ empanada1 ]
          ]
          PIZZA: [
            id:2
            description:"Another category not especial"
            products: [ pizza1, pizza2 ]
          ]

        response = promo.validate()
        expect(response.success).toBeFalsy()

  describe "Promo6: 1 Grande de Jamon", ->

    beforeEach ->
      promo = new PromoTypeQuantity {price:222,rules:[{qty:1,cat:'PIZZA',subcat:'21||GRANDE|'}]}


    describe "Basic case", ->

      it "should validate when exact same product", ->
        pizza1 = new Pizza {id:21,subcat:1,qty:1,size:"grande"}

        promo.components =
          PIZZA: [
            id:4
            description:"Another category not especial"
            products: [ pizza1 ]
          ]

        response = promo.validate()
        expect(response.success).toBeTruthy()


    describe "More cases", ->

      it "should NOT validate when pizza jamon, different size, any dough", ->
        pizza1 = new Pizza {id:21,subcat:1,qty:1,size:"mediana"}
        pizza2 = new Pizza {id:44,subcat:2,qty:0,size:"chica"}

        promo.components =
          PIZZA: [
            id:4
            description:"Another category not especial"
            products: [ pizza1, pizza2 ]
          ]

        response = promo.validate()
        expect(response.success).toBeFalsy()

      it "should NOT validate when pizza NOT jamon", ->
        pizza1 = new Pizza {id:99,subcat:1,qty:1,}
        pizza2 = new Pizza {id:44,subcat:2,qty:0}

        promo.components =
          PIZZA: [
            id:4
            description:"Another category not especial"
            products: [ pizza1, pizza2 ]
          ]

        response = promo.validate()
        expect(response.success).toBeFalsy()

  describe "Promo7: 5 empanadas horno, 6 fritas, 1 pizza de la casa", ->

    beforeEach ->
      promo = new PromoTypeQuantity {price:222,rules:[{qty:1,cat:'PIZZA',subcat:'|55||'},{qty:5,cat:'EMPANADA',subcat:'|1||'},{qty:6,cat:'EMPANADA',subcat:'|2||'}]}

    describe "Basic", ->

      it "should validate", ->

        empanada1 = new Empanada {id:11,subcat:1,qty:2}
        empanada2 = new Empanada {id:12,subcat:1,qty:2}
        empanada3 = new Empanada {id:13,subcat:1,qty:1}

        empanada4 = new Empanada {id:20,subcat:2,qty:3}
        empanada5 = new Empanada {id:21,subcat:2,qty:3}

        empanada6 = new Empanada {id:24,subcat:2,qty:0}
        empanada7 = new Empanada {id:25,subcat:2,qty:0}
        empanada8 = new Empanada {id:26,subcat:2,qty:0}

        pizza1 = new Pizza {id:1,subcat:55,qty:1}

        promo.components =
          EMPANADA: [
            id:1
            description:"Categoria 1 - Horno"
            products: [ empanada1, empanada2, empanada3 ]
          ,
            id:2
            description:"Categoria 2 - Fritas"
            products: [ empanada4, empanada5, empanada6, empanada7, empanada8 ]
          ]
          PIZZA: [
            id:55
            description:"Categoria 1 Ejemplo pizzas de la casa"
            products: [ pizza1 ]
          ]

        response = promo.validate()
        expect(response.success).toBeTruthy()