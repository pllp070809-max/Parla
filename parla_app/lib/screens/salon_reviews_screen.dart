import 'package:flutter/material.dart';
import '../theme.dart';

class SalonReviewsScreen extends StatelessWidget {
  final String salonName;
  const SalonReviewsScreen({super.key, required this.salonName});

  static final _mockReviews = [
    _ReviewItem('Aýna', 5.0, 'Örän gowy hyzmat, maslahat berýärin!', '2 gün öň'),
    _ReviewItem('Mähri', 4.5, 'Salon arassaty we hyzmat taýdan gowy.', '1 hepde öň'),
    _ReviewItem('Gulya', 5.0, 'Ilkinji gezek geldim, gaty gowy boldum.', '2 hepde öň'),
  ];

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Synlar'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _mockReviews.length,
        itemBuilder: (_, i) {
          final r = _mockReviews[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kSurfaceBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: kPrimary.withValues(alpha: 0.2),
                        child: Text(r.author[0].toUpperCase(), style: const TextStyle(color: kPrimary, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.author, style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                            Row(
                              children: [
                                ...List.generate(5, (j) => Icon(
                                  j < r.rating.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
                                  size: 16,
                                  color: kStar,
                                )),
                                const SizedBox(width: 6),
                                Text(r.time, style: tt.bodySmall?.copyWith(color: kTextTertiary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(r.text, style: tt.bodyMedium),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ReviewItem {
  final String author;
  final double rating;
  final String text;
  final String time;
  _ReviewItem(this.author, this.rating, this.text, this.time);
}
