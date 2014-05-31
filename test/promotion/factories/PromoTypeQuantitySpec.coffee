describe 'PromoTypeQuantity', ->

  beforeEach ->
    module 'Muzza.promo'

  PromoTypeQuantity = promo = promoDetails = promoRules = undefined

  beforeEach ->
    inject ($injector) ->
      PromoTypeQuantity = $injector.get 'PromoTypeQuantity'

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
        promo = new PromoTypeQuantity {rules:[{qty:6,cat:'EMPANADA',subcat:'|||'}]}


    describe "Init", ->

      it 'should construct a Promo object', ->
        expect(promo.validate).toBeDefined()
        expect(promo.apply).toBeDefined()

        expect(promo.rules).toEqual [{qty:6,cat:'EMPANADA',subcat:'|||'}]


    describe "Basic Case", ->

      it "should validate if cat not empanada", ->
        shoppingCart = [
          cat: 'EMPANADA'
          qty: 12
          hashKey: 'ID_BRAND|ID_PROD|FRITA||'
        ]
        expect(promo.validate shoppingCart).toBeTruthy()


    describe "More Cases", ->

      it "should validate when all same type 'HORNO', different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          qty: 4
          hashKey: 'ID_BRAND|ID_PROD1|HORNO||'
        ,
          cat: 'EMPANADA'
          qty: 4
          hashKey: 'ID_BRAND|ID_PROD2|HORNO||'
        ,
          cat: 'EMPANADA'
          qty: 4
          hashKey: 'ID_BRAND|ID_PROD3|HORNO||'
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when more than 1 type, different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          qty: 4
          hashKey: 'ID_BRAND|ID_PROD1|FRITA||'
        ,
          cat: 'EMPANADA'
          qty: 4
          hashKey: 'ID_BRAND|ID_PROD2|HORNO||'
        ,
          cat: 'EMPANADA'
          qty: 4
          hashKey: 'ID_BRAND|ID_PROD3|FRITA||'
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should NOT validate if quantity not met, only one product", ->
        shoppingCart = [
          cat: 'EMPANADA'
          qty: 4
          hashKey: 'ID_BRAND|ID_PROD1|HORNO||'
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if quantity not met, several products", ->
        shoppingCart = [
          cat: 'EMPANADA'
          qty: 2
          hashKey: 'ID_BRAND|ID_PROD1|FRITA||'
        ,
          cat: 'EMPANADA'
          qty: 2
          hashKey: 'ID_BRAND|ID_PROD2|HORNO||'
        ]
        expect(promo.validate shoppingCart).toBeFalsy()


  describe "Promo2: 6 empanadas Fritas", ->

    beforeEach ->
      promo = new PromoTypeQuantity {rules:[{qty:6,cat:'EMPANADA',subcat:'|FRITA||'}]}


    describe "Init", ->

      it 'should construct a Promo object', ->
        expect(promo.validate).toBeDefined()
        expect(promo.apply).toBeDefined()

        expect(promo.rules).toEqual [{qty:6,cat:'EMPANADA',subcat:'|FRITA||'}]


    describe "Basic Case", ->

      it "should validate when all same type 'FRITA', only one product", ->
        shoppingCart = [
          cat: 'EMPANADA'
          qty: 6
          hashKey: 'ID_BRAND|ID_PROD|FRITA||'
        ]
        expect(promo.validate shoppingCart).toBeTruthy()


    describe "More Cases", ->

      it "should validate when all same type 'FRITA', several products", ->
        shoppingCart = [
          cat: 'EMPANADA'
          qty: 4
          hashKey: 'ID_BRAND|ID_PROD|FRITA||'
        ,
          cat: 'EMPANADA'
          qty: 2
          hashKey: 'ID_BRAND|ID_PROD|FRITA||'
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should validate when more than 1 type, different flavors", ->
        shoppingCart = [
          cat: 'EMPANADA'
          qty: 6
          hashKey: 'ID_BRAND|ID_PROD|FRITA||'
        ,
          cat: 'EMPANADA'
          qty: 2
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should NOT validate if missing empanada", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 2
          hashKey: 'ID_BRAND|ID_PROD|FRITA||'
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if type not 'FRITA', only one product", ->
        shoppingCart = [
          cat: 'EMPANADA'
          qty: 6
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if subcat not met, several products", ->
        shoppingCart = [
          cat: 'EMPANADA'
          qty: 6
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ,
          cat: 'EMPANADA'
          qty: 4
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if quantity not met, only one product", ->
        shoppingCart = [
          cat: 'EMPANADA'
          qty: 2
          hashKey: 'ID_BRAND|ID_PROD|FRITA||'
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if quantity not met, several products", ->
        shoppingCart = [
          cat: 'EMPANADA'
          qty: 2
          hashKey: 'ID_BRAND|ID_PROD|FRITA||'
        ,
          cat: 'EMPANADA'
          qty: 3
          hashKey: 'ID_BRAND|ID_PROD|FRITA||'
        ]
        expect(promo.validate shoppingCart).toBeFalsy()


  describe "Promo3: 2 empanadas cualquiera y 1 pizza especial", ->

    beforeEach ->
      promo = new PromoTypeQuantity {rules:[{qty:1,cat:'PIZZA',subcat:'|ESPECIAL||'},{qty:2,cat:'EMPANADA',subcat:'|||'}]}


    describe "Init", ->

      it 'should construct a Promo object', ->
        expect(promo.validate).toBeDefined()
        expect(promo.apply).toBeDefined()

        expect(promo.rules).toEqual [{qty:1,cat:'PIZZA',subcat:'|ESPECIAL||'},{qty:2,cat:'EMPANADA',subcat:'|||'}]


    describe "Basic Case", ->

      it "should validate when 1 pizza especial and 2 any empanadas ", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|ESPECIAL|GRANDE|'
        ,
          cat: 'EMPANADA'
          qty: 2
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ]
        expect(promo.validate shoppingCart).toBeTruthy()


    describe "More Cases", ->

      it "should validate when 1 pizza especial and 2 any empanadas ", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|ESPECIAL|MEDIANA|'
        ,
          cat: 'EMPANADA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ,
          cat: 'EMPANADA'
          qty: 3
          hashKey: 'ID_BRAND|ID_PROD|FRITA||'
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should NOT validate if empanada not present", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|ESPECIAL|MEDIANA|'
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if pizza not present", ->
        shoppingCart = [
          cat: 'EMPANADA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ,
          cat: 'EMPANADA'
          qty: 3
          hashKey: 'ID_BRAND|ID_PROD|FRITA||'
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate if not pizza especial", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|DELACASA|MEDIANA|'
        ,
          cat: 'EMPANADA'
          qty: 2
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ]
        expect(promo.validate shoppingCart).toBeFalsy()


  describe "Promo4: 6 empanadas horno y 1 pizza especial grande", ->

    beforeEach ->
      promo = new PromoTypeQuantity {rules:[{qty:1,cat:'PIZZA',subcat:'|ESPECIAL|GRANDE|'},{qty:6,cat:'EMPANADA',subcat:'|HORNO||'}]}


    describe "Init", ->

      it 'should construct a Promo object', ->
        expect(promo.validate).toBeDefined()
        expect(promo.apply).toBeDefined()

        expect(promo.rules).toEqual [{qty:1,cat:'PIZZA',subcat:'|ESPECIAL|GRANDE|'},{qty:6,cat:'EMPANADA',subcat:'|HORNO||'}]


    describe "Basic Case", ->

      it "should validate when 6 empanadas horno y 1 pizza especial grande", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|ESPECIAL|GRANDE|'
        ,
          cat: 'EMPANADA'
          qty: 6
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ]
        expect(promo.validate shoppingCart).toBeTruthy()


    describe "More Cases", ->

      it "should validate when more than 6 empanadas horno y 1 pizza especial grande", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|ESPECIAL|GRANDE|'
        ,
          cat: 'EMPANADA'
          qty: 8
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should NOT validate when empanadas not horno", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|ESPECIAL|GRANDE|'
        ,
          cat: 'EMPANADA'
          qty: 6
          hashKey: 'ID_BRAND|ID_PROD|FRITA||'
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate when not 1 pizza grande", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|ESPECIAL|MEDIANA|'
        ,
          cat: 'EMPANADA'
          qty: 6
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate when not 1 pizza especial", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|DELACASA|GRANDE|'
        ,
          cat: 'EMPANADA'
          qty: 6
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ]
        expect(promo.validate shoppingCart).toBeFalsy()


  describe "Promo5: 12 empanadas horno y 2 pizza grande", ->

    beforeEach ->
      promo = new PromoTypeQuantity {rules:[{qty:2,cat:'PIZZA',subcat:'||GRANDE|'},{qty:12,cat:'EMPANADA',subcat:'|HORNO||'}]}


    describe "Init", ->

      it 'should construct a Promo object', ->
        expect(promo.validate).toBeDefined()
        expect(promo.apply).toBeDefined()

        expect(promo.rules).toEqual [{qty:2,cat:'PIZZA',subcat:'||GRANDE|'},{qty:12,cat:'EMPANADA',subcat:'|HORNO||'}]


    describe "Basic case", ->

      it "should validate when exact same products", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 2
          hashKey: 'ID_BRAND|ID_PROD|DELACASA|GRANDE|'
        ,
          cat: 'EMPANADA'
          qty: 12
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ]
        expect(promo.validate shoppingCart).toBeTruthy()


    describe "More cases", ->

      it "should validate when any empanadas and 2 pizzas grandes, different type", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|ESPECIAL|GRANDE|'
        ,
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|DELACASA|GRANDE|'
        ,
          cat: 'EMPANADA'
          qty: 4
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ,
          cat: 'EMPANADA'
          qty: 8
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should NOT validate when no pizza grande", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|ESPECIAL|CHICA|'
        ,
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|DELACASA|MEDIANA|'
        ,
          cat: 'EMPANADA'
          qty: 12
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

      it "should NOT validate when only one pizza grande", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|ESPECIAL|GRANDE|'
        ,
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_PROD|DELACASA|MEDIANA|'
        ,
          cat: 'EMPANADA'
          qty: 12
          hashKey: 'ID_BRAND|ID_PROD|HORNO||'
        ]
        expect(promo.validate shoppingCart).toBeFalsy()

  describe "Promo6: 1 Grande de Jamon", ->

    beforeEach ->
      promo = new PromoTypeQuantity {rules:[{qty:1,cat:'PIZZA',subcat:'ID_JAMON||GRANDE|'}]}


    describe "Init", ->

      it 'should construct a Promo object', ->
        expect(promo.validate).toBeDefined()
        expect(promo.apply).toBeDefined()

        expect(promo.rules).toEqual [{qty:1,cat:'PIZZA',subcat:'ID_JAMON||GRANDE|'}]


    describe "Basic case", ->

      it "should validate when exact same product", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_JAMON|DELACASA|GRANDE|'
        ]
        expect(promo.validate shoppingCart).toBeTruthy()


    describe "More cases", ->

      it "should validate when pizza jamon, any dough", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_JAMON|DELACASA|GRANDE|MOLDE'
        ]
        expect(promo.validate shoppingCart).toBeTruthy()

      it "should NOT validate when pizza jamon, different size, any dough", ->
        shoppingCart = [
          cat: 'PIZZA'
          qty: 1
          hashKey: 'ID_BRAND|ID_JAMON|DELACASA|CHICA|MOLDE'
        ]
        expect(promo.validate shoppingCart).toBeFalsy()