describe 'factories', ->

  beforeEach ->
    module 'Muzza.factories'

  describe 'PizzaSize', ->

    PizzaSize = modal = showSpy = hideSpy = size = undefined

    beforeEach ->
      inject (_PizzaSize_) ->
        PizzaSize = _PizzaSize_
        modal =
          show: -> null
          hide: -> null

        showSpy = spyOn(modal, 'show').and.callThrough()
        hideSpy = spyOn(modal, 'hide').and.callThrough()
        size = new PizzaSize(modal)

    describe "Init", ->

      it 'should construct a PizzaSize object', ->
        expect(size.choose()).toBeDefined()
        expect(size.show()).toBeDefined()
        expect(size.hide()).toBeDefined()

      it 'should delegate the show call to the modal', ->
        size.show()
        expect(showSpy).toHaveBeenCalled()

      it 'should delegate the hide call to the modal', ->
        size.hide()
        expect(hideSpy).toHaveBeenCalled()

    describe 'When the user choose a pizza size', ->

      it 'should call hide when the user chooses', ->
        internalHideSpy = spyOn(size, 'hide').and.callThrough()
        size.choose()
        expect(internalHideSpy).toHaveBeenCalled()

  describe 'PizzaDough', ->

    PizzaDough = modal = showSpy = hideSpy = dough = undefined

    beforeEach ->
      inject (_PizzaDough_) ->
        PizzaDough = _PizzaDough_
        modal =
          show: -> null
          hide: -> null

        showSpy = spyOn(modal, 'show').and.callThrough()
        hideSpy = spyOn(modal, 'hide').and.callThrough()

        dough = new PizzaDough(modal)

    describe "Init", ->

      it 'should construct a PizzaDough object', ->
        expect(dough.choose()).toBeDefined()
        expect(dough.show()).toBeDefined()
        expect(dough.hide()).toBeDefined()

      it 'should delegate the show call to the modal', ->
        dough.show()
        expect(showSpy).toHaveBeenCalled()

      it 'should delegate the hide call to the modal', ->
        dough.hide()
        expect(hideSpy).toHaveBeenCalled()

    describe 'When the user choose a pizza dough', ->

      it 'should call hide', ->
        internalHideSpy = spyOn(dough, 'hide').and.callThrough()
        dough.choose()
        expect(internalHideSpy).toHaveBeenCalled()


  describe 'PizzaOrder', ->

    PizzaOrder = modal = showSpy = hideSpy = order = ShoppingCart = undefined

    beforeEach ->
      module ($provide) ->
        $provide.value "ShoppingCart",
          addToCart: ()->
            return null
          getCart: ()->
            return null
        return null

    beforeEach ->
      inject (_PizzaOrder_, _ShoppingCart_) ->
        PizzaOrder = _PizzaOrder_
        ShoppingCart = _ShoppingCart_
        modal =
          show: -> null
          hide: -> null
          scope:
            choose: -> null

        showSpy = spyOn(modal, 'show').and.callThrough()
        hideSpy = spyOn(modal, 'hide').and.callThrough()

        order = new PizzaOrder(modal)

    describe "Inti", ->

      it 'should construct a PizzaOrder object', ->
        expect(order.add()).toBeDefined()
        expect(order.cancel()).toBeDefined()
        expect(order.edit()).toBeDefined()
        expect(order.show()).toBeDefined()
        expect(order.hide()).toBeDefined()

      it 'should delegate the show call to the modal', ->
        order.show()
        expect(showSpy).toHaveBeenCalled()

      it 'should delegate the hide call to the modal', ->
        order.hide()
        expect(hideSpy).toHaveBeenCalled()

    describe "When the user confirms the product selection and options", ->

      it 'should call ShoppingCart to add a product and hide', ->
        addSpy = spyOn(ShoppingCart, 'addToCart').and.callThrough()
        internalHideSpy = spyOn(order, 'hide').and.callThrough()
        order.add({id:1})
        expect(addSpy).toHaveBeenCalledWith({id:1})
        expect(internalHideSpy).toHaveBeenCalled()

    describe "When user eliminates selected product and options", ->

      it "should hide confirmation modal", ->
        internalHideSpy = spyOn(order, 'hide').and.callThrough()
        order.cancel()
        expect(internalHideSpy).toHaveBeenCalled()

    describe "When user decides to edit the selected product and options", ->

      it "should display all option modals", ->
        chooseSpy = spyOn(modal.scope, 'choose').and.callThrough()
        order.edit({id:1})
        expect(chooseSpy).toHaveBeenCalledWith({id:1})








