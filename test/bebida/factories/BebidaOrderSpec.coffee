#describe 'BebidaOrder', ->
#
#  beforeEach ->
#    module 'Muzza.bebidas'
#
#  BebidaOrder = Bebida = modal = showSpy = hideSpy = order = ShoppingCartService = undefined
#
#  beforeEach ->
#    module ($provide) ->
#      $provide.value "ShoppingCartService",
#        add: () ->
#          null
#        getCart: ()->
#          null
#      null
#
#  beforeEach ->
#    inject ($injector) ->
#      BebidaOrder = $injector.get 'BebidaOrder'
#      ShoppingCartService = $injector.get 'ShoppingCartService'
#      Bebida = $injector.get 'Bebida'
#      modal =
#        show: -> null
#        hide: -> null
#        scope:
#          choose: -> null
#
#      showSpy = spyOn(modal, 'show').and.callThrough()
#      hideSpy = spyOn(modal, 'hide').and.callThrough()
#
#      order = new BebidaOrder modal
#
#  describe "Init", ->
#
#    it 'should construct a BebidaOrder object', ->
#      expect(order.add).toBeDefined()
#      expect(order.show).toBeDefined()
#      expect(order.hide).toBeDefined()
#
#
#  describe "Hide", ->
#
#    it 'should delegate the hide call to the modal', ->
#      modal.scope.bebidaSelection = {}
#      order.hide()
#
#      expect(hideSpy).toHaveBeenCalled()
#
#  describe "Show", ->
#
#    it 'should delegate the show call to the modal', ->
#      order.show()
#
#      expect(showSpy).toHaveBeenCalled()
#
#
#  describe "When the user confirms the product selection and options", ->
#
#    item = Bebida = undefined
#
#    beforeEach ->
#      item = new Bebida {id:1,desc:'Gaseosa lala',size:'chica'}
#      modal.scope.bebidaSelection = item
#
#    it 'should call ShoppingCart to add a product and hide', ->
#      addSpy = spyOn(ShoppingCartService, 'add').and.callThrough()
#      internalHideSpy = spyOn(order, 'hide').and.callThrough()
#      order.add item
#
#      expect(addSpy).toHaveBeenCalledWith  jasmine.objectContaining {id:1,desc:'Gaseosa lala',size:'chica'}
#      expect(internalHideSpy).toHaveBeenCalled()