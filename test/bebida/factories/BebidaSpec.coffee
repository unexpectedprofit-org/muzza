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

  describe "reset functionality", ->

    it 'should reset item', ->
      param =
        id:999
        description: 'Coca colaaa'
        subcat: 24
        qty: 2
        size: 'chica'
        price:
          base: 50

      bebida = new Bebida param
      bebida.reset()

      expect(bebida.id).toBe param.id
      expect(bebida.description).toBe param.description
      expect(bebida.subcat).toBe param.subcat
      expect(bebida.size).toBe param.size
      expect(bebida.price.base).toBe param.price.base

      expect(bebida.cat).toBe 'BEBIDA'
      expect(bebida.totalPrice).toBe 0
      expect(bebida.qty).toBe 1


  describe "getDescription functionality", ->

    it 'should generate a description from default values', ->
      bebida = new Bebida()
      expect(bebida.getDescription()).toBeUndefined()

    it 'should generate a description from changed values', ->
      bebida = new Bebida {description:'Quilmes',size:'grande',option:'Stout'}
      expect(bebida.getDescription()).toBe 'Quilmes grande Stout'

    it 'should generate a description from changed values - no size', ->
      bebida = new Bebida {description:'Quilmes'}
      expect(bebida.getDescription()).toBe 'Quilmes'

    it 'should generate a description from changed values - no option', ->
      bebida = new Bebida {size:'grande', description: 'Quilmes'}
      expect(bebida.getDescription()).toBe 'Quilmes grande'


  describe "getHash functionality", ->

    it 'should generate the identifier hash dynamically', ->
      bebida = new Bebida {id:878,description:'Quilmes',size:'grande',option: 'Stout',subcat:777}
      expect(bebida.getHash()).toBe 'ID_BRAND|878|777|GRANDE|STOUT'

    it 'should generate the identifier hash dynamically - case 2', ->
      bebida = new Bebida {id:200,description:'Muzza',size:'chica',subcat:888}
      expect(bebida.getHash()).toBe 'ID_BRAND|200|888|CHICA|'

    it 'should generate the identifier hash dynamically - case 3', ->
      bebida = new Bebida {id:100,description:'Muzza',size:'individual',subcat:999}
      expect(bebida.getHash()).toBe 'ID_BRAND|100|999|INDIVIDUAL|'


  describe "update qty functionality", ->

    it 'should update qty if the user adds 1', ->
      bebida = new Bebida {description:'Quilmes',size:'grande',qty:1}
      bebida.updateQty +1
      expect(bebida.qty).toBe 2

    it 'should update qty if the user substracts 1', ->
      bebida = new Bebida {description:'Quilmes',size:'grande',qty:2}
      bebida.updateQty -1
      expect(bebida.qty).toBe 1

    it 'should update qty to 0 if the user substracts below 0', ->
      bebida = new Bebida {description:'Quilmes',size:'grande',qty:1}
      bebida.updateQty -1
      expect(bebida.qty).toBe 0

  it 'should reset the totalPrice to the base price', ->
    bebida = new Bebida {description:'Quilmes',size:'grande',option:'Stout',price:{base:50}}
    bebida.resetPrice()
    expect(bebida.totalPrice).toBe 50

  describe "isEditable functionality", ->

    it "should return true", ->

      bebida = new Bebida {}
      expect(bebida.isEditable()).toBeTruthy()