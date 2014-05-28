describe 'PromoTypeQuantity', ->

  beforeEach ->
    module 'Muzza.promo'

  PromoTypeQuantity = promo = undefined


  describe "Promo1: 12 empanadas cualquiera", ->

    beforeEach ->
      inject ($injector) ->
        PromoTypeQuantity = $injector.get 'PromoTypeQuantity'

        promo = new PromoTypeQuantity [{qty:12,cat:'EMPANADA'}]

    describe "Init", ->

      it 'should construct a Promo object', ->
        expect(promo.validate).toBeDefined()
        expect(promo.apply).toBeDefined()

        expect(promo.rules).toEqual [{cat:'EMPANADA',subcat:undefined,qty:12}]


    describe "", ->

      it "should NOT validate if cat not empanada", ->
        shoppingCart = [
          {
            cat: 'SOMETHING'
            subcat: 'H'
            qty: 12
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if quantity not met, only one product", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'H'
            qty: 8
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if quantity not met, several products", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 4
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 4
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should validate when all same subcat 'H', all same flavors", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'H'
            qty: 12
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when all same subcat 'F', all same flavors", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'F'
            qty: 12
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when all same subcat 'H', different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 4
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 4
          id: 2
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 4
          id: 3
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when all same subcat 'F', different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 4
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 4
          id: 2
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 4
          id: 3
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when more than 1 subcat, different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 6
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 6
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeTruthy()


  describe "Promo2: 12 empanadas al Horno", ->

    beforeEach ->
      inject ($injector) ->
        PromoTypeQuantity = $injector.get 'PromoTypeQuantity'

        promo = new PromoTypeQuantity [{qty:12,cat:'EMPANADA',subcat:'H'}]

    describe "Init", ->

      it 'should construct a Promo object', ->
        expect(promo.validate).toBeDefined()
        expect(promo.apply).toBeDefined()

        expect(promo.rules).toEqual [{cat:'EMPANADA',subcat:'H',qty:12}]

    describe "", ->

      it "should NOT validate if cat not empanada", ->
        shoppingCart = [
          {
            cat: 'SOMETHING'
            subcat: 'H'
            qty: 12
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if subcat not met, only one product", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'F'
            qty: 12
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if subcat not met, several products", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 4
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 4
          id: 2
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 4
          id: 3
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if quantity not met, only one product", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'H'
            qty: 8
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if quantity not met, several products", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 4
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 4
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should validate when all same subcat 'H', only one product", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'H'
            qty: 12
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when all same subcat 'H', several products", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 6
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 6
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when more than 1 subcat, different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 6
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 12
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeTruthy()


  describe "Promo3: 6 empanadas Fritas", ->

    beforeEach ->
      inject ($injector) ->
        PromoTypeQuantity = $injector.get 'PromoTypeQuantity'

        promo = new PromoTypeQuantity [{qty:6,cat:'EMPANADA',subcat:'F'}]

    describe "Init", ->

      it 'should construct a Promo object', ->
        expect(promo.validate).toBeDefined()
        expect(promo.apply).toBeDefined()

        expect(promo.rules).toEqual [{cat:'EMPANADA',subcat:'F',qty:6}]

    describe "", ->

      it "should NOT validate if cat not empanada", ->
        shoppingCart = [
          {
            cat: 'SOMETHING'
            subcat: 'H'
            qty: 12
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if subcat not met, only one product", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'H'
            qty: 7
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if subcat not met, several products", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 4
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 4
          id: 2
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 4
          id: 3
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if quantity not met, only one product", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'F'
            qty: 5
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if quantity not met, several products", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 2
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 2
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should validate when all same subcat 'F', only one product", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'F'
            qty: 6
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when all same subcat 'F', several products", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 3
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 3
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when more than 1 subcat, different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 6
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 6
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeTruthy()


  describe "Promo4: 2 empanadas cualquiera y 1 pizza especial", ->

    beforeEach ->
      inject ($injector) ->
        PromoTypeQuantity = $injector.get 'PromoTypeQuantity'

        promo = new PromoTypeQuantity [{qty:1,cat:'PIZZA',subcat:'ESPECIAL'},{qty:2,cat:'EMPANADA'}]

    describe "Init", ->

      it 'should construct a Promo object', ->
        expect(promo.validate).toBeDefined()
        expect(promo.apply).toBeDefined()

        expect(promo.rules).toEqual [{qty:1,cat:'PIZZA',subcat:'ESPECIAL'},{qty:2,cat:'EMPANADA',subcat:undefined}]

    describe "", ->

      it "should NOT validate if empanada not present", ->
        shoppingCart = [
          {
            cat: 'PIZZA'
            subcat: 'ESPECIAL'
            qty: 1
            id: 2
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if pizza not present", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'H'
            qty: 2
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if pizza subcat not met", ->
        shoppingCart = [
          cat: 'EMPANADA'
          qty: 2
          id: 1
        ,
          cat: 'PIZZA'
          subcat: 'NOT-ESPECIAL'
          qty: 1
          id: 1
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should validate when 1 pizza especial and 2 empanadas same subcat", ->
        shoppingCart = [
          cat: 'PIZZA'
          subcat: 'ESPECIAL'
          qty: 1
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 2
          id: 1
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when 1 pizza especial and 2 empanadas different subcat", ->
        shoppingCart = [
          cat: 'PIZZA'
          subcat: 'ESPECIAL'
          qty: 1
          id: 0
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 1
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 1
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeTruthy()