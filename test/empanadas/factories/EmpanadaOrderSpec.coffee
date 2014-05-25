describe 'EmpanadaOrder', ->

  beforeEach ->
    module 'Muzza.empanadas'

  EmpanadaOrder = modal = showSpy = hideSpy = order = ShoppingCartService = undefined

  beforeEach ->
    module ($provide) ->
      $provide.value "ShoppingCartService",
        add: ()-> null
      $provide.value "$state",
        go: ()-> ''
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
          remove: -> null

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

  describe "show functionality", ->

    it 'should delegate call to the modal', ->
      order.show()

      expect(showSpy).toHaveBeenCalled()
      expect(showSpy.calls.count()).toBe 1

  describe "hide functionality", ->

    it 'should delegate call to the modal', ->
      order.hide()

      expect(hideSpy).toHaveBeenCalled()
      expect(hideSpy.calls.count()).toBe 1

    it 'should redirect to the menu', ->
      inject ($state) ->
        spyOn($state, 'go').and.callThrough()
        modal.scope.empanada = {}
        order.hide()
        expect($state.go).toHaveBeenCalledWith('app.menu')

  describe "When the user confirms the product selection and quantity", ->

    it 'should call ShoppingCart to add a product and hide', ->
      addSpy = spyOn(ShoppingCartService, 'add').and.callThrough()
      empanada =
        id:1
        desc:'Humita'
        type:'Frita'
        qty:2
        totalPrice: 15
        cat: 'EMPANADA'

      order.add empanada

      expect(hideSpy).toHaveBeenCalled()
      expect(hideSpy.calls.count()).toBe 1

      expect(addSpy).toHaveBeenCalledWith  empanada
      expect(addSpy.calls.count()).toBe 1

  describe "cancel functionality", ->

    it "should hide confirmation modal", ->
      order.cancel()

      expect(hideSpy).toHaveBeenCalled()
      expect(hideSpy.calls.count()).toBe 1

    it "should delegate call to the scope", ->
      removeSpy = spyOn(modal.scope,'remove').and.callThrough()
      order.cancel()

      expect(removeSpy).toHaveBeenCalled()
      expect(removeSpy.calls.count()).toBe 1


  describe "When user decides to edit the selected product and options", ->

    it "should display quantity modal", ->
      empanadaToEdit = {id:1, desc:'Pollo', type:'Al Horno', qty:3, price: 10}
      chooseSpy = spyOn(modal.scope, 'choose').and.callThrough()
      order.edit empanadaToEdit

      expect(chooseSpy).toHaveBeenCalledWith empanadaToEdit
      expect(chooseSpy.calls.count()).toBe 1