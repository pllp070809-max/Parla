import 'dart:io' show Platform;

const String _androidEmulatorHost = '10.0.2.2';
const String _defaultHost = 'localhost';
const int apiPort = 8000;

/// Fiziki telefonda synag: kompýuteriň WiFi IP salgysyny goýuň (mysal: '192.168.1.100').
/// Telefon we kompýuter bir WiFi-de bolmaly. Null bolsa: emulator = 10.0.2.2, beýlekiler = localhost.
/// Fiziki tel üçin: kompýuteriň WiFi IP-si. Boş goýsa emulator/localhost ulanylýar.
const String kApiHostOverride = '192.168.31.165';

String get apiBaseUrl {
  if (kApiHostOverride.isNotEmpty) {
    return 'http://$kApiHostOverride:$apiPort';
  }
  final host = Platform.isAndroid ? _androidEmulatorHost : _defaultHost;
  return 'http://$host:$apiPort';
}
