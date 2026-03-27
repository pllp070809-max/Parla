import 'package:flutter/material.dart';

import '../models/salon.dart';
import '../theme.dart';

const _allImages = <String>[
  'images/1.webp',
  'images/2.jpg',
  'images/3.jpg',
  'images/4.jpg',
  'images/5.png',
  'images/6.webp',
  'images/7.webp',
  'images/8.jpg',
  'images/9.jpg',
];

const _keyToImage = <String, String>{
  'img1': 'images/1.webp',
  'img2': 'images/2.jpg',
  'img3': 'images/3.jpg',
  'img4': 'images/4.jpg',
  'img5': 'images/5.png',
  'img6': 'images/6.webp',
  'img7': 'images/7.webp',
  'img8': 'images/8.jpg',
  'img9': 'images/9.jpg',
};

/// imageKey-den asset path almak. Tapylmasa salon.id boýunça fallback.
String imageForKey(String? key, {int fallbackId = 0}) {
  if (key != null && _keyToImage.containsKey(key)) {
    return _keyToImage[key]!;
  }
  return _allImages[fallbackId % _allImages.length];
}

/// Salon üçin esasy (baş) surat.
String salonMainImage(Salon salon) {
  return imageForKey(salon.imageKey, fallbackId: salon.id);
}

/// Salon üçin portfolio / galereýa suratlary (esasysy birinji, soň rotation).
List<String> portfolioImages(Salon salon) {
  final main = salonMainImage(salon);
  final base = salon.id % _allImages.length;
  final result = <String>[main];
  for (int i = 1; i < _allImages.length; i++) {
    final img = _allImages[(base + i) % _allImages.length];
    if (img != main) result.add(img);
  }
  return result;
}

Widget salonImage(
  String assetPath, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
}) {
  return Image.asset(
    assetPath,
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
