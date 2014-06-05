describe 'Bebida', ->

  Bebida = undefined

  beforeEach ->
    module 'Muzza.bebidas'

  beforeEach ->
    inject ($injector)->
      Bebida = $injector.get 'Bebida'


  describe 'constructor', ->

    it 'should construct a Bebida model with default values', ->
      bebida = new Bebida()
      expect(bebida.desc).toBeUndefined()
      expect(bebida.size).toBeUndefined()
      expect(bebida.cat).toBe 'BEBIDA'
      expect(bebida.subcat).toBe 0
      expect(bebida.qty).toBe 1
      expect(bebida.totalPrice).toBeUndefined()
      expect(bebida.price.base).toBe 0

    it 'should construct a Bebida model from param', ->
      param =
        desc: 'Heineken'
        subcat: 333
        qty: 2
        size: 'chica'
        option: 'Negra'
        price:
          base: 50
      
      bebida = new Bebida param
      expect(bebida.desc).toBe 'Heineken'
      expect(bebida.size).toBe 'chica'
      expect(bebida.cat).toBe 'BEBIDA'
      expect(bebida.subcat).toBe 333
      expect(bebida.qty).toBe 2
      expect(bebida.totalPrice).toBeUndefined()
      expect(bebida.price.base).toBe 50
      expect(bebida.option).toBe 'Negra'

  it 'should generate a description from default values', ->
    bebida = new Bebida()
    expect(bebida.description()).toBeUndefined()

  it 'should generate a description from changed values', ->
    bebida = new Bebida {desc:'Quilmes',size:'grande',option:'Stout'}
    expect(bebida.description()).toBe 'Quilmes grande Stout'

  it 'should generate a description from changed values - no size', ->
    bebida = new Bebida {desc:'Quilmes'}
    expect(bebida.description()).toBe 'Quilmes'

  it 'should generate a description from changed values - no option', ->
    bebida = new Bebida {size:'grande', desc: 'Quilmes'}
    expect(bebida.description()).toBe 'Quilmes grande'

  it 'should generate the identifier hash dynamically', ->
    bebida = new Bebida {id:878,desc:'Quilmes',size:'grande',option: 'Stout',subcat:777}
    expect(bebida.getHash()).toBe 'ID_BRAND|878|777|GRANDE|STOUT'

  it 'should generate the identifier hash dynamically - case 2', ->
    bebida = new Bebida {id:200,desc:'Muzza',size:'chica',subcat:888}
    expect(bebida.getHash()).toBe 'ID_BRAND|200|888|CHICA|'

  it 'should generate the identifier hash dynamically - case 3', ->
    bebida = new Bebida {id:100,desc:'Muzza',size:'individual',subcat:999}
    expect(bebida.getHash()).toBe 'ID_BRAND|100|999|INDIVIDUAL|'

  it 'should update qty if the user adds 1', ->
    bebida = new Bebida {desc:'Quilmes',size:'grande',qty:1}
    bebida.updateQty(+1)
    expect(bebida.qty).toBe 2

  it 'should update qty if the user substracts 1', ->
    bebida = new Bebida {desc:'Quilmes',size:'grande',qty:2}
    bebida.updateQty(-1)
    expect(bebida.qty).toBe 1

  it 'should update qty to 0 if the user substracts below 0', ->
    bebida = new Bebida {desc:'Quilmes',size:'grande',qty:1}
    bebida.updateQty(-1)
    expect(bebida.qty).toBe 0

  it 'should reset the totalPrice to the base price', ->
    bebida = new Bebida {desc:'Quilmes',size:'grande',option:'Stout',price:{base:50}}
    bebida.resetPrice()
    expect(bebida.totalPrice).toBe 50