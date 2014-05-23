describe 'PizzaDough', ->

  beforeEach ->
    module 'Muzza.pizzas'

  PizzaDough = modal = showSpy = hideSpy = dough = undefined

  beforeEach ->
    inject (_PizzaDough_) ->
      PizzaDough = _PizzaDough_
      modal =
        show: -> null
        hide: -> null
        scope:
          pizza:
            price:
              base: 50
              dough:
                'al molde': 0
                'a la piedra': 0

      showSpy = spyOn(modal, 'show').and.callThrough()
      hideSpy = spyOn(modal, 'hide').and.callThrough()

      dough = new PizzaDough(modal)

  describe "Init", ->

    it 'should construct a PizzaDough object', ->
      expect(dough.choose).toBeDefined()
      expect(dough.show).toBeDefined()
      expect(dough.hide).toBeDefined()

    describe "When the user is displayed is the list of options", ->

      it "should calculate the initial total price to match the base price when no other options has been selected yet", ->
        modal.scope.pizza.totalPrice = undefined
        dough.show()
        expect(modal.scope.pizza.totalPrice).toBe modal.scope.pizza.price.base

      it "should leave the total price as it is if other options have alrady been selected", ->
        modal.scope.pizza.totalPrice = 50 + 15
        dough.show()
        expect(modal.scope.pizza.totalPrice).toBe 65

      it 'should delegate the show call to the modal', ->
        dough.show()

        expect(showSpy).toHaveBeenCalled()
        expect(showSpy.calls.count()).toBe 1

      it 'should delegate the hide call to the modal', ->
        dough.hide()

        expect(hideSpy).toHaveBeenCalled()
        expect(hideSpy.calls.count()).toBe 1

  describe 'When the user choose a pizza dough', ->

    it 'should calculate price suming totalPrice + current option', ->
      modal.scope.pizza.totalPrice =  50 + 15
      dough.choose('al molde')
      expect(modal.scope.pizza.totalPrice).toBe 65

    it 'should call hide', ->
      internalHideSpy = spyOn(dough, 'hide').and.callThrough()
      dough.choose()

      expect(internalHideSpy).toHaveBeenCalled()
      expect(internalHideSpy.calls.count()).toBe 1