import 'package:flutter/material.dart';

import '../config.dart';
import '../models/salon.dart';
import '../theme.dart';

/// Serwersiz / APK / offline web üçin assets.
const salonImageAssetsOffline = <String>[
  'images/salon1.png',
  'images/salon2.png',
  'images/salon3.png',
];

/// Online bolanda ulanmak üçin (internet bar bolsa).
/// (Internet ýok bolsa ulanma, sebäbi `kUseMockApi == true` bolanda offline ulanylýar.)
const salonImageUrlsOnline = <String>[
  'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=800&q=80',
  'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=800&q=80',
  'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?w=800&q=80',
  'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?w=800&q=80',
  'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&q=80',
  'https://images.unsplash.com/photo-1559599101-f09722fb4948?w=800&q=80',
  'https://images.unsplash.com/photo-1605497788044-5a32c7078486?w=800&q=80',
];

String salonImageUrl(Salon salon) {
  if (kUseMockApi) {
    return salonImageAssetsOffline[salon.id % salonImageAssetsOffline.length];
  }
  return salonImageUrlsOnline[salon.id % salonImageUrlsOnline.length];
}

List<String> salonImageUrlsList(Salon salon) {
  final base = salon.id % salonImageAssetsOffline.length;
  if (kUseMockApi) {
    return [
      salonImageAssetsOffline[base],
      salonImageAssetsOffline[(base + 1) % salonImageAssetsOffline.length],
      salonImageAssetsOffline[(base + 2) % salonImageAssetsOffline.length],
    ];
  }

  final onlineBase = salon.id % salonImageUrlsOnline.length;
  return [
    salonImageUrlsOnline[onlineBase],
    salonImageUrlsOnline[(onlineBase + 1) % salonImageUrlsOnline.length],
    salonImageUrlsOnline[(onlineBase + 2) % salonImageUrlsOnline.length],
  ];
}

/// URL ýa-da asset path-dan surat çykarmak üçin universal widget.
Widget salonImage(
  String urlOrAsset, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
}) {
  final isNetwork = urlOrAsset.startsWith('http');
  if (isNetwork) {
    return Image.network(
      urlOrAsset,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => _placeholder(width: width, height: height),
    );
  }

  return Image.asset(
    urlOrAsset,
    fit: fit,
    width: width,
    height: height,
    errorBuilder: (_, __, ___) => _placeholder(width: width, height: height),
  );
}

Widget _placeholder({double? width, double? height}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: kPrimarySoft.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(kRadiusMd),
      border: Border.all(color: kBorder.withValues(alpha: 0.7)),
    ),
    alignment: Alignment.center,
    child: const Icon(Icons.image_not_supported_rounded, size: 44, color: kTextTertiary),
  );
}

