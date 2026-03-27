import 'package:flutter/material.dart';
import '../models/salon.dart';
import '../utils/salon_images.dart';

class SalonGalleryScreen extends StatelessWidget {
  final Salon salon;
  final int initialIndex;
  const SalonGalleryScreen({super.key, required this.salon, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    final images = portfolioImages(salon);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Material(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close_rounded, color: Colors.white),
            ),
          ),
        ),
        title: Text(
          '${initialIndex + 1} / ${images.length}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex.clamp(0, images.length - 1)),
        itemCount: images.length,
        itemBuilder: (_, i) => InteractiveViewer(
          minScale: 0.5,
          maxScale: 4,
          child: Image.asset(
            images[i],
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(Icons.broken_image_rounded, size: 72, color: Colors.white54),
            ),
          ),
        ),
      ),
    );
  }
}
