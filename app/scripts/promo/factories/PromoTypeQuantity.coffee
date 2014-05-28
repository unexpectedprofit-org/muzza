angular.module('Muzza.promo').factory 'PromoTypeQuantity', () ->


  class PromoTypeQuantity
    constructor: (customRules) ->
      @rules = createRulesArray customRules

    createRulesArray = (rulesArray) ->

      rules = []

      if angular.isUndefined( rulesArray ) or !(rulesArray instanceof Array) or rulesArray.length < 1
        #break / exit
#        console.log "ERROR - NO RULES DEFINED - WHOLE OBJECT"
        return []

      angular.forEach rulesArray, (element) ->

        tempRule =
          cat: element.cat
          subcat: element.subcat
          qty: element.qty

        rules.push tempRule

      return rules


  PromoTypeQuantity::validate = (shoppingCart) ->

    if angular.isUndefined( @rules ) or @rules.length < 1
      return false

    if angular.isUndefined( shoppingCart ) || !(shoppingCart instanceof Array) || shoppingCart.length < 1
      return false


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


  PromoTypeQuantity::apply = (shoppingCart) ->
    return false


  return PromoTypeQuantity