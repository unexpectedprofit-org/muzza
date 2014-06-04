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
          subcat: '|1||'
        ,
          cat: 'PIZZA'
          qty: 1
          subcat: '||GRANDE|'
        ]
        price: 10000
        details: "Llevando media docena de empanadas al horno de cualquier gusto y 1 pizza grande te ahorras una bocha. Aprovechala!!!!!"
      ,
        id: 3
        desc: "6 empanadas fritas + 1 pizza de la casa + 2 empanadas al horno"
        cat: 1 #PromoTypeQuantity
        rules: [
          cat: 'EMPANADA'
          qty: 6
          subcat: '|2||'
        ,
          cat: 'EMPANADA'
          qty: 2
          subcat: '|1||'
        ,
          cat: 'PIZZA'
          qty: 1
          subcat: '|2||'
        ]
        price:8000
        details: "Llevando una docena de empanadas de empanadas fritas cualquier gusto mas 1 pizza al molde te ahorras una bocha. Aprovechala!!!!!"
      ]
      "bebida": [
        id:1
        description:"Sin Alcohol"
        products: [
          id:1
          desc:"Agua sin gas"
          price:
            base: 1000
            size:
              individual: 0
              chica: 1000
              grande: 2000
          options: []
        ,
          id:2
          desc:"Gaseosa Linea CocaCola"
          price:
            base: 1000
            size:
              individual: 0
              chica: 1000
              grande: 2000
          options: ["Coca","Fanta","Sprite","Coca diet"]
        ,
          id:3
          desc:"Agua saborizada Levite"
          price:
            base: 1500
            size:
              individual: 0
              chica: 1000
              grande: 2000
          options: ["Naranja","Manzana","Pomelo"]
        ,
          id:4
          desc:"Agua saborizada Aquarius"
          price:
            base: 1500
            size:
              individual: 0
              chica: 1000
              grande: 2000
          options: ["Durazno","Pera"]
        ]
      ,
        id:2
        description:"Cervezas"
        products: [
          id:1
          desc:"Heineken"
          price:
            base: 1000
            size:
              individual: -1
              chica: 1000
        ,
          id:2
          desc:"Quilmes"
          price:
            base: 1000
            size:
              individual: 0
              chica: 1000
        ,
          id:3
          desc:"Stella Artois"
          price:
            base: 1000
            size:
              individual: 0
              chica: 1000
        ]
      ]