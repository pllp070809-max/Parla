// Web-de dart:io ýok, şonuň üçin conditional import.
import 'config_stub.dart' if (dart.library.io) 'config_io.dart' as platform;

const int apiPort = 8000;

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
