describe 'Empanada', ->

  beforeEach ->
    module 'Muzza.empanadas'

  Empanada = undefined

  beforeEach ->
    inject (_Empanada_) ->
      Empanada = _Empanada_

  describe "init", ->

    it "should construct a Empanada object", ->
      newEmpanada = new Empanada()
      expect(newEmpanada.updateQty).toBeDefined()
      expect(newEmpanada.minReached).toBeDefined()
      expect(newEmpanada.maxReached).toBeDefined()

    it "should init the object", ->
      newEmpanada = new Empanada()
      expect(newEmpanada.qty).toBe 1
      expect(newEmpanada.cat).toBe "EMPANADA"

    it "should init the object from another object", ->
      fromObject =
        id: 505
        desc: "description"
        price: 1020
        type: "al horno"

      newEmpanada = new Empanada fromObject
      expect(newEmpanada.qty).toBe 1
      expect(newEmpanada.cat).toBe "EMPANADA"
      expect(newEmpanada.id).toBe 505
      expect(newEmpanada.desc).toBe fromObject.desc
      expect(newEmpanada.price).toBe fromObject.price
      expect(newEmpanada.type).toBe fromObject.type

  describe "max/min allowed", ->

    it "should validate min quantity", ->
      newEmpanada = new Empanada()
      expect(newEmpanada.minReached()).toBeTruthy()

      newEmpanada.qty = 10
      expect(newEmpanada.minReached()).toBeFalsy()

    it "should validate max quantity", ->
      newEmpanada = new Empanada()
      expect(newEmpanada.maxReached()).toBeFalsy()

      newEmpanada.qty = 100
      expect(newEmpanada.maxReached()).toBeTruthy()

  describe "update quantity functionality", ->

    it "should update quantity adding 4 items", ->
      newEmpanada = new Empanada()
      newEmpanada.updateQty +4
      expect(newEmpanada.qty).toBe 5

    it "should update to zero when result is less than zero", ->
      newEmpanada = new Empanada()
      newEmpanada.qty = 1
      newEmpanada.updateQty -5
      expect(newEmpanada.qty).toBe 0

    it "should return current quantity is new is not a number", ->
      newEmpanada = new Empanada()
      newEmpanada.qty = 4
      newEmpanada.updateQty "a"
      expect(newEmpanada.qty).toBe 4

    it "should update quantity sustracting 2 items", ->
      newEmpanada = new Empanada()
      newEmpanada.qty = 10

      newEmpanada.updateQty -2
      expect(newEmpanada.qty).toBe 8

  it 'should generate a description from default values', ->
    empanada = new Empanada()
    description = empanada.description()
    expect(description).toBe ''

  it 'should generate a description from changes values', ->
    empanada = new Empanada()
    empanada.desc = 'JyQ'
    description = empanada.description()
    expect(description).toBe 'JyQ'