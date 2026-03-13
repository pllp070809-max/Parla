import 'package:url_launcher/url_launcher.dart';
import '../models/salon.dart';

/// Salona ugur (Google Maps) açýar. Lat/long bar bolsa ol ulanylýar, ýok bolsa salgy.
Future<void> openMapsDirection(Salon salon) async {
  String url;
  if (salon.hasLocation && salon.latitude != null && salon.longitude != null) {
    url = 'https://www.google.com/maps/dir/?api=1&destination=${salon.latitude},${salon.longitude}';
  } else if (salon.address != null && salon.address!.isNotEmpty) {
    url = 'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(salon.address!)}';
  } else {
    url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(salon.name)}';
  }
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
