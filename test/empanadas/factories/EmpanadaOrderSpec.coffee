describe 'EmpanadaOrder', ->

  beforeEach ->
    module 'Muzza.empanadas'

  EmpanadaOrder = modal = showSpy = hideSpy = order = ShoppingCartService = undefined

  beforeEach ->
    module ($provide) ->
      $provide.value "ShoppingCartService",
        add: ()->
          return null
      return null

  beforeEach ->
    inject (_EmpanadaOrder_, _ShoppingCartService_) ->
      EmpanadaOrder = _EmpanadaOrder_
      ShoppingCartService = _ShoppingCartService_
      modal =
        show: -> null
        hide: -> null
        scope:
          choose: -> null

      showSpy = spyOn(modal, 'show').and.callThrough()
      hideSpy = spyOn(modal, 'hide').and.callThrough()

      order = new EmpanadaOrder modal

  describe "Init", ->

    it 'should construct a EmpanadaOrder object', ->

      expect(order.add).toBeDefined()
      expect(order.cancel).toBeDefined()
      expect(order.edit).toBeDefined()
      expect(order.show).toBeDefined()
      expect(order.hide).toBeDefined()

    it "should init the object", ->
      expect(order.modal).toBe modal

  describe "call the modal", ->

    it 'should delegate the show call to the modal', ->
      order.show()

      expect(showSpy).toHaveBeenCalled()
      expect(showSpy.calls.count()).toBe 1

    it 'should delegate the hide call to the modal', ->
      order.hide()

      expect(hideSpy).toHaveBeenCalled()
      expect(hideSpy.calls.count()).toBe 1

  describe "When the user confirms the product selection and quantity", ->

    it 'should call ShoppingCart to add a product and hide', ->
      addSpy = spyOn(ShoppingCartService, 'add').and.callThrough()
      order.add {id:1, desc:'Humita', type:'Frita', qty:2, price: 15, cat: 'EMPANADA'}

      expect(hideSpy).toHaveBeenCalled()
      expect(hideSpy.calls.count()).toBe 1

      expect(addSpy).toHaveBeenCalledWith  jasmine.objectContaining {id:1, desc:'Humita Frita', type:'Frita', qty:2, price: 15, totalPrice: 15, cat: 'EMPANADA'}
      expect(addSpy.calls.count()).toBe 1

    it 'should form the descripcion based on the selected options', ->
      addSpy = spyOn(ShoppingCartService, 'add').and.callThrough()
      order.add {id:1, desc:'Pollo', type:'Al Horno', qty:3, price: 10, cat: 'EMPANADA'}

      expect(addSpy).toHaveBeenCalledWith jasmine.objectContaining {id:1, desc:'Pollo Al Horno'}
      expect(addSpy.calls.count()).toBe 1

    it 'should form a hash', ->
      addSpy = spyOn(ShoppingCartService, 'add').and.callThrough()
      order.add {id:4, desc:'Humita', type:'Al Horno'}

      expect(addSpy).toHaveBeenCalledWith jasmine.objectContaining {id:4, hash: '4-humita-alhorno'}
      expect(addSpy.calls.count()).toBe 1

  describe "When user eliminates selected product", ->

    it "should hide confirmation modal", ->
      order.cancel()

      expect(hideSpy).toHaveBeenCalled()
      expect(hideSpy.calls.count()).toBe 1

  describe "When user decides to edit the selected product and options", ->

    it "should display quantity modal", ->
      empanadaToEdit = {id:1, desc:'Pollo', type:'Al Horno', qty:3, price: 10}
      chooseSpy = spyOn(modal.scope, 'choose').and.callThrough()
      order.edit empanadaToEdit

      expect(chooseSpy).toHaveBeenCalledWith empanadaToEdit
      expect(chooseSpy.calls.count()).toBe 1