import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

/// Bottom bar saýlanan tab (0 = Sahypa, 1 = Bronlarym, 2 = Profil).
final selectedTabIndexProvider = StateProvider<int>((ref) => 0);
