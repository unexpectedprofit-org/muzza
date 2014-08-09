angular.module('Muzza.store').constant 'branches',

  list: [
    {
      id: 1
      name_real: "Juancho S.R.L."
      name_fantasy: "La pizzeria de Juancho"
      address:
        street: "Av. Alberdi"
        door: 2555
        zip: "1406"
        hood: "Flores"
        area: "Capital Federal"
        state: "Buenos Aires"

      delivery:
        latLong:
          k: -34.591809
          A: -58.3959331

        radio: 2

      phone:
        main: "1111 0000"
        other: "3333 7771"
        cel: "15 9999 2222"

      displayOpenHours:
        Domingo: [
          [
            "06:00"
            "19:00"
          ]
          [
            "19:01"
            "05:59"
          ]
        ]
        Lunes: [
          [
            "06:00"
            "19:00"
          ]
          [
            "19:01"
            "05:59"
          ]
        ]
        Martes: [
          [
            "06:00"
            "19:00"
          ]
          [
            "19:01"
            "05:59"
          ]
        ]
        Miercoles: [
          [
            "06:00"
            "19:00"
          ]
          [
            "19:01"
            "05:59"
          ]
        ]
        Jueves: [
          [
            "06:00"
            "19:00"
          ]
          [
            "19:01"
            "05:59"
          ]
        ]
        Viernes: [
          [
            "06:00"
            "19:00"
          ]
          [
            "19:01"
            "05:59"
          ]
        ]
        Sabado: [
          [
            "06:00"
            "11:00"
          ]
          [
            "16:00"
            "17:00"
          ]
        ]

      order:
        minPrice:
          delivery: 6000
          pickup: 8000
    }
    {
      id: 2
      name_real: "Juancho S.R.L."
      name_fantasy: "La pizzeria de Juancho"
      address:
        street: "Av. Rivadavia"
        door: 5100
        zip: "1406"
        hood: "Caballito"
        area: "Capital Federal"
        state: "Buenos Aires"

      delivery:
        latLong:
          k: -14.591809
          A: -18.3959331

        radio: 1

      phone:
        main: "4444 5555"
        other: "1111 2222"
        cel: "15 4444 9999"

      displayOpenHours:
        Domingo: []
        Lunes: [
          [
            "12:00"
            "14:00"
          ]
          [
            "19:30"
            "03:00"
          ]
        ]
        Martes: [
          [
            "11:30"
            "15:00"
          ]
          [
            "19:30"
            "22:00"
          ]
        ]
        Miercoles: [
          [
            "11:30"
            "15:00"
          ]
          [
            "19:30"
            "22:00"
          ]
        ]
        Jueves: [
          [
            "11:30"
            "15:00"
          ]
          [
            "19:30"
            "01:00"
          ]
        ]
        Viernes: [
          [
            "11:30"
            "15:00"
          ]
          [
            "23:30"
            "02:30"
          ]
        ]
        Sabado: [[
          "18:30"
          "03:00"
        ]]

      order:
        minPrice:
          delivery: 6000
          pickup: 8000
    }
  ]
