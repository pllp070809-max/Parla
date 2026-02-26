import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/salon.dart';
import '../theme.dart';
import 'salons_list_screen.dart';
import 'salon_detail_screen.dart';

final _featuredProvider = FutureProvider<List<Salon>>((ref) {
  return ref.read(apiServiceProvider).getSalons();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _categories = [
    _Cat('Salon', Icons.content_cut, 'salon'),
    _Cat('Barber', Icons.face, 'barber'),
    _Cat('Spa', Icons.spa, 'spa'),
    _Cat('Gözellik', Icons.auto_awesome, 'gözellik'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = ref.watch(_featuredProvider);
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Parla', style: tt.headlineLarge?.copyWith(color: kPrimary)),
                    const SizedBox(height: 4),
                    Text('Salon tapyň, bron ediň', style: tt.bodyMedium),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Salon ýa-da hyzmat gözle...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (q) {
                    if (q.trim().isEmpty) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SalonsListScreen(searchQuery: q.trim()),
                      ),
                    );
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Text('Kategoriýalar', style: tt.titleLarge),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final cat = _categories[i];
                    return _CategoryChip(
                      label: cat.label,
                      icon: cat.icon,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SalonsListScreen(category: cat.key),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Text('Öňe çykan salonlar', style: tt.titleLarge),
              ),
            ),

            featured.when(
              loading: () => const SliverToBoxAdapter(
                child: Center(child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                )),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Ýalňyşlyk: $e', style: tt.bodyMedium),
                ),
              ),
              data: (salons) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList.separated(
                  itemCount: salons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _SalonCard(
                    salon: salons[i],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SalonDetailScreen(salonId: salons[i].id),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _Cat {
  final String label;
  final IconData icon;
  final String key;
  const _Cat(this.label, this.icon, this.key);
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _CategoryChip({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 84,
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: kPrimary, size: 32),
              const SizedBox(height: 8),
              Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: kPrimary, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SalonCard extends StatelessWidget {
  final Salon salon;
  final VoidCallback onTap;
  const _SalonCard({required this.salon, required this.onTap});

  static const _imageMap = {
    'salon1': 'assets/images/salon1.png',
    'salon2': 'assets/images/salon2.png',
    'salon3': 'assets/images/salon3.png',
  };

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                width: double.infinity,
                color: kPrimary.withValues(alpha: 0.08),
                child: _imageMap.containsKey(salon.imageKey)
                  ? Image.asset(_imageMap[salon.imageKey]!, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder())
                  : _placeholder(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(salon.name, style: tt.titleMedium),
                  if (salon.address != null) ...[
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(Icons.location_on_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(child: Text(salon.address!, style: tt.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ]),
                  ],
                  if (salon.category != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: kPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(salon.category!, style: tt.labelLarge?.copyWith(color: kPrimary, fontSize: 12)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _placeholder() => const Center(child: Icon(Icons.storefront, size: 48, color: kPrimary));
}
