describe 'Pizza', ->

  Pizza = undefined

  beforeEach ->
    module 'Muzza.pizzas'
    module 'Muzza.directives'

  beforeEach ->
    inject (_Pizza_)->
      Pizza = _Pizza_


  describe 'constructor', ->

    it 'should construct a Pizza model with default values', ->
      pizza = new Pizza()
      expect(pizza.description).toBe ''
      expect(pizza.totalPrice).toBe undefined
      expect(pizza.size).toBe ''
      expect(pizza.dough).toBe ''
      expect(pizza.cat).toBe 'PIZZA'
      expect(pizza.subcat).toBe 0
      expect(pizza.qty).toBe 1
      expect(pizza.price.base).toBe 0

    it 'should construct a Pizza model from param', ->
      param =
        description: 'Muzza'
        subcat: 333
        qty: 2
        size: 'chica'
        dough: 'molde'
        price:
          base: 50
      pizza = new Pizza param
      expect(pizza.totalPrice).toBe undefined
      expect(pizza.size).toBe 'chica'
      expect(pizza.price.base).toBe 50
      expect(pizza.dough).toBe 'molde'
      expect(pizza.cat).toBe 'PIZZA'
      expect(pizza.subcat).toBe 333
      expect(pizza.qty).toBe 2
      expect(pizza.description).toBe 'Muzza'
      expect(pizza.price.base).toBe 50

    it 'should have functions defined', ->
      pizza = new Pizza {}
      expect(pizza.getBasePrice).toBeDefined()
      expect(pizza.getTotalPrice).toBeDefined()
      expect(pizza.getDescription).toBeDefined()
      expect(pizza.resetPrice).toBeDefined()
      expect(pizza.updateQty).toBeDefined()
      expect(pizza.getHash).toBeDefined()
      expect(pizza.reset).toBeDefined()
      expect(pizza.isEditable).toBeDefined()

  it 'should generate a description from default values', ->
    pizza = new Pizza()
    expect(pizza.getDescription()).toBe ' de  '

  it 'should generate a description from changes values', ->
    pizza = new Pizza({size:'grande', dough:'molde', description: 'Muzza'})
    expect(pizza.getDescription()).toBe 'grande de Muzza molde'

  it 'should reset the totalPrice to the base price', ->
    pizza = new Pizza({price:{base:50}})
    pizza.resetPrice()
    expect(pizza.totalPrice).toBe 50

  describe 'getHash', ->

    it 'should generate the identifier hash dynamically', ->
      pizza = new Pizza {id:1,description:'Muzza',size:'grande',dough: 'molde',subcat:777}
      expect(pizza.getHash()).toBe 'ID_BRAND|1|777|GRANDE|MOLDE'

    it 'should generate the identifier hash dynamically - case 2', ->
      pizza = new Pizza {id:200,description:'Muzza',size:'chica',dough:'molde',subcat:888}
      expect(pizza.getHash()).toBe 'ID_BRAND|200|888|CHICA|MOLDE'

    it 'should generate the identifier hash dynamically - case 3', ->
      pizza = new Pizza {id:100,description:'Muzza',size:'individual',dough:'piedra',subcat:999}
      expect(pizza.getHash()).toBe 'ID_BRAND|100|999|INDIVIDUAL|PIEDRA'


  describe "reset functionality", ->

    it 'should reset item', ->
      param =
        id:888
        description: 'Muzza'
        subcat: 333
        qty: 2
        size: 'chica'
        dough: 'molde'
        price:
          base: 50

      pizza = new Pizza param
      pizza.reset()

      expect(pizza.id).toBe param.id
      expect(pizza.description).toBe param.description
      expect(pizza.subcat).toBe param.subcat
      expect(pizza.size).toBe param.size
      expect(pizza.dough).toBe param.dough
      expect(pizza.price.base).toBe param.price.base

      expect(pizza.cat).toBe 'PIZZA'
      expect(pizza.totalPrice).toBe 0
      expect(pizza.qty).toBe 1


  describe "update qty functionality", ->

    it 'should update qty if the user adds 1', ->
      pizza = new Pizza( { id: 1, description: 'Muzza', size: 'grande', dough: 'molde', qty: 1 } )
      pizza.updateQty(+1)
      expect(pizza.qty).toBe 2

    it 'should update qty if the user substracts 1', ->
      pizza = new Pizza( { id: 1, description: 'Muzza', size: 'grande', dough: 'molde', qty: 2 } )
      pizza.updateQty(-1)
      expect(pizza.qty).toBe 1

    it 'should update qty to 1 if the user substracts below 0', ->
      pizza = new Pizza( { id: 1, description: 'Muzza', size: 'grande', dough: 'molde', qty: 1 } )
      pizza.updateQty(-1)
      expect(pizza.qty).toBe 0


  describe "totalPrice formatted funtionality", ->

    it 'should return a formatted base price when value is greater than 0', ->
      pizza = new Pizza( { id: 1, description: 'Muzza', price: {base: 5000}, qty: 1 } )
      expect(pizza.getBasePrice()).toBe '$50.00'

    it 'should return a formatted base price when value is 0', ->
      pizza = new Pizza( { id: 1, description: 'Muzza', price: {base: 0}, qty: 1 } )
      expect(pizza.getBasePrice()).toBe '$0.00'

    it 'should return a formatted base price of 0 when value is undefined', ->
      pizza = new Pizza( { id: 1, description: 'Muzza', price: {base: undefined}, qty: 1 } )
      expect(pizza.getBasePrice()).toBe '$0.00'

    it 'should return a formatted total price when value is greater than 0', ->
      pizza = new Pizza( { id: 1, description: 'Muzza', price: {base: 5000}, qty: 1, totalPrice: 5000 } )
      expect(pizza.getTotalPrice()).toBe '$50.00'

    it 'should return a formatted total price when value is 0', ->
      pizza = new Pizza( { id: 1, description: 'Muzza', price: {base: 0}, qty: 1, totalPrice: 0 } )
      expect(pizza.getTotalPrice()).toBe '$0.00'

    it 'should return a formatted total price of 0 when value is undefined', ->
      pizza = new Pizza( { id: 1, description: 'Muzza', price: {base: undefined}, qty: 1 } )
      expect(pizza.getTotalPrice()).toBe '$0.00'

  describe "isEditable functionality", ->

    it "should return true", ->

      pizza = new Pizza {}
      expect(pizza.isEditable()).toBeTruthy()