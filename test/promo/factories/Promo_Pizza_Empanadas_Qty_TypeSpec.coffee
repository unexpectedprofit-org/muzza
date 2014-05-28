describe 'Promo_Pizza_Empanadas_Qty_Type', ->

  beforeEach ->
    module 'Muzza.promo'

  Promo_Pizza_Empanadas_Qty_Type = promo = undefined


  describe "1 pizza especial y 6 empanadas al horno", ->

    beforeEach ->
      inject ($injector) ->
        Promo_Pizza_Empanadas_Qty_Type = $injector.get 'Promo_Pizza_Empanadas_Qty_Type'

        promo = new Promo_Pizza_Empanadas_Qty_Type 'ESPECIAL', 1, 'H', 6

    describe "Init", ->

      it 'should construct a Promo object', ->
        expect(promo.validate).toBeDefined()
        expect(promo.apply).toBeDefined()

        expect(promo.rules).toEqual [{cat:'EMPANADA',subcat:'H',qty:6},{cat:'PIZZA',subcat:'ESPECIAL',qty:1}]

    describe "only 1 pizza especial y 6 empanadas al horno", ->

      it "should validate when all empanadas same subcat, all same flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 6
          id: 1
        ,
          cat: 'PIZZA'
          subcat: 'ESPECIAL'
          qty: 1
          id: 1
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when all empanadas same subcat, different flavors", ->
        shoppingCart = [
          cat: 'PIZZA'
          subcat: 'ESPECIAL'
          qty: 1
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 4
          id: 2
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 2
          id: 3
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

    describe "several items and 1 pizza especial y 6 empanadas al horno", ->

      it "should validate", ->

        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 6
          id: 1
        ,
          cat: 'PIZZA'
          subcat: 'NOT-ESPECIAL'
          qty: 6
          id: 1
        ,
          cat: 'PIZZA'
          subcat: 'ESPECIAL'
          qty: 1
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 6
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 4
          id: 2

        ]
        expect(promo.validate shoppingCart).toBeTruthy()

    describe "no pizza and 6 empanadas al horno", ->

      it "should NOT when all empanadas same subcat, all same flavors", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'H'
            qty: 6
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT when all empanadas same subcat, different flavors", ->
        shoppingCart = [
            cat: 'EMPANADA'
            subcat: 'H'
            qty: 4
            id: 1
          ,
            cat: 'EMPANADA'
            subcat: 'H'
            qty: 2
            id: 2
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

    describe "no 'ESPECIAL' pizza and 6 empanadas al horno", ->

      it "should NOT when all empanadas same subcat, all same flavors and pizza no especial", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 6
          id: 1
        ,
          cat: 'PIZZA'
          subcat: 'NOT-ESPECIAL'
          qty: 1
          id: 1
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT when all empanadas same subcat, different flavors and pizza no especial", ->
        shoppingCart = [
          cat: 'PIZZA'
          subcat: 'NOT-ESPECIAL'
          qty: 1
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 4
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 2
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

    describe "no empanadas al horno but 'ESPECIAL' pizza", ->

      it "should NOT validate when pizza 'ESPECIAL'", ->
        shoppingCart = [
          {
            cat: 'PIZZA'
            subcat: 'ESPECIAL'
            qty: 1
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()


      it "should NOT validate when pizza not 'ESPECIAL'", ->
        shoppingCart = [
          {
            cat: 'PIZZA'
            subcat: 'NOT-ESPECIAL'
            qty: 1
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()