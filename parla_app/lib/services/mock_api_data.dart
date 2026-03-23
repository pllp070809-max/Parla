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
    imageKey: 'salon1',
    latitude: 37.96,
    longitude: 58.33,
    services: [
      Service(id: 1, name: 'Saç kesim', durationMinutes: 30, price: 350),
      Service(id: 2, name: 'Saç boýamak', durationMinutes: 60, price: 900),
      Service(id: 3, name: 'Sakal kesim', durationMinutes: 25, price: 250),
    ],
  ),
  Salon(
    id: 2,
    name: 'Fresha Beauty Studio',
    address: 'Aşgabat, Arkadag ýol',
    category: 'Makeup',
    imageKey: 'salon2',
    latitude: 37.98,
    longitude: 58.28,
    services: [
      Service(id: 4, name: 'Manikür', durationMinutes: 45, price: 550),
      Service(id: 5, name: 'Gel lak', durationMinutes: 60, price: 850),
      Service(id: 6, name: 'Make-up', durationMinutes: 50, price: 1000),
    ],
  ),
  Salon(
    id: 3,
    name: 'Green Nails & Hair',
    address: 'Türkmenabat, şäher',
    category: 'Pedicure',
    imageKey: 'salon3',
    latitude: 39.12,
    longitude: 63.57,
    services: [
      Service(id: 7, name: 'Pedikür', durationMinutes: 40, price: 600),
      Service(id: 8, name: 'Saç stil', durationMinutes: 35, price: 420),
      Service(id: 9, name: 'Nail art', durationMinutes: 25, price: 300),
    ],
  ),
  Salon(
    id: 4,
    name: 'Royal Barber House',
    address: 'Balkan, bazar',
    category: 'Hair',
    imageKey: 'salon1',
    latitude: 40.0,
    longitude: 52.0,
    services: [
      Service(id: 10, name: 'Barber kesim', durationMinutes: 30, price: 380),
      Service(id: 11, name: 'Saç kesim deluxe', durationMinutes: 45, price: 520),
      Service(id: 12, name: 'Sakal bejergi', durationMinutes: 30, price: 290),
    ],
  ),
  Salon(
    id: 5,
    name: 'Aqua Spa & Beauty',
    address: 'Mary, seýil',
    category: 'Makeup',
    imageKey: 'salon2',
    latitude: 37.09,
    longitude: 61.84,
    services: [
      Service(id: 13, name: 'Make-up + saç', durationMinutes: 75, price: 1400),
      Service(id: 14, name: 'Manikür + spa', durationMinutes: 55, price: 980),
      Service(id: 15, name: 'Pedikür + spa', durationMinutes: 55, price: 990),
    ],
  ),
];

Salon mockSalonById(int id) {
  return kMockSalons.firstWhere((s) => s.id == id, orElse: () => kMockSalons.first);
}

