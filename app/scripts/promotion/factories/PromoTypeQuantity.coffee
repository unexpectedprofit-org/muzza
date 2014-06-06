angular.module('Muzza.promo').factory 'PromoTypeQuantity', () ->


  class PromoTypeQuantity
    constructor: (from) ->
      @rules = createRulesArray from
      @details =
        id: from.id
        price: from.price
        description:
          short: from.desc
          long: from.details

    createRulesArray = (object) ->

      rules = []

      if angular.isUndefined( object.rules ) or
          !(object.rules instanceof Array) or
          object.rules.length < 1 or
          angular.isUndefined ( object.price )
        #break / exit
#        console.log "ERROR - NO RULES DEFINED - WHOLE OBJECT"
        return []

      angular.forEach object.rules, (element) ->

        tempRule =
          id: "rule:" + element.cat + "-" + element.subcat
          cat: element.cat
          subcat: element.subcat
          qty: element.qty

        rules.push tempRule

      return rules


    getQuantityFromCart = (shoppingCart) ->
      quantitiesArray = _.pluck shoppingCart, 'qty'
      totalQuantity = _.reduce quantitiesArray, (a, b) ->
        a + b
      totalQuantity



    PromoTypeQuantity::validate = (otherRules) ->

      response =
        success: true
        details: []

      isValid = true

#      console.log "usando rules: " + JSON.stringify @rules
#      console.log "components: " + JSON.stringify @components

      rulesToValidate = @rules
      if angular.isDefined( otherRules )
        rulesToValidate = otherRules


      components = @components
      _.forEach rulesToValidate, (rule) ->
        elementsMatchingProps = []

        if !isValid then return
        #so that it does not do any logic over next elements since it's already NOT valid


        ############################filter by category############################
#        resultSetArray = _.filter components, (component) ->
#          component.cat is rule.cat

        rulecat = rule.cat
        resultSetArray = components[rulecat]

        if resultSetArray.length is 0
#          console.log "NO VALIDA - CATEGORY"
          isValid = false
          response.details.push {rule: rule, cause: "category"}
          response.success = false
          return
        ############################filter by category############################



        ############################filter by SUB-category############################
        if angular.isDefined rule.subcat
          subCatComponents = rule.subcat.split('|')

          #ID_PROD
          ruleProp1 = (if subCatComponents[0].length > 0 then parseInt(subCatComponents[0]) else undefined)

          #TYPE:
            # DE LA CASA / ESPECIAL
            # FRITO / HORNO
          ruleProp2 = (if subCatComponents[1].length > 0 then parseInt(subCatComponents[1]) else undefined)

          # SIZE
          ruleProp3 = (if subCatComponents[2].length > 0 then subCatComponents[2] else undefined)

          # DOUGH
          ruleProp4 = (if subCatComponents[3].length > 0 then subCatComponents[3] else undefined)


          if angular.isDefined(ruleProp1) or angular.isDefined(ruleProp2) or angular.isDefined(ruleProp3) or angular.isDefined(ruleProp4)

            _.forEach resultSetArray, (category) ->

              catId = category.id

              _temp = _.filter category.products, (element) ->
              #get properties from product hashkey
                hashKeyComponents = element.getHash().split('|')
                prodProp1 = (if hashKeyComponents[1].length > 0 then parseInt(hashKeyComponents[1]) else undefined)
                prodProp2 = (if hashKeyComponents[2].length > 0 then parseInt(hashKeyComponents[2]) else undefined)
                prodProp3 = (if hashKeyComponents[3].length > 0 then hashKeyComponents[3] else undefined)
                prodProp4 = (if hashKeyComponents[4].length > 0 then hashKeyComponents[4] else undefined)

#                console.log "prodProp1: " + prodProp1 + " / ruleProp1: " + ruleProp1
#                console.log "prodProp2: " + prodProp2 + " / ruleProp2: " + ruleProp2
#                console.log "prodProp3: " + prodProp3 + " / ruleProp3: " + ruleProp3
#                console.log "prodProp4: " + prodProp4 + " / ruleProp4: " + ruleProp4

                isValidCondition1 = true
                isValidCondition2 = true
                isValidCondition3 = true
                isValidCondition4 = true

                if ruleProp1 isnt undefined then isValidCondition1 = prodProp1 is ruleProp1
                if ruleProp2 isnt undefined then isValidCondition2 = prodProp2 is ruleProp2
                if ruleProp3 isnt undefined then isValidCondition3 = prodProp3 is ruleProp3
                if ruleProp4 isnt undefined then isValidCondition4 = prodProp4 is ruleProp4

#                console.log "isValidCondition1 " + isValidCondition1
#                console.log "isValidCondition2 " + isValidCondition2
#                console.log "isValidCondition3 " + isValidCondition3
#                console.log "isValidCondition4 " + isValidCondition4

                isValidCondition1 and isValidCondition2 and isValidCondition3 and isValidCondition4

              if _temp.length > 0
                elementsMatchingProps.push {id: catId, products:_temp}


            resultSetArray = elementsMatchingProps
          else
#            resultSetArray = resultSetArray[0].items
        else
#          resultSetArray = resultSetArray[0].items

#        console.log "out: " +  JSON.stringify resultSetArray
        ############################filter by SUB-category############################



        ############################filter by quantity############################
        total = 0
        _.forEach resultSetArray, (categoryItem) ->
          quantitiesArray = _.pluck categoryItem.products, 'qty'
          totalQuantity = _.reduce quantitiesArray, (a, b) ->
            a + b
          total = total + totalQuantity

        if total isnt rule.qty
#          console.log "NO VALIDA - QUANTITY"
#          console.log "rule qty: " + rule.qty
#          console.log "current qty: " + total

          response.details.push {rule:rule,cause:"quantity",qty:total}
          response.success = false

          isValid = false
          return
        ############################filter by quantity############################

      return response

    PromoTypeQuantity::validateRule = (ruleId) ->
      _rules = _.filter @rules, (elem) ->
        elem.id is ruleId

      if _rules.length is 0
        return {success:false,details:[]}

      @validate createRulesArray {rules:_rules,price:0}

  PromoTypeQuantity::isEditable = () ->
    false

  return PromoTypeQuantity