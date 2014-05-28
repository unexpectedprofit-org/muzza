angular.module('Muzza.promo').factory 'Promo_Empanadas_Qty_Type', (Promo) ->


  class Promo_Empanadas_Qty_Type extends Promo
    constructor: (qty, type) ->
      @rules = [
        cat: 'EMPANADA'
        subcat: type
        qty: qty
      ]

  return Promo_Empanadas_Qty_Type
