describe 'BebidaSize', ->

  beforeEach ->
    module 'Muzza.bebidas'

  BebidaSize = Bebida  = modal = showSpy = hideSpy = size = undefined

  beforeEach ->
    inject ($injector) ->
      BebidaSize = $injector.get 'BebidaSize'
      Bebida = $injector.get 'Bebida'
      modal =
        show: -> null
        hide: -> null
        scope:
          bebidaSelection: new Bebida
            price:
              base: 50
              size:
                individual: 0
                chica: 10
                grande: 20

      showSpy = spyOn(modal, 'show').and.callThrough()
      hideSpy = spyOn(modal, 'hide').and.callThrough()
      size = new BebidaSize modal

  describe "Init", ->

    it 'should construct a BebidaSize object', ->
      expect(size.choose).toBeDefined()
      expect(size.show).toBeDefined()
      expect(size.hide).toBeDefined()

  describe "When the user is displayed the list of options", ->

    it "should calculate the initial total price to match the base price when no other options has been selected yet", ->
      modal.scope.bebidaSelection.totalPrice = undefined
      size.show()
      expect(modal.scope.bebidaSelection.totalPrice).toBe modal.scope.bebidaSelection.price.base

    it "should calculate the initial total price to match the base price when totalPrice is 0", ->
      modal.scope.bebidaSelection.totalPrice = 0
      size.show()
      expect(modal.scope.bebidaSelection.totalPrice).toBe modal.scope.bebidaSelection.price.base

    it "should leave the total price as it is if other options have alrady been selected", ->
      modal.scope.bebidaSelection.totalPrice = 50 + 15
      size.show()
      expect(modal.scope.bebidaSelection.totalPrice).toBe 65

    it 'should delegate the show call to the modal', ->
      size.show()

      expect(showSpy).toHaveBeenCalled()

    it 'should delegate the hide call to the modal', ->
      size.hide()

      expect(hideSpy).toHaveBeenCalled()

  describe 'When the user choose a bebidaSelection size', ->

    it 'should calculate price adding totalPrice + current option', ->
      modal.scope.bebidaSelection.totalPrice =  50 + 15
      size.choose('chica')
      expect(modal.scope.bebidaSelection.totalPrice).toBe 75

    it 'should call hide', ->
      internalHideSpy = spyOn(size, 'hide').and.callThrough()
      size.choose()

      expect(internalHideSpy).toHaveBeenCalled()