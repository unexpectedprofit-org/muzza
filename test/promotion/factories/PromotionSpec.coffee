describe 'Promo', ->

  beforeEach ->
    module 'Muzza.promo'

  Promotion = promo = promoTypeQty = undefined

  beforeEach ->
    inject (_Promotion_) ->
      Promotion = _Promotion_

      promoTypeQty = {rules:[],components:[],details:{id:2,description:{short:"Promo 1: 6 empanadas...",long:"description loooong"},price:54}}
      promo = new Promotion promoTypeQty

  describe "Init", ->

    it 'should construct a Promo object', ->
      expect(promo instanceof Promotion).toBeTruthy()
      expect(promo.description).toBeDefined()
      expect(promo.getHash).toBeDefined()

      expect(promo.qty).toBe 1
      expect(promo.cat).toBe "PROMO"

      expect(promo.id).toBe 2
      expect(promo.totalPrice).toBe 54
      expect(promo.description).toBe "Promo 1: 6 empanadas..."

      expect(promo.items).toEqual []
      expect(promo.rules).toEqual []

    it 'should have functions defined', ->
      expect(promo.getHash).toBeDefined()
      expect(promo.getDescription).toBeDefined()
      expect(promo.isEditable).toBeDefined()


  it "should create a hash", ->
    expect(promo.getHash()).toBe promoTypeQty.details.id + "|" + promoTypeQty.details.price


  it "should create a description", ->
    expect(promo.getDescription()).toBe promoTypeQty.details.description.short

  describe "getItems functionality", ->

    it "should retrieve items with qty >= 1", ->

      components = {
        "EMPANADA": [
          desc: "Categ 1"
          products: [
            id:1
            qty:2
          ,
            id:2
            qty:1
          ,
            id:3
            qty:0
          ]
        ,
          desc: "Categ 2"
          products:[
            id:9
            qty:0
          ,
            id:8
            qty:3
          ,
            id:7
            qty:0
          ]
        ]
        "PIZZA": [
          desc: "Categ x"
          products: [
            id:1
            qty:10
          ,
            id:2
            qty:3
          ,
            id:3
            qty:0
          ]
        ]
      }

      promoTypeQty = {rules:[],components:components,details:{id:2,description:{short:"Promo 1: 6 empanadas...",long:"description loooong"},price:54}}
      promo = new Promotion promoTypeQty

      expect(promo.items.length).toBe 5
