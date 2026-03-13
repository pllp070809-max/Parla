import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/salon.dart';
import '../models/booking.dart';

class ApiService {
  Future<List<Salon>> getSalons({String? category}) async {
    final uri = Uri.parse('$apiBaseUrl/salons').replace(
      queryParameters: category != null ? {'category': category} : null,
    );
    final res = await http.get(uri);
    _check(res);
    final list = jsonDecode(res.body) as List;
    return list.map((e) => Salon.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Salon> getSalonDetail(int salonId) async {
    final res = await http.get(Uri.parse('$apiBaseUrl/salons/$salonId'));
    _check(res);
    return Salon.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<List<String>> getSlots({
    required int salonId,
    required String date,
    required int serviceId,
  }) async {
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
