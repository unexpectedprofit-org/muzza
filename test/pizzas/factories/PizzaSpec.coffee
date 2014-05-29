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
      expect(pizza.desc).toBe ''
      expect(pizza.totalPrice).toBe undefined
      expect(pizza.size).toBe ''
      expect(pizza.dough).toBe ''
      expect(pizza.cat).toBe 'PIZZA'
      expect(pizza.qty).toBe 1
      expect(pizza.price.base).toBe 0

    it 'should construct a Pizza model from param', ->
      param =
        desc: 'Muzza'
        qty: 2
        size: 'chica'
        dough: 'molde'
        price:
          base: 50
      pizza = new Pizza(param)
      expect(pizza.totalPrice).toBe undefined
      expect(pizza.size).toBe 'chica'
      expect(pizza.price.base).toBe 50
      expect(pizza.dough).toBe 'molde'
      expect(pizza.cat).toBe 'PIZZA'
      expect(pizza.qty).toBe 2
      expect(pizza.desc).toBe 'Muzza'
      expect(pizza.price.base).toBe 50

  it 'should generate a description from default values', ->
    pizza = new Pizza()
    description = pizza.description()
    expect(description).toBe ' de  '

  it 'should generate a description from changes values', ->
    pizza = new Pizza({size:'grande', dough:'molde', desc: 'Muzza'})
    description = pizza.description()
    expect(description).toBe 'grande de Muzza molde'

  it 'should reset the totalPrice to the base price', ->
    pizza = new Pizza({price:{base:50}})
    pizza.resetPrice()
    expect(pizza.totalPrice).toBe 50

  it 'should generate the identifier hash dynamically', ->
    pizza = new Pizza( { id: 1, desc: 'Muzza', size: 'grande', dough: 'molde' } )
    expect(pizza.getHash()).toBe 'ID_BRAND|1|ESPECIAL|GRANDE|MOLDE'

  it 'should generate the identifier hash dynamically - case 2', ->
    pizza = new Pizza( { id: 200, desc: 'Muzza', size: 'chica', dough: 'molde' } )
    expect(pizza.getHash()).toBe 'ID_BRAND|200|ESPECIAL|CHICA|MOLDE'

  it 'should generate the identifier hash dynamically - case 3', ->
    pizza = new Pizza( { id: 100, desc: 'Muzza', size: 'individual', dough: 'piedra' } )
    expect(pizza.getHash()).toBe 'ID_BRAND|100|ESPECIAL|INDIVIDUAL|PIEDRA'

  it 'should update qty if the user adds 1', ->
    pizza = new Pizza( { id: 1, desc: 'Muzza', size: 'grande', dough: 'molde', qty: 1 } )
    pizza.updateQty(+1)
    expect(pizza.qty).toBe 2

  it 'should update qty if the user substracts 1', ->
    pizza = new Pizza( { id: 1, desc: 'Muzza', size: 'grande', dough: 'molde', qty: 2 } )
    pizza.updateQty(-1)
    expect(pizza.qty).toBe 1

  it 'should update qty to 1 if the user substracts below 0', ->
    pizza = new Pizza( { id: 1, desc: 'Muzza', size: 'grande', dough: 'molde', qty: 1 } )
    pizza.updateQty(-1)
    expect(pizza.qty).toBe 1

  it 'should return a formatted base price when value is greater than 0', ->
    pizza = new Pizza( { id: 1, desc: 'Muzza', price: {base: 5000}, qty: 1 } )
    expect(pizza.getBasePrice()).toBe '$50.00'

  it 'should return a formatted base price when value is 0', ->
    pizza = new Pizza( { id: 1, desc: 'Muzza', price: {base: 0}, qty: 1 } )
    expect(pizza.getBasePrice()).toBe '$0.00'

  it 'should return a formatted base price of 0 when value is undefined', ->
    pizza = new Pizza( { id: 1, desc: 'Muzza', price: {base: undefined}, qty: 1 } )
    expect(pizza.getBasePrice()).toBe '$0.00'

  it 'should return a formatted total price when value is greater than 0', ->
    pizza = new Pizza( { id: 1, desc: 'Muzza', price: {base: 5000}, qty: 1, totalPrice: 5000 } )
    expect(pizza.getTotalPrice()).toBe '$50.00'

  it 'should return a formatted total price when value is 0', ->
    pizza = new Pizza( { id: 1, desc: 'Muzza', price: {base: 0}, qty: 1, totalPrice: 0 } )
    expect(pizza.getTotalPrice()).toBe '$0.00'

  it 'should return a formatted total price of 0 when value is undefined', ->
    pizza = new Pizza( { id: 1, desc: 'Muzza', price: {base: undefined}, qty: 1 } )
    expect(pizza.getTotalPrice()).toBe '$0.00'




