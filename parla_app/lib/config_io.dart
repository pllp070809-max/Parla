// Android / iOS / desktop – Platform ulanylyar (web-de ulanylmaýar).
import 'dart:io' show Platform;

const String _androidEmulatorHost = '10.0.2.2';
const String _defaultHost = 'localhost';

String get apiHostFromPlatform =>
    Platform.isAndroid ? _androidEmulatorHost : _defaultHost;
