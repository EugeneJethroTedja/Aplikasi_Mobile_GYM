class Person {
  final String name;
  final String phone;
  final String picture;
  const Person(this.name, this.phone, this.picture);
}

final List<Person> people = _people
    .map((e) => Person(
        e['name'] as String, e['phone'] as String, e['picture'] as String))
    .toList(growable: false);

final List<Map<String, Object>> _people = [
  {
    "_id": "66fc09a3e0037e034357d492",
    "index": 0,
    "guid": "a302268b-b275-40a4-ba11-0aa495aa0b8f",
    "isActive": false,
    "balance": "\$2,930.99",
    "picture": "http://placehold.it/32x32",
    "age": 38,
    "eyeColor": "brown",
    "name": "Joko Budianto",
    "gender": "male",
    "company": "BLURRYBUS",
    "email": "jokoImut@blurrybus.com",
    "phone": "+1 (916) 456-2919",
    "address": "999 Richardson Street, Wikieup, Pennsylvania, 767",
    "about":
        "Laboris ex anim ad ea ad eiusmod ea do elit qui sit consectetur consectetur incididunt. Do voluptate occaecat reprehenderit sit et ullamco minim elit Lorem amet eiusmod. Consectetur irure duis nulla ad. Enim tempor et sint quis voluptate non velit ullamco sint dolore adipisicing. Laboris quis proident velit consequat aliqua ut culpa aute aliquip aute magna. Lorem excepteur ut dolor ut laborum commodo quis est cupidatat et.\r\n",
    "registered": "2018-09-02T08:31:36 -07:00",
    "latitude": -45.899781,
    "longitude": 75.541258,
    "tags": [
      "cillum",
      "culpa",
      "nostrud",
      "sit",
      "tempor",
      "adipisicing",
      "ut"
    ],
    "friends": [
      {"id": 0, "name": "Martin Roman"},
      {"id": 1, "name": "Frost Chase"},
      {"id": 2, "name": "Hoover Graham"}
    ],
    "greeting": "Hello, Kristy Bush! You have 2 unread messages.",
    "favoriteFruit": "strawberry"
  },
  {
    "_id": "66fc09a325ce676ec16c6852",
    "index": 1,
    "guid": "7ade9bb2-285a-49b7-8889-6b15d1f137c1",
    "isActive": true,
    "balance": "\$1,792.72",
    "picture": "http://placehold.it/32x32",
    "age": 26,
    "eyeColor": "green",
    "name": "Ilham",
    "gender": "male",
    "company": "ZANILLA",
    "email": "arnoldobrien@zanilla.com",
    "phone": "+1 (855) 506-2115",
    "address": "963 Dekalb Avenue, Nutrioso, American Samoa, 7233",
    "about":
        "Consequat incididunt exercitation exercitation irure elit amet minim ipsum laboris irure magna mollit elit cupidatat. Irure fugiat ex labore commodo commodo fugiat. Ad incididunt laborum cupidatat officia anim id eiusmod amet officia et nostrud. In tempor laboris reprehenderit duis fugiat minim sunt. Proident adipisicing anim deserunt nisi. Ad incididunt nisi ullamco irure consequat sunt magna officia ipsum est irure pariatur mollit nisi.\r\n",
    "registered": "2023-12-27T08:32:42 -07:00",
    "latitude": -83.325693,
    "longitude": 11.626471,
    "tags": [
      "et",
      "fugiat",
      "voluptate",
      "aliqua",
      "proident",
      "proident",
      "amet"
    ],
    "friends": [
      {"id": 0, "name": "Maxine Alvarez"},
      {"id": 1, "name": "Mitchell Maldonado"},
      {"id": 2, "name": "Sheena King"}
    ],
    "greeting": "Hello, Arnold Obrien! You have 8 unread messages.",
    "favoriteFruit": "banana"
  },
  {
    "_id": "66fc09a3c1d92cb9c5aefab8",
    "index": 2,
    "guid": "7a8d6d96-341c-4a13-83d8-a75f930db1e6",
    "isActive": false,
    "balance": "\$1,969.71",
    "picture": "http://placehold.it/32x32",
    "age": 24,
    "eyeColor": "green",
    "name": "Arif Ismail",
    "gender": "male",
    "company": "ORBIFLEX",
    "email": "kelleymoon@orbiflex.com",
    "phone": "+1 (860) 472-3989",
    "address": "857 Kingsland Avenue, Homestead, South Dakota, 2208",
    "about":
        "Consequat amet voluptate aute aliqua ullamco nostrud voluptate irure anim sint dolore. Labore veniam laborum cillum magna ea eu aute dolore eu consectetur nostrud commodo laboris. Esse aute ea consectetur cupidatat Lorem. Deserunt excepteur non velit ullamco sunt.\r\n",
    "registered": "2021-08-14T11:52:43 -07:00",
    "latitude": 33.532355,
    "longitude": 66.305181,
    "tags": ["qui", "occaecat", "velit", "qui", "aliqua", "magna", "laborum"],
    "friends": [
      {"id": 0, "name": "Mckee Foster"},
      {"id": 1, "name": "Aline Bird"},
      {"id": 2, "name": "Hyde Reese"}
    ],
    "greeting": "Hello, Kelley Moon! You have 1 unread messages.",
    "favoriteFruit": "apple"
  },
  {
    "_id": "66fc09a3efd122377ad761e4",
    "index": 3,
    "guid": "0b281afd-82f1-4c65-9864-d5706828db2c",
    "isActive": true,
    "balance": "\$2,184.58",
    "picture": "http://placehold.it/32x32",
    "age": 23,
    "eyeColor": "brown",
    "name": "Beatrice Christian",
    "gender": "female",
    "company": "AUSTEX",
    "email": "beatricerusso@austex.com",
    "phone": "+1 (975) 433-2046",
    "address": "322 Eaton Court, Warsaw, Louisiana, 5342",
    "about":
        "Magna non nisi proident ullamco exercitation adipisicing nisi eu eu tempor reprehenderit culpa ex ut. Laboris reprehenderit aliqua pariatur incididunt. Aliquip incididunt enim culpa mollit ullamco eu. Excepteur occaecat ullamco aliqua veniam aliquip nostrud proident anim magna excepteur eu reprehenderit duis ipsum. Eiusmod laboris occaecat nisi eu amet aute et ut exercitation.\r\n",
    "registered": "2014-01-29T10:57:19 -07:00",
    "latitude": 72.756005,
    "longitude": -140.761515,
    "tags": [
      "veniam",
      "culpa",
      "minim",
      "voluptate",
      "esse",
      "proident",
      "ullamco"
    ],
    "friends": [
      {"id": 0, "name": "Jennie Cooper"},
      {"id": 1, "name": "Shelby Kent"},
      {"id": 2, "name": "Ayers Mcdowell"}
    ],
    "greeting": "Hello, Beatrice Russo! You have 3 unread messages.",
    "favoriteFruit": "apple"
  },
  {
    "_id": "66fc09a39e6dee1f57c45f67",
    "index": 4,
    "guid": "b5bbfc5c-ac08-470a-a576-810597f1d45d",
    "isActive": true,
    "balance": "\$2,098.96",
    "picture": "http://placehold.it/32x32",
    "age": 33,
    "eyeColor": "brown",
    "name": "Chandra Gemoy",
    "gender": "female",
    "company": "GOGOL",
    "email": "gwenmccoy@gogol.com",
    "phone": "+1 (907) 514-3574",
    "address": "312 Turner Place, Tampico, Virginia, 4766",
    "about":
        "Voluptate est labore tempor fugiat nulla do minim laboris. Cupidatat enim eiusmod ad magna pariatur elit qui et. Nostrud pariatur non sunt consequat ea eiusmod esse eiusmod irure adipisicing ullamco officia magna amet. Nulla cillum velit ea est anim amet dolor ad exercitation.\r\n",
    "registered": "2024-06-26T02:15:15 -07:00",
    "latitude": 65.627267,
    "longitude": -16.951676,
    "tags": ["nisi", "labore", "proident", "elit", "in", "deserunt", "laboris"],
    "friends": [
      {"id": 0, "name": "Mccarthy Jennings"},
      {"id": 1, "name": "Jessica Ferguson"},
      {"id": 2, "name": "Osborne Jones"}
    ],
    "greeting": "Hello, Gwen Mccoy! You have 2 unread messages.",
    "favoriteFruit": "strawberry"
  },
  {
    "_id": "66fc09a31039b4de266759bc",
    "index": 5,
    "guid": "cc16ba72-489d-45bb-af74-51f827ba5fbe",
    "isActive": false,
    "balance": "\$1,002.77",
    "picture": "http://placehold.it/32x32",
    "age": 39,
    "eyeColor": "brown",
    "name": "Meadows Manning",
    "gender": "male",
    "company": "AUTOGRATE",
    "email": "meadowsmanning@autograte.com",
    "phone": "+1 (866) 536-2505",
    "address": "528 Driggs Avenue, Indio, California, 5798",
    "about":
        "Cillum et nulla voluptate voluptate occaecat amet exercitation in amet ea culpa est qui. Laboris nisi dolor ea adipisicing minim voluptate in qui incididunt reprehenderit dolor. Aliquip deserunt occaecat reprehenderit consequat ullamco id elit ipsum velit fugiat. Mollit est consectetur in veniam aliquip exercitation. Labore id deserunt exercitation culpa adipisicing nulla mollit enim do Lorem laboris est tempor deserunt.\r\n",
    "registered": "2016-10-07T06:06:04 -07:00",
    "latitude": 13.268156,
    "longitude": 125.569484,
    "tags": [
      "aute",
      "laborum",
      "dolor",
      "mollit",
      "commodo",
      "qui",
      "exercitation"
    ],
    "friends": [
      {"id": 0, "name": "Florine Chen"},
      {"id": 1, "name": "Corinne Jordan"},
      {"id": 2, "name": "Chaney Ellison"}
    ],
    "greeting": "Hello, Meadows Manning! You have 5 unread messages.",
    "favoriteFruit": "banana"
  },
  {
    "_id": "66fc09a34af1670f6da7c8dc",
    "index": 6,
    "guid": "e08325b4-c379-48bb-8dd1-0429cd05a685",
    "isActive": true,
    "balance": "\$2,585.28",
    "picture": "http://placehold.it/32x32",
    "age": 26,
    "eyeColor": "green",
    "name": "Ila Bray",
    "gender": "female",
    "company": "REALYSIS",
    "email": "ilabray@realysis.com",
    "phone": "+1 (943) 584-3706",
    "address": "883 Albee Square, Robbins, Nevada, 2500",
    "about":
        "Sint sint non laboris nulla mollit commodo qui nisi cupidatat cupidatat cillum eu laboris. Velit eu duis Lorem enim eu proident labore proident. Ullamco voluptate cillum laboris laborum irure consequat. Eu id sit mollit tempor aliquip sit et.\r\n",
    "registered": "2022-12-22T03:18:53 -07:00",
    "latitude": 38.838087,
    "longitude": 91.66952,
    "tags": [
      "adipisicing",
      "magna",
      "in",
      "incididunt",
      "aliquip",
      "sunt",
      "adipisicing"
    ],
    "friends": [
      {"id": 0, "name": "Allison Goodman"},
      {"id": 1, "name": "Natalia Miranda"},
      {"id": 2, "name": "Ophelia Mcfadden"}
    ],
    "greeting": "Hello, Ila Bray! You have 1 unread messages.",
    "favoriteFruit": "banana"
  }
];
