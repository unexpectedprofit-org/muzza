angular.module('Muzza.promo').factory 'Promo', () ->

  class Promo
    constructor: () ->
      @rules = []

  Promo::validate = (shoppingCart) ->

    isValid = true

#    console.log "usando rules: " + JSON.stringify @rules
#    console.log "cart: " + JSON.stringify shoppingCart


    _.each @rules, (rule) ->

      if !isValid then return
      #so that it does not do any logic over next elements since it's already NOT valid


      #filter by category
      elementsByCategoryArray = _.filter shoppingCart, (elem) ->
        elem.cat is rule.cat

      if elementsByCategoryArray.length is 0
#        console.log "NO VALIDA - CATEGORY"
        isValid = false
        return
      #filter by category



      #filter by SUB-category
      if angular.isDefined rule.subcat
        elementsBySubcategoryArray = _.filter elementsByCategoryArray, (elem) ->
          elem.subcat is rule.subcat

        if elementsBySubcategoryArray.length is 0
#          console.log "NO VALIDA - SUB CATEGORY"
          isValid = false
          return
      else
        elementsBySubcategoryArray = elementsByCategoryArray
      #filter by SUB-category



      #filter by quantity
      quantitiesArray = _.pluck elementsBySubcategoryArray, 'qty'

      totalQuantity = _.reduce quantitiesArray, (a, b) ->
        a + b

      if totalQuantity < rule.qty
#        console.log "NO VALIDA - QUANTITY"
        isValid = false
        return
      #filter by quantity

    return isValid


  Promo::apply = (shoppingCart) ->
    shoppingCart



  return Promo
