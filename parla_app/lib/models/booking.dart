class Booking {
  final int id;
  final int salonId;
  final int serviceId;
  final String guestName;
  final String guestPhone;
  final DateTime slotAt;
  final String status;
  final String? salonName;
  final String? serviceName;

  const Booking({
    required this.id,
    required this.salonId,
    required this.serviceId,
    required this.guestName,
    required this.guestPhone,
    required this.slotAt,
    required this.status,
    this.salonName,
    this.serviceName,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'] as int,
        salonId: json['salon_id'] as int,
        serviceId: json['service_id'] as int,
        guestName: json['guest_name'] as String,
        guestPhone: json['guest_phone'] as String,
        slotAt: DateTime.parse(json['slot_at'] as String),
        status: json['status'] as String,
        salonName: json['salon_name'] as String?,
        serviceName: json['service_name'] as String?,
      );
}
