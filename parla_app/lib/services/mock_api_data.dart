import '../models/salon.dart';

/// Serwersiz demo / mock API üçin maglumatlar.
///
/// Maksat: UI-daky ähli “suratlar / hyzmatlar / bronlar” backendsiz işlesin.
/// (ID-ler kesgitli bolmagy üçin şunuň ýaly goýuldy.)
final List<Salon> kMockSalons = [
  Salon(
    id: 1,
    name: 'Indi Salonlary',
    address: 'Aşgabat, merkez',
    category: 'Hair',
    imageKey: 'img1',
    latitude: 37.96,
    longitude: 58.33,
    services: [
      // Saç kesim
      Service(id: 1,  name: 'Aýal saç kesimi',            durationMinutes: 40,  price: 350,  categoryKey: 'haircut'),
      Service(id: 2,  name: 'Erkek saç kesimi',            durationMinutes: 25,  price: 200,  categoryKey: 'haircut'),
      Service(id: 3,  name: 'Çaga saç kesimi',             durationMinutes: 20,  price: 150,  categoryKey: 'haircut'),
      Service(id: 4,  name: 'Gysga saç kesimi (trim)',     durationMinutes: 15,  price: 120,  categoryKey: 'haircut'),
      Service(id: 5,  name: 'Pat / çaý kesim',             durationMinutes: 30,  price: 280,  categoryKey: 'haircut'),
      Service(id: 6,  name: 'Arka we boýun düzediş',       durationMinutes: 15,  price: 100,  categoryKey: 'haircut'),
      // Saç boyamak
      Service(id: 7,  name: 'Doly reňk',                   durationMinutes: 90,  price: 900,  categoryKey: 'color'),
      Service(id: 8,  name: 'Kökleri täzelemek',           durationMinutes: 60,  price: 550,  categoryKey: 'color'),
      Service(id: 9,  name: 'Highlight / balýaj',          durationMinutes: 120, price: 1200, categoryKey: 'color'),
      Service(id: 10, name: 'Ton we glýaz',                durationMinutes: 45,  price: 450,  categoryKey: 'color'),
      Service(id: 11, name: 'Reňk düzediş',               durationMinutes: 150, price: 1800, categoryKey: 'color'),
      Service(id: 12, name: 'Moda / fantasy reňk',        durationMinutes: 120, price: 1500, categoryKey: 'color'),
      // Sakal we erkek
      Service(id: 13, name: 'Sakal düzediş',              durationMinutes: 20,  price: 150,  categoryKey: 'beard'),
      Service(id: 14, name: 'Sakal çyzgy (line-up)',       durationMinutes: 25,  price: 180,  categoryKey: 'beard'),
      Service(id: 15, name: 'Doly sakal çak',             durationMinutes: 35,  price: 250,  categoryKey: 'beard'),
      Service(id: 16, name: 'Ýüz sakalý (dry shave)',     durationMinutes: 30,  price: 220,  categoryKey: 'beard'),
      Service(id: 17, name: 'Erkek saç + sakal kombo',    durationMinutes: 50,  price: 380,  categoryKey: 'beard'),
      // Ustilleme we stil
      Service(id: 18, name: 'Fön we stil',                durationMinutes: 30,  price: 300,  categoryKey: 'styling'),
      Service(id: 19, name: 'Wakil / aýratyn ýagdaý üçin', durationMinutes: 60, price: 700,  categoryKey: 'styling'),
      Service(id: 20, name: 'Saç örüm',                   durationMinutes: 50,  price: 500,  categoryKey: 'styling'),
      Service(id: 21, name: 'Ýygyşyk we öwüşme',         durationMinutes: 45,  price: 420,  categoryKey: 'styling'),
      Service(id: 22, name: 'Proba / synag stil',         durationMinutes: 40,  price: 350,  categoryKey: 'styling'),
      // Bejeriş we täsir
      Service(id: 23, name: 'Çuň bejeriş maskasy',        durationMinutes: 30,  price: 400,  categoryKey: 'treatment'),
      Service(id: 24, name: 'Keratin tekizleme',          durationMinutes: 120, price: 2200, categoryKey: 'treatment'),
      Service(id: 25, name: 'Olaplex / baglanyşyk täsir', durationMinutes: 60,  price: 1100, categoryKey: 'treatment'),
      Service(id: 26, name: 'Nemlilik maskasy',           durationMinutes: 25,  price: 320,  categoryKey: 'treatment'),
      Service(id: 27, name: 'Saç arassalaýyş (detox)',    durationMinutes: 30,  price: 380,  categoryKey: 'treatment'),
    ],
  ),
  Salon(
    id: 2,
    name: 'Fresha Beauty Studio',
    address: 'Aşgabat, Arkadag ýol',
    category: 'Makeup',
    imageKey: 'img2',
    latitude: 37.98,
    longitude: 58.28,
    services: [
      Service(id: 28, name: 'Manikür',  durationMinutes: 45, price: 550,  categoryKey: 'haircut'),
      Service(id: 29, name: 'Gel lak',  durationMinutes: 60, price: 850,  categoryKey: 'treatment'),
      Service(id: 30, name: 'Make-up',  durationMinutes: 50, price: 1000, categoryKey: 'styling'),
    ],
  ),
  Salon(
    id: 3,
    name: 'Green Nails & Hair',
    address: 'Türkmenabat, şäher',
    category: 'Pedicure',
    imageKey: 'img3',
    latitude: 39.12,
    longitude: 63.57,
    services: [
      Service(id: 31, name: 'Pedikür',  durationMinutes: 40, price: 600, categoryKey: 'treatment'),
      Service(id: 32, name: 'Saç stil', durationMinutes: 35, price: 420, categoryKey: 'styling'),
      Service(id: 33, name: 'Nail art', durationMinutes: 25, price: 300, categoryKey: 'treatment'),
    ],
  ),
  Salon(
    id: 4,
    name: 'Royal Barber House',
    address: 'Balkan, bazar',
    category: 'Hair',
    imageKey: 'img4',
    latitude: 40.0,
    longitude: 52.0,
    services: [
      Service(id: 34, name: 'Barber kesim',      durationMinutes: 30, price: 380, categoryKey: 'haircut'),
      Service(id: 35, name: 'Saç kesim deluxe',  durationMinutes: 45, price: 520, categoryKey: 'haircut'),
      Service(id: 36, name: 'Sakal bejergi',     durationMinutes: 30, price: 290, categoryKey: 'beard'),
    ],
  ),
  Salon(
    id: 5,
    name: 'Aqua Spa & Beauty',
    address: 'Mary, seýil',
    category: 'Makeup',
    imageKey: 'img5',
    latitude: 37.09,
    longitude: 61.84,
    services: [
      Service(id: 37, name: 'Make-up + saç', durationMinutes: 75, price: 1400, categoryKey: 'styling'),
      Service(id: 38, name: 'Manikür + spa', durationMinutes: 55, price: 980,  categoryKey: 'treatment'),
      Service(id: 39, name: 'Pedikür + spa', durationMinutes: 55, price: 990,  categoryKey: 'treatment'),
    ],
  ),
];

Salon mockSalonById(int id) {
  return kMockSalons.firstWhere((s) => s.id == id, orElse: () => kMockSalons.first);
}

