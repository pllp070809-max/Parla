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
  }) async {
    if (kUseMockApi) {
      await Future.delayed(const Duration(milliseconds: 240));
      return _mockSlotsForDate(salonId: salonId, date: date, serviceId: serviceId);
    }

    final uri = Uri.parse('$apiBaseUrl/salons/$salonId/slots').replace(
      queryParameters: {'date': date, 'service_id': serviceId.toString()},
    );
    final res = await http.get(uri);
    _check(res);
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['slots'] as List).cast<String>();
  }

  Future<Booking> createBooking({
    required int salonId,
    required int serviceId,
    required String guestName,
    required String guestPhone,
    required String slotAt,
  }) async {
    if (kUseMockApi) {
      await Future.delayed(const Duration(milliseconds: 320));
      return _mockCreateBooking(
        salonId: salonId,
        serviceId: serviceId,
        guestName: guestName,
        guestPhone: guestPhone,
        slotAt: slotAt,
      );
    }

    final res = await http.post(
      Uri.parse('$apiBaseUrl/bookings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'salon_id': salonId,
        'service_id': serviceId,
        'guest_name': guestName,
        'guest_phone': guestPhone,
        'slot_at': slotAt,
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
        guestName: bookings[idx].guestName,
        guestPhone: bookings[idx].guestPhone,
        slotAt: bookings[idx].slotAt,
        status: 'cancelled',
        salonName: bookings[idx].salonName,
        serviceName: bookings[idx].serviceName,
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
    required String guestName,
    required String guestPhone,
    required String slotAt,
  }) async {
    final salon = mockSalonById(salonId);
    final service = salon.services.firstWhere((s) => s.id == serviceId, orElse: () => const Service(id: -1, name: '', durationMinutes: 0));
    if (service.id == -1) {
      throw ApiException(400, 'Hyzmat tapylmady');
    }

    // slotAt häzirki UI-dan `DateTime.toIso8601String()` ýaly gelýär.
    final slot = DateTime.parse(slotAt);

    final bookings = await _mockLoadBookings();
    final hasConflict = bookings.any((b) =>
        b.status == 'confirmed' &&
        b.salonId == salonId &&
        b.serviceId == serviceId &&
        b.slotAt == slot);

    if (hasConflict) {
      throw ApiException(409, 'Wagt eýýäm bronlandy');
    }

    final id = DateTime.now().millisecondsSinceEpoch;
    final booking = Booking(
      id: id,
      salonId: salonId,
      serviceId: serviceId,
      guestName: guestName,
      guestPhone: guestPhone,
      slotAt: slot,
      status: 'confirmed',
      salonName: salon.name,
      serviceName: service.name,
    );

    bookings.add(booking);
    await _mockSaveBookings(bookings);
    return booking;
  }

  Future<List<String>> _mockSlotsForDate({
    required int salonId,
    required String date,
    required int serviceId,
  }) async {
    final day = DateTime.parse(date); // yyyy-MM-dd
    final bookings = await _mockLoadBookings();

    final confirmed = bookings.where((b) => b.status == 'confirmed' && b.salonId == salonId && b.serviceId == serviceId);

    final out = <String>[];
    for (int h = 9; h <= 17; h++) {
      for (final m in [0, 30]) {
        // 17:30 bolmaz ýaly
        if (h == 17 && m == 30) continue;
        final dt = DateTime(day.year, day.month, day.day, h, m);
        final slotStr = dt.toIso8601String();
        final taken = confirmed.any((b) => b.slotAt == dt);
        if (!taken) out.add(slotStr);
      }
    }

    return out;
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
