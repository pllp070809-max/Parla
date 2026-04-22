class Booking {
  final int id;
  final int salonId;
  final int serviceId;
  final List<int>? serviceIds;
  final String guestName;
  final String guestPhone;
  final DateTime slotAt;
  final String status;
  final String? salonName;
  final String? serviceName;
  final List<String>? serviceNames;
  final int? totalDurationMinutes;
  final double? totalPrice;

  Booking({
    required this.id,
    required this.salonId,
    required this.serviceId,
    this.serviceIds,
    required this.guestName,
    required this.guestPhone,
    required this.slotAt,
    required this.status,
    this.salonName,
    this.serviceName,
    this.serviceNames,
    this.totalDurationMinutes,
    this.totalPrice,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'] as int,
        salonId: json['salon_id'] as int,
        serviceId: json['service_id'] as int,
        serviceIds: (json['service_ids'] as List?)?.cast<int>(),
        guestName: json['guest_name'] as String,
        guestPhone: json['guest_phone'] as String,
        slotAt: DateTime.parse(json['slot_at'] as String),
        status: json['status'] as String,
        salonName: json['salon_name'] as String?,
        serviceName: json['service_name'] as String?,
        serviceNames: (json['service_names'] as List?)?.cast<String>(),
        totalDurationMinutes: json['total_duration_minutes'] as int?,
        totalPrice: (json['total_price'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'salon_id': salonId,
        'service_id': serviceId,
        'service_ids': serviceIds,
        'guest_name': guestName,
        'guest_phone': guestPhone,
        'slot_at': slotAt.toIso8601String(),
        'status': status,
        'salon_name': salonName,
        'service_name': serviceName,
        'service_names': serviceNames,
        'total_duration_minutes': totalDurationMinutes,
        'total_price': totalPrice,
      };

  List<int> get resolvedServiceIds {
    if (serviceIds != null && serviceIds!.isNotEmpty) return serviceIds!;
    return [serviceId];
  }

  List<String> get resolvedServiceNames {
    if (serviceNames != null && serviceNames!.isNotEmpty) return serviceNames!;
    if (serviceName != null && serviceName!.trim().isNotEmpty) {
      return [serviceName!];
    }
    return [];
  }

  String serviceSummary({int maxNames = 2}) {
    final names = resolvedServiceNames;
    if (names.isEmpty) return 'Hyzmat #$serviceId';
    if (names.length <= maxNames) return names.join(', ');
    return '${names.take(maxNames).join(', ')} +${names.length - maxNames}';
  }
}
