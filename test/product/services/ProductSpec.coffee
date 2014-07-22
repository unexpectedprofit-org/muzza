describe "Product Service", ->

  beforeEach ->
    module 'Muzza.product'

  ProductService = ProductFileAdapter = undefined

  beforeEach ->
    inject ($injector) ->
      stubJSONResponse = [
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
              min: 1
              max:1
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
              min: 1
              max:1
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
              min: 1
              max:1
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
        ,
          id:4
          description: "Bebida sin opciones"
          price:
            base:10000
        ]
      ,
        id:2
        description: "Pastas caseras"
        products: [
          id:1
          description: "Ravioles di Magro"
          details: "Ravioles rellenos con ricota y espinaca. Mas texto sobre el plato viene aca..."
          price:
            base:5000
          options: [
            description: "Salsa"
            config:
              min: 1
              max:1
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
              min: 1
              max:1
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
              min: 1
              max:1
            items: [
              description: "Jamon y Queso"
              price: 20
            ,
              description: "Pollo y verdura"
              price: 0
            ]
          ]
        ,
          id:3
          description: "Shrimp Scampi Pasta"
          details: "Flavorful shrimp tossed with delicate angel hair pasta in a light blend of olive oil, butter, garlic, lemon juice and Roma tomatoes. Topped with Parmesan cheese, seasoned bread crumbs and parsley."
          price:
            base: 11000
          options: [
            description: "Salsa"
            config:
              min: 1
              max:1
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
              min:1
              max:3
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
              min: 1
              max:1
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
              min:1
              max:2
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
              min: 1
              max:1
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
              min: 1
              max:1
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
              min: 1
              max:1
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
              min: 1
              max:1
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
              min: 1
              max:1
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
              min: 1
              max:1
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
              min: 1
              max:1
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
              min: 1
              max:1
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
              min: 1
              max:1
            items: [
              description: "Porcion"
              price: 0
            ,
              description: "Grande"
              price: 500
            ]
          ]
        ]
      ,
        id:8
        description:"Promos"
        products:[
          id:1
          description:"Aquarius 500 cc + 6 empanadas"
          price:
            base:900
          options:[
            description:"Aquarius 500 cc"
            config:
              min: 1
              max:1
            items: [
              description: "Naranja"
            ,
              description: "Pomelo"
            ,
              description: "Manzana"
            ]
          ,
            description:"Empanadas"
            config:
              min: 6
              max:6
              multipleQty: true
            items: [
              description: "Pollo"
            ,
              description: "Humita"
            ]
          ]
        ,
          id:2
          description:"Pizza grande de muzzarella + 2 Agua mineral"
          price:
            base:7500
          options:[
            description:"Pizza grande de muzza"
            config:
              min: 1
              max:1
            items: [
              description: "La pizza"
            ]
          ,
            description:"Agua mineral"
            config:
              min: 2
              max:2
              multipleQty:true
            items: [
              description: "Con gas"
              price: 100
            ,
              description: "Sin gas"
            ]
          ]
        ,
          id:3
          description:"Cerveza de litro + 2 pizzas medianas"
          price:
            base:8000
          options:[
            description:"Cerveza de litro"
            config:
              min: 1
              max:1
            items: [
              description: "Quilmes"
            ,
              description: "Stella"
              price: 100
            ,
              description: "Heineken"
            ]
          ,
            description:"Pizza mediana"
            config:
              min: 2
              max:2
              multipleQty: true
            items: [
              description: "Muzzarella"
            ,
              description: "Muzzarella con Jamon"
            ]
          ]

        ]
      ]


      ProductService = $injector.get 'ProductService'
      ProductFileAdapter = $injector.get 'ProductFileAdapter'
      spyOn(ProductFileAdapter, 'getMenu').and.returnValue {then: (callback) -> callback(data:stubJSONResponse)}


  it 'should retrieve a list of categories with products and produce an array of models', ->
    menu = ProductService.getMenu undefined, undefined

    expect(menu.length).toBe 8
    expect(menu[0].products.length).toBe 4
    expect(menu[1].products.length).toBe 3
    expect(menu[2].products.length).toBe 1
    expect(menu[3].products.length).toBe 1
    expect(menu[4].products.length).toBe 4
    expect(menu[5].products.length).toBe 3
    expect(menu[6].products.length).toBe 2
    expect(menu[7].products.length).toBe 3


  it 'should return only the array from an specific category', ->
    categoryID = 1
    menu = ProductService.getMenu 1, categoryID

    expect(menu.length).toBe 1
    expect(menu[0].products.length).toBe 4
    expect(menu[0].id).toEqual categoryID