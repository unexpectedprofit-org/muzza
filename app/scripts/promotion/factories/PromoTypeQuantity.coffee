angular.module('Muzza.promo').factory 'PromoTypeQuantity', (PromotionUtil) ->


  class PromoTypeQuantity
    constructor: (from) ->
      @rules = createRulesArray from
      @details =
        id: from.id
        price: from.price
        description:
          short: from.description
          long: from.details

    createRulesArray = (object) ->
      rules = []

      if angular.isUndefined( object.rules ) or
          !(object.rules instanceof Array) or
          object.rules.length < 1 or
          angular.isUndefined ( object.price )
#        console.log "ERROR - NO RULES DEFINED - WHOLE OBJECT"
        return []

      angular.forEach object.rules, (currentRule) ->
        tempRule =
          id: generateRuleId currentRule.properties
          qty: currentRule.qty
          properties: angular.copy currentRule.properties

        rules.push tempRule

      return rules

    generateRuleId = (ruleProperties) ->

      _temp = "rule:" + ruleProperties.cat

      keys = _.keys ruleProperties

      unless keys.length <= 1
        _.forEach keys, (key) ->
          unless key is "cat"
            _temp += "|" + ruleProperties[key]

      _temp



    getQuantityFromCart = (shoppingCart) ->
      quantitiesArray = _.pluck shoppingCart, 'qty'
      totalQuantity = _.reduce quantitiesArray, (a, b) ->
        a + b
      totalQuantity



    PromoTypeQuantity::validate = (otherRules) ->
      rulesToValidate = @rules
      components = @components

      if angular.isDefined( otherRules )
        rulesToValidate = otherRules

      #      console.log "usando rules: " + JSON.stringify rulesToValidate
      #      console.log "components: " + JSON.stringify @components

      validationResponse =
        success: rulesToValidate.length > 0

      _.forEach rulesToValidate, (rule) ->
          if !validationResponse.success then return
          #so that it does not do any logic over next elements since it's already NOT valid
          validationResponse = validateComponents components, rule

      validationResponse


    validateComponents = (components, rule) ->
      acumProd = []
      response =
        details: []
        success: true

      _.forEach components[rule.properties.cat], (subCat) ->

        prodMatching = _.filter subCat.products, (product) ->
          PromotionUtil.productMatchesRule product, rule.properties

        _.forEach prodMatching, (pro) ->
          acumProd.push pro


      if acumProd.length > 0
        quantitiesArray = _.pluck acumProd, 'qty'
        totalQuantity = _.reduce quantitiesArray, (a, b) ->
          a + b

        if totalQuantity isnt rule.qty
#          console.log "NO VALIDA - QUANTITY"
          response.details.push {rule:rule,cause:"NO_QTY_MATCHED",qtyDiff:totalQuantity}
          response.success = false
          return response

      else
#        console.log "NO VALIDA - no prod matching all props"
        response.details.push {rule:rule,cause:"NO_PROD_MATCHED"}
        response.success = false
        return response

      return response



    PromoTypeQuantity::validateRule = (ruleId) ->

      _rules = _.filter @rules, (elem) ->
        elem.id is ruleId

      if _rules.length is 0
#        console.log "not found"
        return {success:false,details:[]}

      @validate _rules

  return PromoTypeQuantity