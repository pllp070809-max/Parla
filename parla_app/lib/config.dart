// Web-de dart:io ýok, şonuň üçin conditional import.
import 'config_stub.dart' if (dart.library.io) 'config_io.dart' as platform;

const int apiPort = 8000;

/// Serwersiz demo / offline APK / web-de serwer talap etmeýän ýagdaý.
/// Chrome üçin hem safe: `dart.library.io` ýok ýagdaýda `config_stub.dart` ulanylýar.
/// Şeýle-de bolsa internet ýok wagty UI render bolmagy üçin diňe mock ulanyp biler.
const bool kUseMockApi = bool.fromEnvironment('USE_MOCK_API', defaultValue: true);

/// Fiziki telefonda synag: kompýuteriň WiFi IP salgysyny goýuň.
/// Chrome / Windows üçin boş goýuň (localhost ulanylýar).
const String kApiHostOverride = '';

String get apiBaseUrl {
  if (kApiHostOverride.isNotEmpty) {
    return 'http://$kApiHostOverride:$apiPort';
  }
  final host = platform.apiHostFromPlatform;
  return 'http://$host:$apiPort';
}
