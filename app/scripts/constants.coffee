angular.module('Muzza.constants',[]).constant 'stores',

  store1:
    products:
      "empanada": [
        "id": 1,
        "desc": "Al Horno",
        "products": [
          "id": 1
          "desc": "Carne cortada a cuchillo"
          "toppings": "Carne / Huevo / Morron"
          "price": 1800
        ,
          "id": 2
          "desc": "Calabresa"
          "toppings": "Muzzarella / Longaniza / Salsa"
          "price": 1800
        ,
          "id": 3
          "desc": "Cebolla y queso"
          "toppings": "Muzzarella / Cebolla"
          "price": 1800
        ,
          "id": 4
          "desc": "Pollo"
          "toppings": "Pollo / Cebolla"
          "price": 1800
        ,
          "id": 5
          "desc": "Carne picante"
          "toppings": "Carne / Cebolla"
          "price": 1800
        ,
          "id": 6
          "desc": "Verdura"
          "toppings": "Espinaca / Huevo / Salsa Blanca"
          "price": 1800
        ]
      ,
        "id": 2,
        "desc": "Fritas",
        "products": [
          "id": 7
          "desc": "Cebolla y queso"
          "toppings": "Muzzarella / Cebolla"
          "price": 1800
        ,
          "id": 8
          "desc": "Pollo"
          "toppings": "Pollo / Cebolla"
          "price": 2000
        ,
          "id": 9
          "desc": "Verdura"
          "toppings": "Espinaca / Huevo / Salsa Blanca"
          "price": 2000
        ]
      ],
      "pizza": [
        "id": 1
        "desc": "Pizzas Especiales"
        "products": [
          "id": 90
          "desc": "Muzzarella"
          "toppings": [ "Muzzarella", "Salsa tomate", "Aceitunas" ]
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
          "toppings": [ "Muzzarella", "Cebollas" ]
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
          "toppings": [ "Muzzarella", "Jamon", "Morron" ]
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
          "toppings": [ "Muzzarella", "Longaniza", "Salsa" ]
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
        "desc": "Pizzas de la Casa"
        "products": [
          "id": 94
          "desc": "Muzzarella con tomate al natural y aceitunas"
          "toppings": [ "Muzzarella", "tomate", "Aceitunas" ]
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
          "toppings": [ "Espinaca", "muzzarella" ]
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

