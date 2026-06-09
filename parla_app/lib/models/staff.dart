class Staff {
  final int id;
  final int salonId;
  final String salonName;
  final String salonAddress;
  final String name;
  final String role;
  final double rating;
  final int reviewsCount;
  final String imageKey;
  final double distanceKm;

  const Staff({
    required this.id,
    required this.salonId,
    required this.salonName,
    required this.salonAddress,
    required this.name,
    required this.role,
    required this.rating,
    required this.reviewsCount,
    required this.imageKey,
    this.distanceKm = 1.2,
  });
}
