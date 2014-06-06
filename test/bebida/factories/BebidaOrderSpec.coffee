describe 'BebidaOrder', ->

  beforeEach ->
    module 'Muzza.bebidas'

  BebidaOrder = Bebida = modal = showSpy = hideSpy = order = ShoppingCartService = undefined

  beforeEach ->
    module ($provide) ->
      $provide.value "ShoppingCartService",
        add: () ->
          return null
        getCart: ()->
          return null
      $provide.value "$state",
        go: ()-> ''
      return null

  beforeEach ->
    inject ($injector) ->
      BebidaOrder = $injector.get 'BebidaOrder'
      ShoppingCartService = $injector.get 'ShoppingCartService'
      Bebida = $injector.get 'Bebida'
      modal =
        show: -> null
        hide: -> null
        scope:
          choose: -> null

      showSpy = spyOn(modal, 'show').and.callThrough()
      hideSpy = spyOn(modal, 'hide').and.callThrough()

      order = new BebidaOrder modal

  describe "Init", ->

    it 'should construct a BebidaOrder object', ->
      expect(order.add).toBeDefined()
      expect(order.cancel).toBeDefined()
      expect(order.edit).toBeDefined()
      expect(order.show).toBeDefined()
      expect(order.hide).toBeDefined()
      expect(order.isMinAllowed).toBeDefined()
      expect(order.isMaxAllowed).toBeDefined()


  describe "Hide", ->

    it 'should delegate the hide call to the modal', ->
      modal.scope.bebidaSelection = {}
      order.hide()

      expect(hideSpy).toHaveBeenCalled()

    it 'should redirect to the menu', ->
      inject ($state) ->
        spyOn($state, 'go').and.callThrough()
        modal.scope.bebidaSelection = {}
        order.hide()
        expect($state.go).toHaveBeenCalledWith('app.menu')

  describe "Show", ->

    it 'should delegate the show call to the modal', ->
      order.show()

      expect(showSpy).toHaveBeenCalled()


  describe "min/max allowance", ->

    it "should check minimum quantities", ->
      modal.scope.bebidaSelection =
        qty: 8

      expect(order.isMinAllowed()).toBeFalsy()

      modal.scope.bebidaSelection.qty = 0
      expect(order.isMinAllowed()).toBeTruthy()

      modal.scope.bebidaSelection.qty = 1
      expect(order.isMinAllowed()).toBeTruthy()

    it "should check maximum quantities", ->
      modal.scope.bebidaSelection =
        qty: 8

      expect(order.isMaxAllowed()).toBeFalsy()

      modal.scope.bebidaSelection.qty = 0
      expect(order.isMaxAllowed()).toBeFalsy()

      modal.scope.bebidaSelection.qty = 10
      expect(order.isMaxAllowed()).toBeTruthy()
      
  describe "When the user confirms the product selection and options", ->

    item = Bebida = undefined

    beforeEach ->
      item = new Bebida {id:1,desc:'Gaseosa lala',size:'chica'}
      modal.scope.bebidaSelection = item

    it 'should call ShoppingCart to add a product and hide', ->
      addSpy = spyOn(ShoppingCartService, 'add').and.callThrough()
      internalHideSpy = spyOn(order, 'hide').and.callThrough()
      order.add item

      expect(addSpy).toHaveBeenCalledWith  jasmine.objectContaining {id:1,desc:'Gaseosa lala',size:'chica'}
      expect(internalHideSpy).toHaveBeenCalled()

  describe "When user eliminates selected product and options", ->

    it "should hide confirmation modal", ->
      internalHideSpy = spyOn(order, 'hide').and.callThrough()
      order.cancel()

      expect(internalHideSpy).toHaveBeenCalled()

  describe "When user decides to edit the selected product and options", ->

    it "should display all option modals", ->
      chooseSpy = spyOn(modal.scope, 'choose').and.callThrough()
      order.edit(new Bebida({id:1, totalPrice: 60, price: {base: 50 }}))
      expect(chooseSpy).toHaveBeenCalled()

    it "should reset price to its base price", ->
      chooseSpy = spyOn(modal.scope, 'choose').and.callThrough()
      order.edit(new Bebida({id:1, totalPrice: 60, price: {base: 50 }}))
      expect(chooseSpy).toHaveBeenCalledWith jasmine.objectContaining totalPrice: 50