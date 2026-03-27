class Salon {
  final int id;
  final String name;
  final String? address;
  final String? category;
  final String? imageKey;
  final double? latitude;
  final double? longitude;
  final List<Service> services;

  const Salon({
    required this.id,
    required this.name,
    this.address,
    this.category,
    this.imageKey,
    this.latitude,
    this.longitude,
    this.services = const [],
  });

  bool get hasLocation => latitude != null && longitude != null;

  factory Salon.fromJson(Map<String, dynamic> json) => Salon(
        id: json['id'] as int,
        name: json['name'] as String,
        address: json['address'] as String?,
        category: json['category'] as String?,
        imageKey: json['image_key'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        services: (json['services'] as List<dynamic>?)
                ?.map((e) => Service.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class Service {
  final int id;
  final String name;
  final int durationMinutes;
  final double? price;
  final String? categoryKey;

  const Service({
    required this.id,
    required this.name,
    required this.durationMinutes,
    this.price,
    this.categoryKey,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json['id'] as int,
        name: json['name'] as String,
        durationMinutes: json['duration_minutes'] as int,
        price: (json['price'] as num?)?.toDouble(),
        categoryKey: json['category_key'] as String?,
      );
}
