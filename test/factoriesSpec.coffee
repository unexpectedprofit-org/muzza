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
          scope:
            pizza:
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
        modal.scope.pizza.totalPrice = undefined
        size.show()
        expect(modal.scope.pizza.totalPrice).toBe modal.scope.pizza.price.base

      it "should leave the total price as it is if other options have alrady been selected", ->
        modal.scope.pizza.totalPrice = 50 + 15
        size.show()
        expect(modal.scope.pizza.totalPrice).toBe 65

      it 'should delegate the show call to the modal', ->
        size.show()

        expect(showSpy).toHaveBeenCalled()
        expect(showSpy.calls.count()).toBe 1

      it 'should delegate the hide call to the modal', ->
        size.hide()

        expect(hideSpy).toHaveBeenCalled()
        expect(hideSpy.calls.count()).toBe 1

    describe 'When the user choose a pizza size', ->

      it 'should calculate price adding totalPrice + current option', ->
        modal.scope.pizza.totalPrice =  50 + 15
        size.choose('chica')
        expect(modal.scope.pizza.totalPrice).toBe 75

      it 'should call hide', ->
        internalHideSpy = spyOn(size, 'hide').and.callThrough()
        size.choose()

        expect(internalHideSpy).toHaveBeenCalled()
        expect(internalHideSpy.calls.count()).toBe 1



  describe 'PizzaDough', ->

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

    describe "Init", ->

      it 'should construct a PizzaOrder object', ->
        expect(order.add).toBeDefined()
        expect(order.cancel).toBeDefined()
        expect(order.edit).toBeDefined()
        expect(order.show).toBeDefined()
        expect(order.hide).toBeDefined()

      it 'should delegate the show call to the modal', ->
        order.show()

        expect(showSpy).toHaveBeenCalled()
        expect(showSpy.calls.count()).toBe 1

      it 'should delegate the hide call to the modal', ->
        order.hide()

        expect(hideSpy).toHaveBeenCalled()
        expect(hideSpy.calls.count()).toBe 1

    describe "When the user confirms the product selection and options", ->

      it 'should call ShoppingCart to add a product and hide', ->
        addSpy = spyOn(ShoppingCart, 'addToCart').and.callThrough()
        internalHideSpy = spyOn(order, 'hide').and.callThrough()
        order.add({id:1, desc:'Muzza', size:'chica', dough:'a la piedra'})

        expect(addSpy).toHaveBeenCalledWith({id:1, desc:'Muzza chica a la piedra', size:'chica', dough:'a la piedra', qty:1})
        expect(addSpy.calls.count()).toBe 1
        expect(internalHideSpy).toHaveBeenCalled()
        expect(internalHideSpy.calls.count()).toBe 1

      it 'should form the descripcion based on the selected options', ->
        addSpy = spyOn(ShoppingCart, 'addToCart').and.callThrough()
        order.add({id:1, desc:'Muzza', size:'chica', dough:'a la piedra'})
        expect(addSpy).toHaveBeenCalledWith({id:1, desc:'Muzza chica a la piedra', size:'chica', dough:'a la piedra',qty:1})
        expect(addSpy.calls.count()).toBe 1


    describe "When user eliminates selected product and options", ->

      it "should hide confirmation modal", ->
        internalHideSpy = spyOn(order, 'hide').and.callThrough()
        order.cancel()

        expect(internalHideSpy).toHaveBeenCalled()
        expect(internalHideSpy.calls.count()).toBe 1

    describe "When user decides to edit the selected product and options", ->

      it "should display all option modals", ->
        chooseSpy = spyOn(modal.scope, 'choose').and.callThrough()
        order.edit({id:1})

        expect(chooseSpy).toHaveBeenCalledWith({id:1})
        expect(chooseSpy.calls.count()).toBe 1


  describe 'Empanada', ->

    Empanada = undefined

    beforeEach ->
      inject (_Empanada_) ->
        Empanada = _Empanada_

    it "should init the object with quantity = 1", ->
      newEmpanada = new Empanada()
      expect(newEmpanada.qty).toBe 1

    it "should init the object from another object", ->
      fromObject =
        desc: "description"
        price: 100.20
        type: "al horno"

      newEmpanada = new Empanada fromObject
      expect(newEmpanada.qty).toBe 1
      expect(newEmpanada.desc).toBe fromObject.desc
      expect(newEmpanada.price).toBe fromObject.price
      expect(newEmpanada.type).toBe fromObject.type

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
      newEmpanada.qty = 1
      newEmpanada.updateQty "a"
      expect(newEmpanada.qty).toBe 1

    it "should update quantity sustracting 2 items", ->
      newEmpanada = new Empanada()
      newEmpanada.qty = 10

      newEmpanada.updateQty -2
      expect(newEmpanada.qty).toBe 8

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

    it "should be equal", ->
      newEmpanada1 = new Empanada()
      newEmpanada1.qty = 10
      newEmpanada1.id = 23

      newEmpanada2 = new Empanada()
      newEmpanada2.qty = 10
      newEmpanada2.id = 23
      expect(newEmpanada1).toEqual newEmpanada2

  describe 'EmpanadaQty', ->

    EmpanadaQty = modal = showSpy = hideSpy = empanadaQty = undefined

    beforeEach ->
      inject (_EmpanadaQty_) ->
        EmpanadaQty = _EmpanadaQty_
        modal =
          show: -> null
          hide: -> null
          scope:
            empanada:
              qty: 1
              price:
                base: 10

        showSpy = spyOn(modal, 'show').and.callThrough()
        hideSpy = spyOn(modal, 'hide').and.callThrough()
        empanadaQty = new EmpanadaQty(modal)

    describe "Init", ->

      it 'should construct a EmpanadaQty object', ->
        expect(empanadaQty.choose).toBeDefined()
        expect(empanadaQty.show).toBeDefined()
        expect(empanadaQty.hide).toBeDefined()

    describe "When the user is on the quantity step", ->

      it 'should delegate the show call to the modal', ->
        empanadaQty.show()

        expect(showSpy).toHaveBeenCalled()
        expect(showSpy.calls.count()).toBe 1

      it 'should delegate the hide call to the modal', ->
        empanadaQty.hide()

        expect(hideSpy).toHaveBeenCalled()
        expect(hideSpy.calls.count()).toBe 1

      it 'should call hide', ->
        internalHideSpy = spyOn(empanadaQty, 'hide').and.callThrough()
        empanadaQty.choose()

        expect(internalHideSpy).toHaveBeenCalled()
        expect(internalHideSpy.calls.count()).toBe 1

      it 'should show totalprice for 1 unit at the beggining', ->
        empanadaQty.choose()

        expect(modal.scope.empanada.price.total).toBe 10

      it "should show totalprice for more than 1 unit", ->
        modal.scope.empanada.qty = 3
        empanadaQty.choose()
        expect(modal.scope.empanada.price.total).toBe 30


  describe 'EmpanadaOrder', ->

    EmpanadaOrder = modal = showSpy = hideSpy = order = ShoppingCart = undefined

    beforeEach ->
      module ($provide) ->
        $provide.value "ShoppingCart",
          addToCart: ()->
            return null
          getCart: ()->
            return null
        return null

    beforeEach ->
      inject (_EmpanadaOrder_, _ShoppingCart_) ->
        EmpanadaOrder = _EmpanadaOrder_
        ShoppingCart = _ShoppingCart_
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
        addSpy = spyOn(ShoppingCart, 'addToCart').and.callThrough()
        order.add({id:1, desc:'Humita', type:'Frita', qty:2, price: 15})

        expect(hideSpy).toHaveBeenCalled()
        expect(hideSpy.calls.count()).toBe 1

        expect(addSpy).toHaveBeenCalledWith  {id:1, desc:'Humita Frita', type:'Frita', qty:2, price: 15, totalPrice: 15}
        expect(addSpy.calls.count()).toBe 1

      it 'should form the descripcion based on the selected options', ->
        addSpy = spyOn(ShoppingCart, 'addToCart').and.callThrough()
        order.add({id:1, desc:'Pollo', type:'Al Horno', qty:3, price: 10})

        expect(addSpy).toHaveBeenCalledWith({id:1, desc:'Pollo Al Horno', type: "Al Horno", qty:3, totalPrice: 10, price: 10})
        expect(addSpy.calls.count()).toBe 1

    describe "When user eliminates selected product", ->

      it "should hide confirmation modal", ->
        order.cancel()

        expect(hideSpy).toHaveBeenCalled()
        expect(hideSpy.calls.count()).toBe 1

    describe "When user decides to edit the selected product and options", ->

      it "should display quantity modal", ->
        chooseSpy = spyOn(modal.scope, 'choose').and.callThrough()
        order.edit({id:1, desc:'Pollo', type:'Al Horno', qty:3, price: 10})

        expect(chooseSpy).toHaveBeenCalledWith({id:1, desc:'Pollo', type:'Al Horno', qty:3, price: 10})
        expect(chooseSpy.calls.count()).toBe 1