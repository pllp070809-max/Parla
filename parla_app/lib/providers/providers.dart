import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/booking.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

/// Bottom bar saýlanan tab (0 = Sahypa, 1 = Bronlarym, 2 = Profil).
final selectedTabIndexProvider = StateProvider<int>((ref) => 0);

/// Ulanyjynyň saklanan telefon nomeri.
final userPhoneProvider = StateNotifierProvider<UserPhoneNotifier, String?>((ref) {
  return UserPhoneNotifier();
});

class UserPhoneNotifier extends StateNotifier<String?> {
  UserPhoneNotifier() : super(null) { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('profile_phone') ?? '';
    state = phone.isEmpty ? null : phone;
  }

  void setPhone(String? phone) {
    state = (phone != null && phone.trim().isNotEmpty) ? phone.trim() : null;
  }
}

/// Ulanyjynyň bronlary – telefon bar bolsa awtomatiki ýüklenýär.
final myBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final phone = ref.watch(userPhoneProvider);
  if (phone == null || phone.isEmpty) return [];
  return ref.read(apiServiceProvider).getBookings(phone);
});
