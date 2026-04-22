import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../models/salon.dart';
import '../models/booking.dart';
import 'mock_api_data.dart';

class ApiService {
  static const String _kMockBookingsKey = 'mock_api_bookings_v1';

  Future<List<Salon>> getSalons({String? category}) async {
    if (kUseMockApi) {
      await Future.delayed(const Duration(milliseconds: 220));
      final all = kMockSalons;
      if (category == null || category.isEmpty) return all;
      final c = category.toLowerCase();
      return all.where((s) => (s.category ?? '').toLowerCase() == c).toList();
    }

    final uri = Uri.parse('$apiBaseUrl/salons').replace(
      queryParameters: category != null ? {'category': category} : null,
    );
    final res = await http.get(uri);
    _check(res);
    final list = jsonDecode(res.body) as List;
    return list.map((e) => Salon.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Salon> getSalonDetail(int salonId) async {
    if (kUseMockApi) {
      await Future.delayed(const Duration(milliseconds: 180));
      return mockSalonById(salonId);
    }

    final res = await http.get(Uri.parse('$apiBaseUrl/salons/$salonId'));
    _check(res);
    return Salon.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<List<String>> getSlots({
    required int salonId,
    required String date,
    required int serviceId,
    List<int>? serviceIds,
    int? totalDurationMinutes,
  }) async {
    if (kUseMockApi) {
      await Future.delayed(const Duration(milliseconds: 240));
      return _mockSlotsForDate(
        salonId: salonId,
        date: date,
        serviceId: serviceId,
        serviceIds: serviceIds,
        totalDurationMinutes: totalDurationMinutes,
      );
    }

    final uri = Uri.parse('$apiBaseUrl/salons/$salonId/slots').replace(
      queryParameters: {
        'date': date,
        'service_id': serviceId.toString(),
        if (serviceIds != null && serviceIds.isNotEmpty)
          'service_ids': serviceIds.join(','),
        if (totalDurationMinutes != null)
          'total_duration_minutes': totalDurationMinutes.toString(),
      },
    );
    final res = await http.get(uri);
    _check(res);
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['slots'] as List).cast<String>();
  }

  Future<Booking> createBooking({
    required int salonId,
    required int serviceId,
    List<int>? serviceIds,
    required String guestName,
    required String guestPhone,
    required String slotAt,
    int? totalDurationMinutes,
    double? totalPrice,
  }) async {
    if (kUseMockApi) {
      await Future.delayed(const Duration(milliseconds: 320));
      return _mockCreateBooking(
        salonId: salonId,
        serviceId: serviceId,
        serviceIds: serviceIds,
        guestName: guestName,
        guestPhone: guestPhone,
        slotAt: slotAt,
        totalDurationMinutes: totalDurationMinutes,
        totalPrice: totalPrice,
      );
    }

    final res = await http.post(
      Uri.parse('$apiBaseUrl/bookings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'salon_id': salonId,
        'service_id': serviceId,
        if (serviceIds != null && serviceIds.isNotEmpty)
          'service_ids': serviceIds,
        'guest_name': guestName,
        'guest_phone': guestPhone,
        'slot_at': slotAt,
        if (totalDurationMinutes != null)
          'total_duration_minutes': totalDurationMinutes,
        if (totalPrice != null) 'total_price': totalPrice,
      }),
    );
    _check(res);
    return Booking.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<List<Booking>> getBookings(String phone) async {
    if (kUseMockApi) {
      await Future.delayed(const Duration(milliseconds: 200));
      final bookings = await _mockLoadBookings();
      final digits = _digits(phone);
      final filtered = bookings.where((b) => _digits(b.guestPhone) == digits).toList();
      filtered.sort((a, b) => a.slotAt.compareTo(b.slotAt));
      return filtered;
    }

    final uri = Uri.parse('$apiBaseUrl/bookings').replace(
      queryParameters: {'phone': phone},
    );
    final res = await http.get(uri);
    _check(res);
    final list = jsonDecode(res.body) as List;
    return list
        .map((e) => Booking.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Booking> cancelBooking(int bookingId, String phone) async {
    if (kUseMockApi) {
      await Future.delayed(const Duration(milliseconds: 260));
      final bookings = await _mockLoadBookings();
      final digits = _digits(phone);
      final idx = bookings.indexWhere((b) => b.id == bookingId && _digits(b.guestPhone) == digits);
      if (idx == -1) {
        throw ApiException(404, 'Bron tapylmady');
      }

      final updated = Booking(
        id: bookings[idx].id,
        salonId: bookings[idx].salonId,
        serviceId: bookings[idx].serviceId,
        serviceIds: bookings[idx].serviceIds,
        guestName: bookings[idx].guestName,
        guestPhone: bookings[idx].guestPhone,
        slotAt: bookings[idx].slotAt,
        status: 'cancelled',
        salonName: bookings[idx].salonName,
        serviceName: bookings[idx].serviceName,
        serviceNames: bookings[idx].serviceNames,
        totalDurationMinutes: bookings[idx].totalDurationMinutes,
        totalPrice: bookings[idx].totalPrice,
      );

      bookings[idx] = updated;
      await _mockSaveBookings(bookings);
      return updated;
    }

    final uri = Uri.parse('$apiBaseUrl/bookings/$bookingId').replace(
      queryParameters: {'phone': phone},
    );
    final res = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': 'cancelled'}),
    );
    _check(res);
    return Booking.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<List<Booking>> _mockLoadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_kMockBookingsKey);
    if (raw == null || raw.isEmpty) return [];
    return raw
        .map((e) => Booking.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  Future<void> _mockSaveBookings(List<Booking> bookings) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = bookings.map((b) => jsonEncode(b.toJson())).toList();
    await prefs.setStringList(_kMockBookingsKey, raw);
  }

  String _digits(String v) => v.replaceAll(RegExp(r'[^0-9]'), '');

  Future<Booking> _mockCreateBooking({
    required int salonId,
    required int serviceId,
    List<int>? serviceIds,
    required String guestName,
    required String guestPhone,
    required String slotAt,
    int? totalDurationMinutes,
    double? totalPrice,
  }) async {
    final salon = mockSalonById(salonId);
    final selectedServices = _resolveSelectedServices(
      salon: salon,
      primaryServiceId: serviceId,
      serviceIds: serviceIds,
    );
    if (selectedServices.isEmpty) {
      throw ApiException(400, 'Hyzmat tapylmady');
    }

    // slotAt häzirki UI-dan `DateTime.toIso8601String()` ýaly gelýär.
    final slot = DateTime.parse(slotAt);
    final resolvedDuration = totalDurationMinutes ??
        selectedServices.fold<int>(
          0,
          (sum, service) => sum + service.durationMinutes,
        );
    final slotEnd = slot.add(Duration(minutes: resolvedDuration));

    final bookings = await _mockLoadBookings();
    final hasConflict = bookings.any((b) =>
        b.status == 'confirmed' &&
        b.salonId == salonId &&
        _rangesOverlap(
          startA: slot,
          endA: slotEnd,
          startB: b.slotAt,
          endB: b.slotAt.add(Duration(minutes: _bookingDurationMinutes(b))),
        ));

    if (hasConflict) {
      throw ApiException(409, 'Wagt eýýäm bronlandy');
    }

    final id = DateTime.now().millisecondsSinceEpoch;
    final booking = Booking(
      id: id,
      salonId: salonId,
      serviceId: serviceId,
      serviceIds: selectedServices.map((service) => service.id).toList(),
      guestName: guestName,
      guestPhone: guestPhone,
      slotAt: slot,
      status: 'confirmed',
      salonName: salon.name,
      serviceName: selectedServices.first.name,
      serviceNames: selectedServices.map((service) => service.name).toList(),
      totalDurationMinutes: resolvedDuration,
      totalPrice: totalPrice ??
          selectedServices.fold<double>(
            0,
            (sum, service) => sum + (service.price ?? 0),
          ),
    );

    bookings.add(booking);
    await _mockSaveBookings(bookings);
    return booking;
  }

  Future<List<String>> _mockSlotsForDate({
    required int salonId,
    required String date,
    required int serviceId,
    List<int>? serviceIds,
    int? totalDurationMinutes,
  }) async {
    final day = DateTime.parse(date); // yyyy-MM-dd
    final bookings = await _mockLoadBookings();
    final salon = mockSalonById(salonId);
    final selectedServices = _resolveSelectedServices(
      salon: salon,
      primaryServiceId: serviceId,
      serviceIds: serviceIds,
    );
    if (selectedServices.isEmpty) return [];
    final resolvedDuration = totalDurationMinutes ??
        selectedServices.fold<int>(
          0,
          (sum, service) => sum + service.durationMinutes,
        );
    final confirmed = bookings.where(
      (booking) => booking.status == 'confirmed' && booking.salonId == salonId,
    );

    final out = <String>[];
    for (int h = 9; h <= 17; h++) {
      for (final m in [0, 30]) {
        // 17:30 bolmaz ýaly
        if (h == 17 && m == 30) continue;
        final dt = DateTime(day.year, day.month, day.day, h, m);
        final end = dt.add(Duration(minutes: resolvedDuration));
        if (end.day != dt.day || end.hour > 18 || (end.hour == 18 && end.minute > 0)) {
          continue;
        }
        final slotStr = dt.toIso8601String();
        final taken = confirmed.any(
          (booking) => _rangesOverlap(
            startA: dt,
            endA: end,
            startB: booking.slotAt,
            endB: booking.slotAt.add(
              Duration(minutes: _bookingDurationMinutes(booking)),
            ),
          ),
        );
        if (!taken) out.add(slotStr);
      }
    }

    return out;
  }

  List<Service> _resolveSelectedServices({
    required Salon salon,
    required int primaryServiceId,
    List<int>? serviceIds,
  }) {
    final resolvedIds = <int>[
      ...?serviceIds,
      if (serviceIds == null || serviceIds.isEmpty) primaryServiceId,
    ];
    final uniqueIds = <int>[];
    for (final id in resolvedIds) {
      if (!uniqueIds.contains(id)) uniqueIds.add(id);
    }
    final selectedServices = <Service>[];
    for (final id in uniqueIds) {
      final match = _findSalonService(salon, id);
      if (match != null) selectedServices.add(match);
    }
    return selectedServices;
  }

  Service? _findSalonService(Salon salon, int id) {
    for (final service in salon.services) {
      if (service.id == id) return service;
    }
    return null;
  }

  int _bookingDurationMinutes(Booking booking) {
    if (booking.totalDurationMinutes != null && booking.totalDurationMinutes! > 0) {
      return booking.totalDurationMinutes!;
    }
    final salon = mockSalonById(booking.salonId);
    final selectedServices = _resolveSelectedServices(
      salon: salon,
      primaryServiceId: booking.serviceId,
      serviceIds: booking.serviceIds,
    );
    if (selectedServices.isEmpty) return 30;
    return selectedServices.fold<int>(
      0,
      (sum, service) => sum + service.durationMinutes,
    );
  }

  bool _rangesOverlap({
    required DateTime startA,
    required DateTime endA,
    required DateTime startB,
    required DateTime endB,
  }) {
    return startA.isBefore(endB) && endA.isAfter(startB);
  }

  void _check(http.Response res) {
    if (res.statusCode >= 400) {
      final msg = _tryParseDetail(res.body) ?? 'Ýalňyşlyk: ${res.statusCode}';
      throw ApiException(res.statusCode, msg);
    }
  }

  String? _tryParseDetail(String body) {
    try {
      final data = jsonDecode(body);
      if (data is Map && data.containsKey('detail')) return data['detail'] as String;
    } catch (_) {}
    return null;
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  const ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
