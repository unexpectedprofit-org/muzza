describe 'PizzaSize', ->

  beforeEach ->
    module 'Muzza.pizzas'

  PizzaSize = Pizza= modal = showSpy = hideSpy = size = undefined

  beforeEach ->
    inject (_PizzaSize_, _Pizza_) ->
      PizzaSize = _PizzaSize_
      Pizza = _Pizza_
      modal =
        show: -> null
        hide: -> null
        scope:
          pizzaSelection: new Pizza
            price:
              base: 50
              size:
                individual: 0
                chica: 10
                grande: 20

      showSpy = spyOn(modal, 'show').and.callThrough()
      hideSpy = spyOn(modal, 'hide').and.callThrough()
      size = new PizzaSize(modal)

  describe "Init", ->

    it 'should construct a PizzaSize object', ->
      expect(size.choose).toBeDefined()
      expect(size.show).toBeDefined()
      expect(size.hide).toBeDefined()

  describe "When the user is displayed is the list of options", ->

    it "should calculate the initial total price to match the base price when no other options has been selected yet", ->
      modal.scope.pizzaSelection.totalPrice = undefined
      size.show()
      expect(modal.scope.pizzaSelection.totalPrice).toBe modal.scope.pizzaSelection.price.base

    it "should calculate the initial total price to match the base price when totalPrice is 0", ->
      modal.scope.pizzaSelection.totalPrice = 0
      size.show()
      expect(modal.scope.pizzaSelection.totalPrice).toBe modal.scope.pizzaSelection.price.base


    it "should leave the total price as it is if other options have alrady been selected", ->
      modal.scope.pizzaSelection.totalPrice = 50 + 15
      size.show()
      expect(modal.scope.pizzaSelection.totalPrice).toBe 65

    it 'should delegate the show call to the modal', ->
      size.show()

      expect(showSpy).toHaveBeenCalled()

    it 'should delegate the hide call to the modal', ->
      size.hide()

      expect(hideSpy).toHaveBeenCalled()

  describe 'When the user choose a pizza size', ->

    it 'should calculate price adding totalPrice + current option', ->
      modal.scope.pizzaSelection.totalPrice =  50 + 15
      size.choose('chica')
      expect(modal.scope.pizzaSelection.totalPrice).toBe 75

    it 'should call hide', ->
      internalHideSpy = spyOn(size, 'hide').and.callThrough()
      size.choose()

      expect(internalHideSpy).toHaveBeenCalled()