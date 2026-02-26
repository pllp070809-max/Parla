class Salon {
  final int id;
  final String name;
  final String? address;
  final String? category;
  final String? imageKey;
  final List<Service> services;

  const Salon({
    required this.id,
    required this.name,
    this.address,
    this.category,
    this.imageKey,
    this.services = const [],
  });

  factory Salon.fromJson(Map<String, dynamic> json) => Salon(
        id: json['id'] as int,
        name: json['name'] as String,
        address: json['address'] as String?,
        category: json['category'] as String?,
        imageKey: json['image_key'] as String?,
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

  const Service({
    required this.id,
    required this.name,
    required this.durationMinutes,
    this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json['id'] as int,
        name: json['name'] as String,
        durationMinutes: json['duration_minutes'] as int,
        price: (json['price'] as num?)?.toDouble(),
      );
}
