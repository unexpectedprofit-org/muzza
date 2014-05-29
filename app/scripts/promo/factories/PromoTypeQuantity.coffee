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


      ############################filter by category############################
      elementsByCategoryArray = _.filter shoppingCart, (elem) ->
        elem.cat is rule.cat

      if elementsByCategoryArray.length is 0
#        console.log "NO VALIDA - CATEGORY"
        isValid = false
        return
      ############################filter by category############################



      ############################filter by SUB-category############################
      if angular.isDefined rule.subcat
        subCatComponents = rule.subcat.split('|')

        #ID_PROD
        ruleProp1 = (if subCatComponents[0].length > 0 then subCatComponents[0] else undefined)

        #TYPE:
          # DE LA CASA / ESPECIAL
          # FRITO / HORNO
        ruleProp2 = (if subCatComponents[1].length > 0 then subCatComponents[1] else undefined)

        # SIZE
        ruleProp3 = (if subCatComponents[2].length > 0 then subCatComponents[2] else undefined)

        # DOUGH
        ruleProp4 = (if subCatComponents[3].length > 0 then subCatComponents[3] else undefined)

        elementsMatchingProps = _.filter elementsByCategoryArray, (element) ->

          #get properties from product hashkey
          hashKeyComponents = element.hashKey.split('|')
          prodProp1 = (if hashKeyComponents[1].length > 0 then hashKeyComponents[1] else undefined)
          prodProp2 = (if hashKeyComponents[2].length > 0 then hashKeyComponents[2] else undefined)
          prodProp3 = (if hashKeyComponents[3].length > 0 then hashKeyComponents[3] else undefined)
          prodProp4 = (if hashKeyComponents[4].length > 0 then hashKeyComponents[4] else undefined)

#          console.log "prodProp1: " + prodProp1 + " / ruleProp1: " + ruleProp1
#          console.log "prodProp2: " + prodProp2 + " / ruleProp2: " + ruleProp2
#          console.log "prodProp3: " + prodProp3 + " / ruleProp3: " + ruleProp3

          isValidCondition1 = true
          isValidCondition2 = true
          isValidCondition3 = true
          isValidCondition4 = true

          if ruleProp1 isnt undefined then isValidCondition1 = prodProp1 is ruleProp1
          if ruleProp2 isnt undefined then isValidCondition2 = prodProp2 is ruleProp2
          if ruleProp3 isnt undefined then isValidCondition3 = prodProp3 is ruleProp3
          if ruleProp4 isnt undefined then isValidCondition4 = prodProp4 is ruleProp4

          isValidCondition1 and isValidCondition2 and isValidCondition3 and isValidCondition4


        if elementsMatchingProps.length is 0
#          console.log "NO VALIDA - SUB CATEGORY"
          isValid = false
          return false

        elementsBySubcategoryArray = elementsMatchingProps
      else
        elementsBySubcategoryArray = elementsByCategoryArray
      ############################filter by SUB-category############################



      ############################filter by quantity############################
      quantitiesArray = _.pluck elementsBySubcategoryArray, 'qty'

      totalQuantity = _.reduce quantitiesArray, (a, b) ->
        a + b

      if totalQuantity < rule.qty
#        console.log "NO VALIDA - QUANTITY"
        isValid = false
        return
      ############################filter by quantity############################

    return isValid

  PromoTypeQuantity::apply = (shoppingCart) ->
    return false


  return PromoTypeQuantity