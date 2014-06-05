describe 'BebidaPromoOrder', ->

  beforeEach ->
    module 'Muzza.bebidas'

  BebidaPromoOrder = Bebida = modal = showSpy = hideSpy = order = ShoppingCartService = undefined

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
      BebidaPromoOrder = $injector.get 'BebidaPromoOrder'
      ShoppingCartService = $injector.get 'ShoppingCartService'
      Bebida = $injector.get 'Bebida'
      modal =
        show: -> null
        hide: -> null
        scope:
          choosePromoItem: -> null

      showSpy = spyOn(modal, 'show').and.callThrough()
      hideSpy = spyOn(modal, 'hide').and.callThrough()

      order = new BebidaPromoOrder modal

  describe "Init", ->

    it 'should construct a BebidaPromoOrder object', ->
      expect(order.add).toBeDefined()
      expect(order.cancel).toBeDefined()
      expect(order.edit).toBeDefined()
      expect(order.show).toBeDefined()
      expect(order.hide).toBeDefined()


  describe "Hide", ->

    it 'should delegate the hide call to the modal', ->
      modal.scope.bebida = {}
      order.hide()

      expect(hideSpy).toHaveBeenCalled()

  describe "Show", ->

    it 'should delegate the show call to the modal', ->
      order.show()

      expect(showSpy).toHaveBeenCalled()


  describe "When the user confirms the product selection and options", ->

    bebida1 = bebida2 = bebida3 = order = undefined

    beforeEach ->
      bebida1 = new Bebida {id:11,desc:"Agua saborizada Levite",price:{base: 999,size:{individual: 0,chica: 1000,grande: 2000}},options: []}
      bebida2 = new Bebida {id:22,desc:"Agua sin gas",price:{base: 1000,size:{individual: 0,chica: 1000,grande: 2000}},options: []}
      bebida3 = new Bebida {id:33,desc:"Gaseosa Linea CocaCola",price:{base: 1000,size:{individual: 0,chica: 1000,grande: 2000}},options: ["Coca","Fanta","Sprite","Coca diet"]}

      modal.scope.bebida = bebida1

      modal.scope.menu = [
        id:1
        description: "categ 1"
        products: [bebida1, bebida2]
      ,
        id:2
        description:"categ 2"
        products: [bebida3]
      ]
      order = new BebidaPromoOrder modal


    it 'should update promo components with promo selected and hide', ->

      updatedBebida = angular.copy bebida2
      updatedBebida.qty = 3
      updatedBebida.size = "grande"
      updatedBebida.something = "else"

      order.add updatedBebida

      expect(modal.scope.menu[0].products[0]).toEqual bebida1
      expect(modal.scope.menu[1].products[0]).toEqual bebida3

      expect(modal.scope.menu[0].products[1]).not.toEqual updatedBebida
      expect(modal.scope.menu[0].products[1].qty).toEqual updatedBebida.qty
      expect(modal.scope.menu[0].products[1].size).toEqual updatedBebida.size


  describe "When user decides to edit the selected product and options", ->
    bebida1 = bebida2 = bebida3 = order = undefined

    beforeEach ->
      bebida1 = new Bebida {id:11,desc:"Agua saborizada Levite",price:{base: 999,size:{individual: 0,chica: 1000,grande: 2000}},options: []}
      bebida2 = new Bebida {id:22,desc:"Agua sin gas",price:{base: 1000,size:{individual: 0,chica: 1000,grande: 2000}},options: []}
      bebida3 = new Bebida {id:33,desc:"Gaseosa Linea CocaCola",price:{base: 1000,size:{individual: 0,chica: 1000,grande: 2000}},options: ["Coca","Fanta","Sprite","Coca diet"]}

      modal.scope.bebida = bebida1

      modal.scope.menu = [
        id:1
        description: "categ 1"
        products: [bebida1, bebida2]
      ,
        id:2
        description:"categ 2"
        products: [bebida3]
      ]
      order = new BebidaPromoOrder modal

    it "should delegate call to modal", ->
      chooseSpy = spyOn(modal.scope, 'choosePromoItem').and.callThrough()
      order.edit bebida1
      expect(chooseSpy).toHaveBeenCalled()

    it "should reset price to its base price", ->
      chooseSpy = spyOn(modal.scope, 'choosePromoItem').and.callThrough()
      order.edit bebida1
      expect(chooseSpy).toHaveBeenCalledWith jasmine.objectContaining totalPrice: 999