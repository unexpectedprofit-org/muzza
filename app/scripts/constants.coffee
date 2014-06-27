angular.module('Muzza.constants',[]).constant 'stores',

  store1:
    products: [
      id:1
      description: "Bebidas"
      products: [
        id:1
        description: "Aquarius 500 cc"
        price:
          base: 2000
        options: [
          description: "Sabor"
          config:
            component: "ONE_OPTION"
          items: [
            description: "Naranja"
            price: 0
          ,
            description: "Pomelo"
            price: 0
          ,
            description: "Manzana"
            price: 0
          ]
        ]
      ,
        id:2
        description: "Agua mineral"
        price:
          base:1500
        options: [
          description: "Gas"
          config:
            component: "ONE_OPTION"
          items: [
            description: "Con gas"
            price: 50
          ,
            description: "Sin gas"
            price: 0
          ]
        ]
      ,
        id:3
        description: "Cerveza de litro"
        price:
          base:3500
        options: [
          description: "Sabor"
          config:
            component: "ONE_OPTION"
          items: [
            description: "Quilmes"
            price: 10
          ,
            description: "Heineken"
            price: 20
          ,
            description: "Stella"
            price: 0
          ]
        ]
      ]
    ,
      id:2
      description: "Pastas caseras"
      products: [
        id:1
        description: "Ravioles Gran Caruso"
        price:
          base:5000
        options: [
          description: "Salsa"
          config:
            component: "ONE_OPTION"
          items: [
            description: "Blanca"
            price: 0
          ,
            description: "Rosa"
            price: 0
          ,
            description: "Crema"
            price: 0
          ]
        ]
      ,
        id:2
        description: "Sorrentinos"
        price:
          base:8500
        options: [
          description: "Salsa"
          config:
            component: "ONE_OPTION"
          items: [
            description: "Bolognesa"
            price: 0
          ,
            description: "Rosa"
            price: 10
          ,
            description: "Crema"
            price: 0
          ,
            description: "Mixta"
            price: 15
          ]
        ,
          description: "Relleno"
          config:
            component: "ONE_OPTION"
          items: [
            description: "Jamon y Queso"
            price: 20
          ,
            description: "Pollo y verdura"
            price: 0
          ]
        ]
      ]
    ,
      id:3
      description:"Ensaladas"
      products: [
        id:1
        description:"Ensalada de la casa"
        price:
          base:8500
        options: [
          description: "Ingredientes"
          config:
            component: "MULTIPLE_OPTION"
            max:3
            min:1
          items: [
            description: "Lechuga"
            price: 30
          ,
            description: "Tomate"
            price: 0
          ,
            description: "Hongos"
            price: 30
          ,
            description: "Zanahoria"
            price: 0
          ]
        ]
      ]
    ,
      id:4
      description:"Sandwiches"
      products: [
        id:1
        description:"SANDWICH CALIENTE DE LOMITO CON PAPAS FRITAS"
        price:
          base:8500
        options: [
          description: "Pan"
          config:
            component: "ONE_OPTION"
          items: [
            description: "Baguette"
            price: 0
          ,
            description: "Frances"
            price: 0
          ,
            description: "Bola salvado"
            price: 30
          ]
        ,
          description: "Adicionales"
          config:
            component: "MULTIPLE_OPTION"
            max:2
            min:1
          items: [
            description: "Huevo Frito"
            price: 40
          ,
            description: "Morrones"
            price: 0
          ,
            description: "Palmitos"
            price: 500
          ,
            description: "Provolone"
            price: 20
          ]
        ]
      ]
    ,
      id:5
      description:"Empanadas"
      products: [
        id:1
        description:"Carne cortada a cuchillo"
        price:
          base:1800
        options: [
          description: "Coccion"
          config:
            component: "ONE_OPTION"
          items: [
            description: "Frita"
            price: 0
          ,
            description: "Horno"
            price: 0
          ]
        ]
      ,
        id:2
        description:"Jamon y queso"
        price:
          base:1800
        options: [
          description: "Coccion"
          config:
            component: "ONE_OPTION"
          items: [
            description: "Frita"
            price: 150
          ,
            description: "Horno"
            price: 0
          ]
        ]
      ,
        id:3
        description:"Pollo loco"
        price:
          base:2000
        options: [
          description: "Coccion"
          config:
            component: "ONE_OPTION"
          items: [
            description: "Frita"
            price: 100
          ,
            description: "Horno"
            price: 0
          ]
        ]
      ,
        id:4
        description:"Espinaca y salsa blanca"
        price:
          base:2400
        options: [
          description: "Coccion"
          config:
            component: "ONE_OPTION"
          items: [
            description: "Frita"
            price: 0
          ,
            description: "Horno"
            price: 200
          ]
        ]
      ]
    ,
      id:6
      description:"Pizzas a la piedra"
      products: [
        id:1
        description:"Muzzarella"
        price:
          base:6700
        options: [
          description: "Tamano"
          config:
            component: "ONE_OPTION"
          items: [
            description: "Porcion"
            price: 0
          ,
            description: "Chica"
            price: 100
          ,
            description: "Mediana"
            price: 150
          ,
            description: "Grande"
            price: 200
          ]
        ,
          description: "Adicionales"
          config:
            component: "MULTIPLE_OPTION"
            min:0
            max:4
          items: [
            description: "Jamon"
            price: 200
          ,
            description: "Aceitunas"
            price: 100
          ,
            description: "Pollo"
            price: 1500
          ,
            description: "Doble muzzarella"
            price: 900
          ]
        ]
      ,
        id:2
        description:"Napolitana"
        price:
          base:6100
        options: [
          description: "Tamano"
          config:
            component: "ONE_OPTION"
          items: [
            description: "Porcion"
            price: 0
          ,
            description: "Chica"
            price: 100
          ,
            description: "Mediana"
            price: 200
          ,
            description: "Grande"
            price: 350
          ]
        ]
      ,
        id:3
        description:"Espinaca y verdura"
        price:
          base:8500
        options: [
          description: "Tamano"
          config:
            component: "ONE_OPTION"
          items: [
            description: "Mediana"
            price: 0
          ,
            description: "Grande"
            price: 300
          ]
        ]
      ]
    ,
      id:7
      description:"Pizzas al molde"
      products: [
        id:1
        description:"Fugazzetta rellena"
        price:
          base:10000
        options: [
          description: "Tamano"
          config:
            component: "ONE_OPTION"
          items: [
            description: "Chica"
            price: 0
          ,
            description: "Grande"
            price: 500
          ]
        ]
      ,
        id:2
        description:"Calabreza"
        price:
          base:7200
        options: [
          description: "Tamano"
          config:
            component: "ONE_OPTION"
          items: [
            description: "Porcion"
            price: 0
          ,
            description: "Grande"
            price: 500
          ]
        ]
      ]
    ]



angular.module('Muzza.constants').constant 'days',

  names: {
    0: "Domingo"
    1: "Lunes"
    2: "Martes"
    3: "Miercoles"
    4: "Jueves"
    5: "Viernes"
    6: "Sabado"
  }