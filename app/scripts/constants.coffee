angular.module('Muzza.constants',[]).constant 'stores',

  store1:
    products:
      "empanada": [
        "id": 1,
        description: "Al Horno"
        "products": [
          "id": 1
          description: "Carne cortada a cuchillo"
          "toppings": "Carne / Huevo / Morron"
          "price":
            base:1800
        ,
          "id": 2
          description: "Calabresa"
          "toppings": "Muzzarella / Longaniza / Salsa"
          "price":
            base: 1800
        ,
          "id": 3
          description: "Cebolla y queso"
          "toppings": "Muzzarella / Cebolla"
          "price":
            base: 1800
        ,
          "id": 4
          description: "Pollo"
          "toppings": "Pollo / Cebolla"
          "price":
            base: 1800
        ,
          "id": 5
          description: "Carne picante"
          "toppings": "Carne / Cebolla"
          "price":
            base: 1800
        ,
          "id": 6
          description: "Verdura"
          "toppings": "Espinaca / Huevo / Salsa Blanca"
          "price":
            base: 1800
        ]
      ,
        "id": 2,
        description: "Fritas",
        "products": [
          "id": 7
          description: "Cebolla y queso"
          "toppings": "Muzzarella / Cebolla"
          "price":
            base: 1800
        ,
          "id": 8
          description: "Pollo"
          "toppings": "Pollo / Cebolla"
          "price":
            base: 2000
        ,
          "id": 9
          description: "Verdura"
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
          description: "Muzzarella"
          "toppings": "Muzzarella / Salsa tomate / Aceitunas"
          "price":
            base: 5000
            size:
              porcion: 0
              individual: 500
              chica: 1000
              grande: 2000
            dough:
              "a la piedra": 2
              "al molde": 3
        ,
          "id": 91
          description: "Fuggazetta"
          "toppings": "Muzzarella / Cebollas"
          "price":
            base: 5500
            size:
              porcion: 0
              individual: 500
              chica: 1500
              grande: 2000
            dough:
              "a la piedra": 0
              "al molde": 0
        ,
          "id": 92
          description: "Jamon y Morrones"
          "toppings": "Muzzarella / Jamon / Morron"
          "price":
            base: 7500
            size:
              porcion: 0
              individual: 500
              chica: 1000
              grande: 1500
            dough:
              "a la piedra": 0
              "al molde": 0
        ,
          "id": 93
          description: "Calabresa"
          "toppings": "Muzzarella / Longaniza / Salsa"
          "price":
            base: 5000
            size:
              porcion: 0
              individual: 500
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
          description: "Muzzarella con tomate al natural y aceitunas"
          "toppings": "Muzzarella / tomate / Aceitunas"
          "price":
            base: 8000
            size:
              porcion: 0
              individual: 500
              chica: 1000
              grande: 2000
            dough:
              "a la piedra": 2
              "al molde": 3
        ,
          "id": 95
          description: "Espinaca con salsa blanca o muzzarella"
          "toppings": "Espinaca / muzzarella"
          "price":
            base: 7500
            size:
              porcion: 0
              individual: 500
              chica: 1500
              grande: 2000
            dough:
              "a la piedra": 0
              "al molde": 0
        ]
      ]
      "promotion": [
        id: 1
        description: "1 docena de empanadas"
        cat: 1 #PromoTypeQuantity
        rules: [
          qty: 12
          properties: {
            cat: 'EMPANADA'
          }
        ]
        price: 5000
        details: "Llevando una docena de empanadas de cualquier gusto te ahorras una bocha. Aprovechala!!!!!"
      ,
        id: 2
        description: "1 pizza grande + 6 empanadas al horno"
        cat: 1 #PromoTypeQuantity
        rules: [
          qty: 6
          properties: {
            cat: 'EMPANADA'
            subcat:1
          }
        ,
          qty: 1
          properties: {
            cat: 'PIZZA'
            size: 'grande'
          }
        ]
        price: 10000
        details: "Llevando media docena de empanadas al horno de cualquier gusto y 1 pizza grande te ahorras una bocha. Aprovechala!!!!!"
      ,
        id: 3
        description: "6 empanadas fritas + 1 pizza de la casa grande + 2 empanadas al horno"
        cat: 1 #PromoTypeQuantity
        rules: [
          qty: 6
          properties: {
            cat: 'EMPANADA'
            subcat:2
          }
        ,
          qty: 2
          properties: {
            cat: 'EMPANADA'
            subcat:1
          }
        ,
          qty: 1
          properties: {
            cat: 'PIZZA'
            subcat:2
            size: 'grande'
          }
        ]
        price:8000
        details: "Llevando una docena de empanadas de empanadas fritas cualquier gusto mas 1 pizza al molde te ahorras una bocha. Aprovechala!!!!!"
      ,
        id: 4
        description: "6 empanadas + 1 Gaseosa 600 cc"
        cat: 1 #PromoTypeQuantity
        rules: [
          qty: 6
          properties: {
            cat: 'EMPANADA'
          }
        ,
          qty: 1
          properties: {
            cat: 'BEBIDA'
            subcat:1
          }
        ]
        price: 5000
        details: "Llevando 6 empanadas de cualquier gusto + 1 Gaseosa 600 cc te ahorras una bocha. Aprovechala!!!!!"
      ,
        id: 5
        description: "1 pizza de la casa  + 1 pizza especial"
        cat: 1 #PromoTypeQuantity
        rules: [
          qty: 1
          properties: {
            cat: 'PIZZA'
            subcat:1
          }
        ,
          qty: 1
          properties: {
            cat: 'PIZZA'
            subcat:2
          }
        ]
        price:8000
        details: "Llevando una 1 pizza de la casa grande y 1 pizza especial te ahorras una bocha. Aprovechala!!!!!"
      ,
      ]
      "bebida": [
        id:1
        description:"Gaseosa 600 cc"
        products: [
          id:1
          description:"Coca Cola"
          price:
            base: 1000
        ,
          id:2
          description:"Coca Cola Zero"
          price:
            base: 1000
        ,
          id:3
          description:"Fanta"
          price:
            base: 1000
        ,
          id:4
          description:"Sprite"
          price:
            base: 1000
        ,
          id:5
          description:"Levite Manzana"
          price:
            base: 1100
        ,
          id:6
          description:"Levita Naranja"
          price:
            base: 1100
        ,
          id:7
          description:"Ser Citrus"
          price:
            base: 1150
        ,
          id:8
          description:"Ser Lima"
          price:
            base: 1150
        ]
      ,
        id:2
        description:"Gaseosa 1.5 L"
        products: [
          id:1
          description:"Coca Cola"
          price:
            base: 1000
        ,
          id:2
          description:"Coca Cola Zero"
          price:
            base: 1000
        ,
          id:3
          description:"Sprite"
          price:
            base: 1000
        ]

        id:3
        description:"Cervezas"
        products: [
          id:1
          description:"Cerveza warsteiner 1 L"
          price:
            base: 1200
        ,
          id:2
          description:"Cerveza Isenbeck 1 L"
          price:
            base: 1200
        ,
          id:3
          description:"Cerveza Isenbeck porrón de 355 cc"
          price:
            base: 600
        ,
          id:4
          description:"Cerveza Quilmes 473 cc"
          price:
            base: 800
        ,
          id:5
          description:"Cerveza heinekken 354 cc"
          price:
            base: 9000
        ,
          id:6
          description:"Cerveza Corona"
          price:
            base: 1600
        ]
      ]