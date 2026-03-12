import 'package:flutter/material.dart';
import '../theme.dart';
import 'salons_list_screen.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  static const _categories = [
    _CatItem('Saç salony', Icons.content_cut_rounded, 'salon'),
    _CatItem('Barberhana', Icons.face_rounded, 'barber'),
    _CatItem('Dyrnak', Icons.brush_rounded, 'salon'),
    _CatItem('Kirpik', Icons.visibility_rounded, 'gözellik'),
    _CatItem('Massage', Icons.spa_rounded, 'spa'),
    _CatItem('Makiýaž', Icons.palette_rounded, 'gözellik'),
    _CatItem('Derini bejermek', Icons.face_retouching_natural_rounded, 'spa'),
    _CatItem('Spa', Icons.hot_tub_rounded, 'spa'),
    _CatItem('Tatuirowka', Icons.color_lens_rounded, 'salon'),
  ];

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ähli kategoriýalar'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final cat = _categories[i];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.push(context, fadeSlideRoute(SalonsListScreen(category: cat.key))),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: kSurfaceBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kBorder),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: kPrimary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(cat.icon, color: kPrimary, size: 28),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      cat.label,
                      style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CatItem {
  final String label;
  final IconData icon;
  final String key;
  const _CatItem(this.label, this.icon, this.key);
}
