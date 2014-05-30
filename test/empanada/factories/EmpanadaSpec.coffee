describe 'Empanada', ->

  beforeEach ->
    module 'Muzza.empanadas'

  Empanada = fromObject = undefined

  beforeEach ->
    inject (_Empanada_) ->
      Empanada = _Empanada_

    fromObject =
      id: 505
      desc: "description"
      price:
        base: 1020
      type: "horno"

  describe "init", ->

    it "should construct a Empanada object", ->
      newEmpanada = new Empanada {}
      expect(newEmpanada.updateQty).toBeDefined()
      expect(newEmpanada.minReached).toBeDefined()
      expect(newEmpanada.maxReached).toBeDefined()

#    it "should init the object", ->
#      newEmpanada = new Empanada {}
#      expect(newEmpanada.qty).toBe 1
#      expect(newEmpanada.cat).toBe "EMPANADA"
#      expect(newEmpanada.desc).toBe ""
#      expect(newEmpanada.type).toBe ""
#      expect(newEmpanada.totalPrice).toBe 0

    it "should init the object from another object", ->
      newEmpanada = new Empanada fromObject
      expect(newEmpanada.qty).toBe 1
      expect(newEmpanada.cat).toBe "EMPANADA"
      expect(newEmpanada.subcat).toBe "H"
      expect(newEmpanada.id).toBe 505
      expect(newEmpanada.desc).toBe fromObject.desc
      expect(newEmpanada.totalPrice).toBe fromObject.price.base
      expect(newEmpanada.type).toBe fromObject.type

  #to EmpanadaOrder
  describe "max/min allowed", ->

    it "should validate min quantity", ->
      newEmpanada = new Empanada fromObject
      expect(newEmpanada.minReached()).toBeTruthy()

      newEmpanada.qty = 10
      expect(newEmpanada.minReached()).toBeFalsy()

    it "should validate max quantity", ->
      newEmpanada = new Empanada fromObject
      expect(newEmpanada.maxReached()).toBeFalsy()

      newEmpanada.qty = 100
      expect(newEmpanada.maxReached()).toBeTruthy()

  describe "update quantity functionality", ->

    it "should update quantity adding 4 items", ->
      newEmpanada = new Empanada fromObject
      newEmpanada.updateQty +4
      expect(newEmpanada.qty).toBe 5

    it "should update to zero when result is less than zero", ->
      newEmpanada = new Empanada fromObject
      newEmpanada.qty = 1
      newEmpanada.updateQty -5
      expect(newEmpanada.qty).toBe 0

    it "should update quantity sustracting 2 items", ->
      newEmpanada = new Empanada fromObject
      newEmpanada.qty = 10

      newEmpanada.updateQty -2
      expect(newEmpanada.qty).toBe 8


  describe "get hash", ->

    it "should create hash - case 1", ->
      newEmpanada = new Empanada fromObject

      expect(newEmpanada.getHash()).toBe 'ID_BRAND|505|HORNO||'

    it "should create a hash - case 2", ->
      newEmpanada = new Empanada {id:909,type:"frita"}

      expect(newEmpanada.getHash()).toBe 'ID_BRAND|909|FRITA||'

    it "should create a hash - case 3", ->
      newEmpanada = new Empanada {id:777}

      expect(newEmpanada.getHash()).toBe 'ID_BRAND|777|||'


  it 'should generate a description from default values', ->
    empanada = new Empanada fromObject
    description = empanada.description()
    expect(description).toBe fromObject.desc + fromObject.type

  it 'should generate a description from changes values', ->
    empanada = new Empanada fromObject
    empanada.desc = 'JyQ'
    description = empanada.description()
    expect(description).toBe 'JyQ' + fromObject.type