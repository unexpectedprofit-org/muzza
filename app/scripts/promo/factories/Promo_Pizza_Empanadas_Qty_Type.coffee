angular.module('Muzza.promo').factory 'Promo_Pizza_Empanadas_Qty_Type', (Promo) ->


  class Promo_Pizza_Empanadas_Qty_Type extends Promo
    constructor: (pizza_category, pizza_quantity, emp_category, emp_quantity) ->
      @rules = [
        cat: 'EMPANADA'
        subcat: emp_category
        qty: emp_quantity
      ,
        cat: 'PIZZA'
        subcat: pizza_category
        qty: pizza_quantity
      ]

  return Promo_Pizza_Empanadas_Qty_Type
