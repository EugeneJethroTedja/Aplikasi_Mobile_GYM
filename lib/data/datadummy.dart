class Datadum{
  final String name;
  final String phone;
  final String picture;
  const Datadum(this.name, this.phone, this.picture);
}

final List<Datadum> datadummy =
  _peopledata.map((e) => Datadum(e['name'] as String, e['phone'] as String, e['picture'] as String)).toList(growable: false);

final List<Map<String,Object>> _peopledata =
[
  {
    "_id": "66fd047979cb98ffe53d4fb9",
    "index": 0,
    "guid": "476385df-bef6-4ea6-800a-740261710499",
    "isActive": true,
    "balance": "\$3,802.08",
    "picture": "http://placehold.it/32x32",
    "age": 21,
    "eyeColor": "blue",
    "name": "Didit Kredit",
    "gender": "male",
    "company": "EGYPTO",
    "email": "vaughnwilkinson@egypto.com",
    "phone": "+1 (807) 583-3638",
    "address": "176 Fleet Street, Hobucken, Maryland, 4661",
    "about": "Cillum velit labore Lorem minim voluptate ea. Amet exercitation ex deserunt adipisicing voluptate laboris. Dolor aliquip esse exercitation ex ipsum aliquip consectetur anim tempor duis consequat cupidatat. Magna enim incididunt reprehenderit dolore magna id. Qui nisi ad occaecat labore. Reprehenderit qui nisi in mollit reprehenderit minim et. Sunt aliqua amet irure irure do mollit mollit voluptate tempor quis.\r\n",
    "registered": "2019-01-22T05:46:28 -07:00",
    "latitude": 10.61331,
    "longitude": -176.394771,
    "tags": [
      "aute",
      "deserunt",
      "quis",
      "consequat",
      "eu",
      "enim",
      "est"
    ],
    "friends": [
      {
        "id": 0,
        "name": "Farley Sharpe"
      },
      {
        "id": 1,
        "name": "Dickson Holt"
      },
      {
        "id": 2,
        "name": "Alice Velasquez"
      }
    ],
    "greeting": "Hello, Vaughn Wilkinson! You have 1 unread messages.",
    "favoriteFruit": "banana"
  },
  {
    "_id": "66fd0479b940245ac36292c1",
    "index": 1,
    "guid": "f3c45a0f-335d-4d31-8a11-6c146eb52133",
    "isActive": true,
    "balance": "\$1,948.71",
    "picture": "http://placehold.it/32x32",
    "age": 29,
    "eyeColor": "blue",
    "name": "Bacil Kill",
    "gender": "male",
    "company": "ENERVATE",
    "email": "ellismaxwell@enervate.com",
    "phone": "+1 (869) 516-3813",
    "address": "257 Melba Court, Chautauqua, Nevada, 276",
    "about": "Lorem eu sint pariatur amet voluptate do sunt eiusmod exercitation cupidatat cillum. Deserunt deserunt culpa velit occaecat mollit laboris cupidatat cupidatat cillum. Dolor sunt Lorem minim sint ex consectetur. Anim esse sunt excepteur pariatur commodo cupidatat nisi reprehenderit velit mollit et Lorem. Nulla esse voluptate laborum laboris aliqua quis consequat anim magna cupidatat dolore ex fugiat nostrud. Voluptate in esse excepteur do duis ullamco laboris minim non irure ullamco sit pariatur.\r\n",
    "registered": "2023-07-29T11:46:54 -07:00",
    "latitude": -79.541743,
    "longitude": 83.149481,
    "tags": [
      "consectetur",
      "tempor",
      "qui",
      "mollit",
      "sit",
      "laboris",
      "proident"
    ],
    "friends": [
      {
        "id": 0,
        "name": "Karina Robertson"
      },
      {
        "id": 1,
        "name": "Baldwin Frost"
      },
      {
        "id": 2,
        "name": "Peck Lambert"
      }
    ],
    "greeting": "Hello, Ellis Maxwell! You have 4 unread messages.",
    "favoriteFruit": "banana"
  },
  {
    "_id": "66fd0479ec699cb22c6e1125",
    "index": 2,
    "guid": "7276e507-8d62-4332-ab1a-21400bb4f4b3",
    "isActive": false,
    "balance": "\$1,844.72",
    "picture": "http://placehold.it/32x32",
    "age": 24,
    "eyeColor": "brown",
    "name": "Ryan Bledug",
    "gender": "male",
    "company": "TALKALOT",
    "email": "gibsonfrank@talkalot.com",
    "phone": "+1 (854) 443-2634",
    "address": "331 Moore Street, Clara, Texas, 387",
    "about": "Occaecat dolore dolore officia qui minim deserunt fugiat elit culpa ea quis eiusmod amet. Consectetur deserunt reprehenderit nostrud occaecat est non cupidatat mollit. Officia proident consectetur tempor qui laborum sint anim eiusmod fugiat duis cupidatat fugiat sint. Incididunt cupidatat deserunt sint ad. Ad non incididunt ut aute in fugiat sit commodo in. Laboris nisi cillum tempor anim reprehenderit ut occaecat cupidatat velit aliqua.\r\n",
    "registered": "2017-03-04T09:44:49 -07:00",
    "latitude": -75.652687,
    "longitude": 173.460373,
    "tags": [
      "magna",
      "Lorem",
      "veniam",
      "est",
      "et",
      "minim",
      "magna"
    ],
    "friends": [
      {
        "id": 0,
        "name": "Summer Wood"
      },
      {
        "id": 1,
        "name": "Maura Riddle"
      },
      {
        "id": 2,
        "name": "Garza Bradshaw"
      }
    ],
    "greeting": "Hello, Gibson Frank! You have 8 unread messages.",
    "favoriteFruit": "strawberry"
  },
  {
    "_id": "66fd0479bc9e09a1116f5424",
    "index": 3,
    "guid": "57ff1ea1-c1de-4597-bd85-0daee02e841b",
    "isActive": true,
    "balance": "\$2,734.08",
    "picture": "http://placehold.it/32x32",
    "age": 28,
    "eyeColor": "blue",
    "name": "Arix Tekor",
    "gender": "female",
    "company": "CALLFLEX",
    "email": "estellasanford@callflex.com",
    "phone": "+1 (829) 503-3101",
    "address": "924 Holly Street, Carlton, Montana, 344",
    "about": "Velit consequat anim ut esse culpa labore nisi dolore anim. Eu consequat nostrud ad id aute amet consequat laboris officia nisi do officia. Irure do deserunt exercitation non ad. Consectetur consequat laboris occaecat consectetur ut enim enim id duis enim. Lorem exercitation eu consequat pariatur amet in aute tempor sit mollit. Qui fugiat officia nostrud aliquip esse qui.\r\n",
    "registered": "2014-05-28T02:45:14 -07:00",
    "latitude": -28.141618,
    "longitude": -57.566599,
    "tags": [
      "aliquip",
      "ullamco",
      "minim",
      "cupidatat",
      "ex",
      "laborum",
      "enim"
    ],
    "friends": [
      {
        "id": 0,
        "name": "Wood Mathews"
      },
      {
        "id": 1,
        "name": "James Gibbs"
      },
      {
        "id": 2,
        "name": "Marjorie Lester"
      }
    ],
    "greeting": "Hello, Estella Sanford! You have 3 unread messages.",
    "favoriteFruit": "banana"
  },
  {
    "_id": "66fd0479da8fbd7aa0fb6ee5",
    "index": 4,
    "guid": "e202b091-1188-4e77-b6be-0ff2c53620e8",
    "isActive": false,
    "balance": "\$1,318.84",
    "picture": "http://placehold.it/32x32",
    "age": 21,
    "eyeColor": "green",
    "name": "Saripan Saripoh",
    "gender": "female",
    "company": "IMKAN",
    "email": "meghanlarson@imkan.com",
    "phone": "+1 (975) 571-3432",
    "address": "857 Forbell Street, Whitewater, Kentucky, 5506",
    "about": "Commodo minim qui exercitation dolor quis pariatur nulla qui cillum tempor voluptate ipsum. Ea consectetur consectetur qui nostrud enim dolor est nisi consequat id cupidatat qui nostrud. Cillum deserunt mollit irure excepteur commodo veniam id et sint anim cupidatat.\r\n",
    "registered": "2019-08-06T07:29:27 -07:00",
    "latitude": 30.896537,
    "longitude": 63.874963,
    "tags": [
      "cupidatat",
      "nostrud",
      "minim",
      "laborum",
      "ut",
      "minim",
      "reprehenderit"
    ],
    "friends": [
      {
        "id": 0,
        "name": "Bowers Mccormick"
      },
      {
        "id": 1,
        "name": "Nguyen Decker"
      },
      {
        "id": 2,
        "name": "Vilma Mercer"
      }
    ],
    "greeting": "Hello, Meghan Larson! You have 5 unread messages.",
    "favoriteFruit": "strawberry"
  },
  {
    "_id": "66fd0479545378c518454563",
    "index": 5,
    "guid": "7d719f15-52a8-465c-860d-d06b266663f1",
    "isActive": true,
    "balance": "\$3,036.75",
    "picture": "http://placehold.it/32x32",
    "age": 23,
    "eyeColor": "blue",
    "name": "Iwan Bopeng",
    "gender": "female",
    "company": "ZINCA",
    "email": "susieedwards@zinca.com",
    "phone": "+1 (935) 485-2369",
    "address": "299 Perry Terrace, Leland, Arkansas, 2015",
    "about": "Dolore irure cupidatat commodo magna eu laboris Lorem incididunt minim dolore cillum incididunt. Labore eiusmod nostrud commodo cupidatat proident ea amet excepteur do. Eiusmod irure commodo magna incididunt quis adipisicing voluptate. Consequat ad incididunt in id id laborum incididunt sint qui sunt qui qui dolore. Dolore incididunt nostrud enim quis aliqua consequat.\r\n",
    "registered": "2016-04-12T12:05:11 -07:00",
    "latitude": 82.541011,
    "longitude": -91.710435,
    "tags": [
      "pariatur",
      "nulla",
      "cillum",
      "non",
      "incididunt",
      "proident",
      "ut"
    ],
    "friends": [
      {
        "id": 0,
        "name": "June George"
      },
      {
        "id": 1,
        "name": "Maritza Browning"
      },
      {
        "id": 2,
        "name": "Flowers Santiago"
      }
    ],
    "greeting": "Hello, Susie Edwards! You have 7 unread messages.",
    "favoriteFruit": "banana"
  },
  {
    "_id": "66fd04799d764668e1343475",
    "index": 6,
    "guid": "94ccad53-583d-4dfc-a133-af85aac63539",
    "isActive": true,
    "balance": "\$2,528.55",
    "picture": "http://placehold.it/32x32",
    "age": 35,
    "eyeColor": "blue",
    "name": "Djanc Rikocloks",
    "gender": "female",
    "company": "SULFAX",
    "email": "colettecasey@sulfax.com",
    "phone": "+1 (975) 445-2683",
    "address": "817 Adler Place, Fruitdale, American Samoa, 3904",
    "about": "Pariatur proident aliquip irure eiusmod. Duis laborum ut est incididunt irure sit nulla elit. Consectetur quis voluptate laborum adipisicing eu sint aliquip dolor.\r\n",
    "registered": "2016-02-14T11:15:00 -07:00",
    "latitude": -39.811744,
    "longitude": 30.003013,
    "tags": [
      "irure",
      "enim",
      "pariatur",
      "ut",
      "sunt",
      "aliquip",
      "incididunt"
    ],
    "friends": [
      {
        "id": 0,
        "name": "Winters Tran"
      },
      {
        "id": 1,
        "name": "Jodie Francis"
      },
      {
        "id": 2,
        "name": "Leann Lowe"
      }
    ],
    "greeting": "Hello, Colette Casey! You have 4 unread messages.",
    "favoriteFruit": "strawberry"
  }
];