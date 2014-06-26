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
          component: "MULTIPLE_OPTION"
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
          component: "MULTIPLE_OPTION"
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