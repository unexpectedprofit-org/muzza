describe 'Pizza', ->

  Pizza = undefined

  beforeEach ->
    module 'Muzza.pizzas'

  beforeEach ->
    inject (_Pizza_)->
      Pizza = _Pizza_


  describe 'constructor', ->

    it 'should construct a Pizza model with default values', ->
      pizza = new Pizza()
      expect(pizza.desc).toBe ''
      expect(pizza.totalPrice).toBe 0
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
        dough: 'al molde'
        price:
          base: 50
      pizza = new Pizza(param)
      expect(pizza.totalPrice).toBe 0
      expect(pizza.size).toBe 'chica'
      expect(pizza.price.base).toBe 50
      expect(pizza.dough).toBe 'al molde'
      expect(pizza.cat).toBe 'PIZZA'
      expect(pizza.qty).toBe 2
      expect(pizza.desc).toBe 'Muzza'
      expect(pizza.price.base).toBe 50

  it 'should generate a description from default values', ->
    pizza = new Pizza()
    description = pizza.description()
    expect(description).toBe ' de  '

  it 'should generate a description from changes values', ->
    pizza = new Pizza({size:'grande', dough:'al molde', desc: 'Muzza'})
    description = pizza.description()
    expect(description).toBe 'grande de Muzza al molde'

  it 'should reset the totalPrice to the base price', ->
    pizza = new Pizza({price:{base:50}})
    pizza.resetPrice()
    expect(pizza.totalPrice).toBe 50

  it 'shoudl generate the identifier hash dynamically', ->
    pizza = new Pizza( { id: 1, desc: 'Muzza', size: 'grande', dough: 'al molde' } )
    pizza.setHash()
    expect(pizza.hash).toBe '1-muzza-grande-almolde'
