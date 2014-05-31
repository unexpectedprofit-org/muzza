angular.module('Muzza.constants',[]).constant 'stores',

  store1:
    products:
      "empanada": [
        "id": 1,
        description: "Al Horno"
        "products": [
          "id": 1
          "desc": "Carne cortada a cuchillo"
          "toppings": "Carne / Huevo / Morron"
          "price":
            base:1800
        ,
          "id": 2
          "desc": "Calabresa"
          "toppings": "Muzzarella / Longaniza / Salsa"
          "price":
            base: 1800
        ,
          "id": 3
          "desc": "Cebolla y queso"
          "toppings": "Muzzarella / Cebolla"
          "price":
            base: 1800
        ,
          "id": 4
          "desc": "Pollo"
          "toppings": "Pollo / Cebolla"
          "price":
            base: 1800
        ,
          "id": 5
          "desc": "Carne picante"
          "toppings": "Carne / Cebolla"
          "price":
            base: 1800
        ,
          "id": 6
          "desc": "Verdura"
          "toppings": "Espinaca / Huevo / Salsa Blanca"
          "price":
            base: 1800
        ]
      ,
        "id": 2,
        description: "Fritas",
        "products": [
          "id": 7
          "desc": "Cebolla y queso"
          "toppings": "Muzzarella / Cebolla"
          "price":
            base: 1800
        ,
          "id": 8
          "desc": "Pollo"
          "toppings": "Pollo / Cebolla"
          "price":
            base: 2000
        ,
          "id": 9
          "desc": "Verdura"
          "toppings": "Espinaca / Huevo / Salsa Blanca"
          "price":
            base: 2000
        ]
      ],
      "pizza": [
        "id": 1
        "description": "Pizzas Especiales"
        "products": [
          "id": 90
          "desc": "Muzzarella"
          "toppings": "Muzzarella / Salsa tomate / Aceitunas"
          "price":
            base: 5000
            size:
              individual: 0
              chica: 1000
              grande: 2000
            dough:
              "a la piedra": 2
              "al molde": 3
        ,
          "id": 91
          "desc": "Fuggazetta"
          "toppings": "Muzzarella / Cebollas"
          "price":
            base: 5500
            size:
              individual: 0
              chica: 1500
              grande: 2000
            dough:
              "a la piedra": 0
              "al molde": 0
        ,
          "id": 92
          "desc": "Jamon y Morrones"
          "toppings": "Muzzarella / Jamon / Morron"
          "price":
            base: 7500
            size:
              individual: 0
              chica: 1000
              grande: 1500
            dough:
              "a la piedra": 0
              "al molde": 0
        ,
          "id": 93
          "desc": "Calabresa"
          "toppings": "Muzzarella / Longaniza / Salsa"
          "price":
            base: 5000
            size:
              individual: 0
              chica: 1000
              grande: 2000
            dough:
              "a la piedra": 0
              "al molde": 0
        ]
      ,
        "id": 2
        "description": "Pizzas de la Casa"
        "products": [
          "id": 94
          "desc": "Muzzarella con tomate al natural y aceitunas"
          "toppings": "Muzzarella / tomate / Aceitunas"
          "price":
            base: 8000
            size:
              individual: 0
              chica: 1000
              grande: 2000
            dough:
              "a la piedra": 2
              "al molde": 3
        ,
          "id": 95
          "desc": "Espinaca con salsa blanca o muzzarella"
          "toppings": "Espinaca / muzzarella"
          "price":
            base: 7500
            size:
              individual: 0
              chica: 1500
              grande: 2000
            dough:
              "a la piedra": 0
              "al molde": 0
        ]
      ]
      "promotion": [
        id: 1
        desc: "1 docena de empanadas"
        cat: 1 #PromoTypeQuantity
        rules: [
          cat: 'EMPANADA'
          qty: 12
          subcat: '|||'
        ]
        price: 5000
        details: "Llevando una docena de empanadas de cualquier gusto te ahorras una bocha. Aprovechala!!!!!"
      ,
        id: 2
        desc: "1 pizza grande + 6 empanadas al horno"
        cat: 1 #PromoTypeQuantity
        rules: [
          cat: 'EMPANADA'
          qty: 6
          subcat: '|HORNO||'
        ,
          cat: 'PIZZA'
          qty: 1
          subcat: '||GRANDE|'
        ]
        price: 10000
        details: "Llevando media docena de empanadas al horno de cualquier gusto y 1 pizza grande te ahorras una bocha. Aprovechala!!!!!"
      ,
        id: 3
        desc: "6 empanadas fritas + 1 pizza al molde"
        cat: 1 #PromoTypeQuantity
        rules: [
          cat: 'EMPANADA'
          qty: 6
          subcat: '|FRITA||'
        ,
          cat: 'PIZZA'
          qty: 1
          subcat: '|||MOLDE'
        ]
        price:8000
        details: "Llevando una docena de empanadas de empanadas fritas cualquier gusto mas 1 pizza al molde te ahorras una bocha. Aprovechala!!!!!"
      ]