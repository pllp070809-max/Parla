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

/// Saýlanan salonlaryň ID-leri (Favourite) – Home kartasynda ýürek.
const _kFavouriteSalonIds = 'favourite_salon_ids';

final favouriteSalonsProvider = StateNotifierProvider<FavouriteSalonsNotifier, Set<int>>((ref) {
  return FavouriteSalonsNotifier();
});

class FavouriteSalonsNotifier extends StateNotifier<Set<int>> {
  FavouriteSalonsNotifier() : super({}) { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kFavouriteSalonIds);
    if (raw == null || raw.isEmpty) return;
    state = raw.split(',').map((e) => int.tryParse(e.trim())).whereType<int>().toSet();
  }

  Future<void> toggle(int salonId) async {
    final next = Set<int>.from(state);
    if (next.contains(salonId)) {
      next.remove(salonId);
    } else {
      next.add(salonId);
    }
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFavouriteSalonIds, next.join(','));
  }
}

/// Profil ady (avatar initial üçin).
final profileNameProvider = FutureProvider<String?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('profile_name');
});

/// Täze bildiriş bar (badge üçin) – mock.
final hasUnreadNotificationsProvider = StateProvider<bool>((ref) => true);

/// Soňky gözleg sözleri (gözleg sahypasy üçin) – SharedPreferences.
const _kRecentSearchesKey = 'recent_search_queries';
const _kRecentSearchesMax = 10;

final recentSearchQueriesProvider = StateNotifierProvider<RecentSearchQueriesNotifier, List<String>>((ref) {
  return RecentSearchQueriesNotifier();
});

class RecentSearchQueriesNotifier extends StateNotifier<List<String>> {
  RecentSearchQueriesNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kRecentSearchesKey);
    if (raw == null || raw.isEmpty) return;
    state = raw.split('|').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  Future<void> add(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;
    final next = [q, ...state.where((s) => s.toLowerCase() != q.toLowerCase())];
    if (next.length > _kRecentSearchesMax) next.length = _kRecentSearchesMax;
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kRecentSearchesKey, next.join('|'));
  }
}
