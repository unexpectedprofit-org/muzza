describe 'Empanada', ->

  beforeEach ->
    module 'Muzza.empanadas'

  Empanada = fromObject = undefined

  beforeEach ->
    inject (_Empanada_) ->
      Empanada = _Empanada_

    fromObject =
      id: 505
      description: "description"
      price:
        base: 1020
      subcat: 98
      type: "Al Horno"

  describe "init", ->

    it "should construct a Empanada object", ->
      newEmpanada = new Empanada {}
      expect(newEmpanada.updateQty).toBeDefined()
      expect(newEmpanada.getDescription).toBeDefined()
      expect(newEmpanada.getHash).toBeDefined()
      expect(newEmpanada.reset).toBeDefined()
      expect(newEmpanada.isEditable).toBeDefined()

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
      expect(newEmpanada.subcat).toBe fromObject.subcat
      expect(newEmpanada.type).toBe fromObject.type
      expect(newEmpanada.id).toBe fromObject.id
      expect(newEmpanada.desc).toBe fromObject.desc
      expect(newEmpanada.totalPrice).toBe fromObject.price.base


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

      expect(newEmpanada.getHash()).toBe 'ID_BRAND|505|98||'

    it "should create a hash - case 2", ->
      newEmpanada = new Empanada {id:909,subcat:55}

      expect(newEmpanada.getHash()).toBe 'ID_BRAND|909|55||'


  describe "getDescription functionality", ->

    it 'should generate a description from default values', ->
      empanada = new Empanada fromObject
      expect(empanada.getDescription()).toBe fromObject.description + fromObject.type

    it 'should generate a description from changes values', ->
      empanada = new Empanada fromObject
      empanada.description = 'JyQ'
      expect(empanada.getDescription()).toBe 'JyQ' + fromObject.type


  describe "reset functionality", ->

    it 'should reset item', ->
      empanada = new Empanada fromObject
      empanada.reset()

      expect(empanada.id).toBe fromObject.id
      expect(empanada.description).toBe fromObject.description
      expect(empanada.type).toBe fromObject.type
      expect(empanada.subcat).toBe fromObject.subcat
      expect(empanada.price.base).toBe fromObject.price.base

      expect(empanada.cat).toBe 'EMPANADA'
      expect(empanada.totalPrice).toBe 0
      expect(empanada.qty).toBe 1

  describe "isEditable functionality", ->

    it "should return false", ->

      empanada = new Empanada {}
      expect(empanada.isEditable()).toBeFalsy()