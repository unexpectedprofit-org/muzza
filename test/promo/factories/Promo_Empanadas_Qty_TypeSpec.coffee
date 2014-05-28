describe 'Promo_Empanadas_Qty_Type', ->

  beforeEach ->
    module 'Muzza.promo'

  Promo_Empanadas_Qty_Type = promo = undefined


  describe "12 - Horno", ->

    beforeEach ->
      inject ($injector) ->
        Promo_Empanadas_Qty_Type = $injector.get 'Promo_Empanadas_Qty_Type'

        promo = new Promo_Empanadas_Qty_Type 12, 'H'

    describe "Init", ->

      it 'should construct a Promo object', ->
        expect(promo.validate).toBeDefined()
        expect(promo.apply).toBeDefined()

        expect(promo.rules).toEqual [{cat:'EMPANADA',subcat:'H',qty:12}]

    describe "1 dozen of empanadas", ->

      it "should validate when all same subcat, all same flavors", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'H'
            qty: 12
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when all same subcat, different flavors", ->
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

      it "should NOT when all subcat not 'H', all same flavors", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'F'
            qty: 12
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT when all subcat not 'H', different flavors", ->
        shoppingCart = [
            cat: 'EMPANADA'
            subcat: 'F'
            qty: 6
            id: 1
          ,
            cat: 'EMPANADA'
            subcat: 'F'
            qty: 6
            id: 2
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT when some subcat not 'H', different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 6
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 6
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeFalsy()


    describe "more than 12 empanadas", ->

      it "should validate when all same subcat, all same flavors", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'H'
            qty: 14
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when all same subcat, different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 6
          id: 7
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 6
          id: 8
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 1
          id: 9
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should NOT when all subcat not 'H', all same flavors", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'F'
            qty: 16
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT when all subcat not 'H', different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 10
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 4
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should validate when some subcat 'H'", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 16
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 8
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when some subcat 'H' - different order", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 8
          id: 2
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 16
          id: 1
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

  describe "12 - Fritas", ->

    beforeEach ->
      inject ($injector) ->
        Promo_Empanadas_Qty_Type = $injector.get 'Promo_Empanadas_Qty_Type'

        promo = new Promo_Empanadas_Qty_Type 12, 'F'

    describe "Init", ->

      it 'should construct a Promo object', ->
        expect(promo.validate).toBeDefined()
        expect(promo.apply).toBeDefined()

        expect(promo.rules).toEqual [{cat:'EMPANADA',subcat:'F',qty:12}]

    describe "1 dozen of empanadas", ->

      it "should validate when all same subcat, all same flavors", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'F'
            qty: 12
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when all same subcat, different flavors", ->
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

      it "should NOT when all subcat not 'F', all same flavors", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'H'
            qty: 12
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT when all subcat not 'F', different flavors", ->
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
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT when some subcat not 'F', different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 6
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 6
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeFalsy()


    describe "more than 12 empanadas", ->

      it "should validate when all same subcat, all same flavors", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'F'
            qty: 14
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when all same subcat, different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 6
          id: 7
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 6
          id: 8
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 1
          id: 9
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should NOT when all subcat not 'F', all same flavors", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'H'
            qty: 16
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT when all subcat not 'F', different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 10
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 4
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should validate when some subcat 'F'", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 16
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 8
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when some subcat 'F' - different order", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 8
          id: 2
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 16
          id: 1
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

  describe "16 - Horno", ->

    beforeEach ->
      inject ($injector) ->
        Promo_Empanadas_Qty_Type = $injector.get 'Promo_Empanadas_Qty_Type'

        promo = new Promo_Empanadas_Qty_Type 16, 'H'

    describe "Init", ->

      it 'should construct a Promo object', ->
        expect(promo.validate).toBeDefined()
        expect(promo.apply).toBeDefined()

        expect(promo.rules).toEqual [{cat:'EMPANADA',subcat:'H',qty:16}]

    describe "16 empanadas", ->

      it "should validate when all same subcat, all same flavors", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'H'
            qty: 16
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when all same subcat, different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 10
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 3
          id: 2
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 3
          id: 3
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should NOT when all subcat not 'H', all same flavors", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'F'
            qty: 16
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT when all subcat not 'H', different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 10
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 6
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT when some subcat not 'H', different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 6
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 10
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeFalsy()


    describe "more than 16 empanadas", ->

      it "should validate when all same subcat, all same flavors", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'H'
            qty: 18
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when all same subcat, different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 10
          id: 7
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 10
          id: 8
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 5
          id: 9
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should NOT when all subcat not 'H', all same flavors", ->
        shoppingCart = [
          {
            cat: 'EMPANADA'
            subcat: 'F'
            qty: 16
            id: 1
          }
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT when all subcat not 'H', different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 10
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 10
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should validate when some subcat 'H'", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 16
          id: 1
        ,
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 8
          id: 2
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when some subcat 'H' - different order", ->
        shoppingCart = [
          cat: 'EMPANADA'
          subcat: 'F'
          qty: 16
          id: 2
        ,
          cat: 'EMPANADA'
          subcat: 'H'
          qty: 16
          id: 1
        ]
        expect(promo.validate shoppingCart).toBeTruthy()