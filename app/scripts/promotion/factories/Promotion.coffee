angular.module('Muzza.promo').factory 'Promotion', () ->

  class Promotion
    constructor: (from) ->
      @rules = createRulesArray from.rules
      @details =
        id: from.id
        price: from.price
        description:
          short: from.desc
          long: from.details

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

  Promotion::validate = (shoppingCart) ->
    console.log "Promotion::validate ---> NOT IMPLEMENTED"
    false
  Promotion::apply = (shoppingCart) ->
    console.log "Promotion::apply ---> NOT IMPLEMENTED"
    false

  return Promotion

