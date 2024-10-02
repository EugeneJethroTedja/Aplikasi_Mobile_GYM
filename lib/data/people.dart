//* 1. Kelas Person
class Person{
  final String name;
  final String phone;
  final String picture;
  const Person(this.name,this.phone,this.picture);
}

//*2. Variabel list dengan nama people yang memiliki data bertipe object Person, yang merupakan
//* hasil mapping data list pada baris 14 kebawah
final List<Person> people = 
      _people.map((e) => Person(e['name'] as String, e['phone'] as String,e['picture'] as String)).toList(growable: false);

final List<Map<String,Object>> _people = 
  [
    {
      "_id": "66fbe472ed0b1fdf628ce1a3",
      "index": 0,
      "guid": "e73a9527-3229-4ef0-95bb-a9cff2b71581",
      "isActive": true,
      "balance": "1,474.43",
      "picture": "http://placehold.it/32x32",
      "age": 25,
      "eyeColor": "green",
      "name": "Buchanan Fletcher",
      "gender": "male",
      "company": "ASSISTIX",
      "email": "buchananfletcher@assistix.com",
      "phone": "+1 (817) 502-3948",
      "address": "386 Farragut Road, Harleigh, Colorado, 1784",
      "about": "Labore dolore excepteur exercitation eiusmod eu officia consectetur. Tempor quis anim quis magna ex sint magna aliquip. Cupidatat ut consequat labore eiusmod id ad ut adipisicing culpa culpa. Deserunt enim deserunt duis laboris amet nulla sit deserunt eu est cupidatat. Minim reprehenderit officia labore sit aliqua magna nostrud veniam. Culpa nulla Lorem do duis occaecat dolor ipsum nostrud. Ipsum duis excepteur tempor laborum mollit elit sint.\r\n",
      "registered": "2017-02-12T04:48:23 -07:00",
      "latitude": 68.164147,
      "longitude": 110.421627,
      "tags": [
        "adipisicing",
        "aute",
        "mollit",
        "adipisicing",
        "duis",
        "et",
        "pariatur"
      ],
      "friends": [
        {
          "id": 0,
          "name": "Shawn Powers"
        },
        {
          "id": 1,
          "name": "Berta Norman"
        },
        {
          "id": 2,
          "name": "Rena Flynn"
        }
      ],
      "greeting": "Hello, Buchanan Fletcher! You have 9 unread messages.",
      "favoriteFruit": "strawberry"
    },
    {
      "_id": "66fbe4724bb1f55125b2235d",
      "index": 1,
      "guid": "e74f899c-5dd0-4fc2-918d-e3c618c779d9",
      "isActive": false,
      "balance": "2,008.73",
      "picture": "http://placehold.it/32x32",
      "age": 34,
      "eyeColor": "green",
      "name": "Perry Vaughn",
      "gender": "male",
      "company": "GLASSTEP",
      "email": "perryvaughn@glasstep.com",
      "phone": "+1 (986) 458-2454",
      "address": "889 Lenox Road, Cumminsville, Illinois, 1978",
      "about": "Dolor proident fugiat magna irure qui nostrud velit aute nulla velit ex. Mollit amet dolore laboris ea. Et sint magna incididunt commodo consectetur consectetur. Ad culpa consectetur mollit nisi irure deserunt culpa pariatur. Qui mollit ut aliquip magna qui laborum proident qui aliquip incididunt cupidatat. Ea Lorem consectetur adipisicing ea occaecat quis voluptate non pariatur cillum labore. Amet consectetur adipisicing adipisicing mollit ipsum ad dolor labore voluptate consectetur Lorem ullamco eu.\r\n",
      "registered": "2014-01-29T08:20:26 -07:00",
      "latitude": 65.856536,
      "longitude": 114.759232,
      "tags": [
        "magna",
        "ut",
        "duis",
        "aliquip",
        "anim",
        "amet",
        "laboris"
      ],
      "friends": [
        {
          "id": 0,
          "name": "Butler Shields"
        },
        {
          "id": 1,
          "name": "Snow Hurley"
        },
        {
          "id": 2,
          "name": "Parks Medina"
        }
      ],
      "greeting": "Hello, Perry Vaughn! You have 7 unread messages.",
      "favoriteFruit": "apple"
    },
    {
      "_id": "66fbe4726e2a2d235f2ed4bb",
      "index": 2,
      "guid": "6a913fed-a3d2-4f44-980a-c711f5f2533e",
      "isActive": true,
      "balance": "3,806.38",
      "picture": "http://placehold.it/32x32",
      "age": 20,
      "eyeColor": "green",
      "name": "Little Hayden",
      "gender": "male",
      "company": "STRALUM",
      "email": "littlehayden@stralum.com",
      "phone": "+1 (910) 525-2200",
      "address": "202 Bridgewater Street, Sanders, Kentucky, 507",
      "about": "Nulla sit laboris laborum dolor incididunt in ipsum deserunt ea elit enim enim. In pariatur labore cillum excepteur excepteur elit excepteur ipsum pariatur. Aliquip enim do adipisicing veniam qui est elit occaecat. Excepteur incididunt duis minim aute excepteur laborum adipisicing. Ad deserunt sunt tempor sint quis.\r\n",
      "registered": "2023-02-05T09:59:54 -07:00",
      "latitude": 67.395862,
      "longitude": 12.720818,
      "tags": [
        "cupidatat",
        "tempor",
        "reprehenderit",
        "cupidatat",
        "nostrud",
        "ullamco",
        "irure"
      ],
      "friends": [
        {
          "id": 0,
          "name": "Cleo Lambert"
        },
        {
          "id": 1,
          "name": "Pauline Farmer"
        },
        {
          "id": 2,
          "name": "Roxie Murray"
        }
      ],
      "greeting": "Hello, Little Hayden! You have 8 unread messages.",
      "favoriteFruit": "apple"
    },
    {
      "_id": "66fbe4723496a65c3467b81f",
      "index": 3,
      "guid": "e9c01631-b6f4-4e0f-953b-6b3ed733bd87",
      "isActive": true,
      "balance": "3,554.07",
      "picture": "http://placehold.it/32x32",
      "age": 28,
      "eyeColor": "green",
      "name": "Margery Harper",
      "gender": "female",
      "company": "PROXSOFT",
      "email": "margeryharper@proxsoft.com",
      "phone": "+1 (984) 407-3749",
      "address": "992 Rutland Road, Osage, Virgin Islands, 4800",
      "about": "Sint pariatur nisi ea cupidatat eiusmod deserunt laborum consequat eiusmod laborum est eiusmod nostrud. Deserunt culpa adipisicing qui eu proident sint minim elit excepteur eiusmod enim est. Aute laboris sint officia occaecat ullamco minim. Cupidatat Lorem ex voluptate mollit ea elit minim cillum.\r\n",
      "registered": "2017-05-15T10:23:27 -07:00",
      "latitude": 35.019586,
      "longitude": 138.871566,
      "tags": [
        "id",
        "Lorem",
        "cupidatat",
        "tempor",
        "esse",
        "est",
        "quis"
      ],
      "friends": [
        {
          "id": 0,
          "name": "Sullivan Richard"
        },
        {
          "id": 1,
          "name": "Spencer Hewitt"
        },
        {
          "id": 2,
          "name": "Stephanie Maynard"
        }
      ],
      "greeting": "Hello, Margery Harper! You have 8 unread messages.",
      "favoriteFruit": "strawberry"
    },
    {
      "_id": "66fbe472c18b40b4d460e99b",
      "index": 4,
      "guid": "a485e29d-fa65-4ab7-9a38-8ef37ba64d88",
      "isActive": false,
      "balance": "3,118.74",
      "picture": "http://placehold.it/32x32",
      "age": 30,
      "eyeColor": "green",
      "name": "Shields Gay",
      "gender": "male",
      "company": "PLAYCE",
      "email": "shieldsgay@playce.com",
      "phone": "+1 (947) 415-2378",
      "address": "482 Lafayette Walk, Chelsea, Minnesota, 5365",
      "about": "Aute commodo ea veniam ex aliqua occaecat reprehenderit ullamco. Cillum adipisicing proident irure ad et do consequat nostrud voluptate ex commodo amet. Minim ad fugiat do est exercitation quis incididunt et veniam nulla commodo.\r\n",
      "registered": "2015-06-04T05:33:49 -07:00",
      "latitude": 0.832912,
      "longitude": -47.24825,
      "tags": [
        "deserunt",
        "commodo",
        "nisi",
        "cillum",
        "culpa",
        "non",
        "esse"
      ],
      "friends": [
        {
          "id": 0,
          "name": "Frieda Branch"
        },
        {
          "id": 1,
          "name": "Karina Watts"
        },
        {
          "id": 2,
          "name": "Naomi Rosa"
        }
      ],
      "greeting": "Hello, Shields Gay! You have 8 unread messages.",
      "favoriteFruit": "strawberry"
    }
  ];