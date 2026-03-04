import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/salon.dart';
import '../theme.dart';
import '../widgets/shared_widgets.dart';
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
        child: RefreshIndicator(
          color: kPrimary,
          onRefresh: () async => ref.invalidate(_featuredProvider),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(kSpaceXl, kSpace2xl, kSpaceXl, kSpaceSm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Parla', style: tt.headlineLarge?.copyWith(color: kPrimary)),
                      const SizedBox(height: kSpaceXs),
                      Text('Salon tapyň, bron ediň', style: tt.bodyMedium),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kSpaceXl, vertical: kSpaceMd),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Salon ýa-da hyzmat gözle...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (q) {
                      if (q.trim().isEmpty) return;
                      Navigator.push(context, fadeSlideRoute(SalonsListScreen(searchQuery: q.trim())));
                    },
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(kSpaceXl, kSpaceSm, kSpaceXl, kSpaceMd),
                  child: Text('Kategoriýalar', style: tt.titleLarge),
                ),
              ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: kSpaceXl),
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: kSpaceMd),
                    itemBuilder: (_, i) {
                      final cat = _categories[i];
                      return _CategoryChip(
                        label: cat.label,
                        icon: cat.icon,
                        onTap: () => Navigator.push(context, fadeSlideRoute(SalonsListScreen(category: cat.key))),
                      );
                    },
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(kSpaceXl, kSpaceXl, kSpaceXl, kSpaceMd),
                  child: Text('Öňe çykan salonlar', style: tt.titleLarge),
                ),
              ),

              featured.when(
                loading: () => SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: kSpaceXl),
                  sliver: SliverList.separated(
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(height: kSpaceMd),
                    itemBuilder: (_, __) => const SalonCardSkeleton(),
                  ),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: ErrorRetryWidget(
                    message: 'Salonlary ýükläp bolmady',
                    onRetry: () => ref.invalidate(_featuredProvider),
                  ),
                ),
                data: (salons) => SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: kSpaceXl),
                  sliver: SliverList.separated(
                    itemCount: salons.length,
                    separatorBuilder: (_, __) => const SizedBox(height: kSpaceMd),
                    itemBuilder: (_, i) => _SalonCard(
                      salon: salons[i],
                      onTap: () => Navigator.push(context, fadeSlideRoute(SalonDetailScreen(salonId: salons[i].id))),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: kSpace2xl)),
            ],
          ),
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
        borderRadius: BorderRadius.circular(kRadiusLg),
        child: Container(
          width: 84,
          decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(kRadiusLg), boxShadow: kShadowSm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: kPrimary, size: 32),
              const SizedBox(height: kSpaceSm),
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
    'salon1': 'images/salon1.png',
    'salon2': 'images/salon2.png',
    'salon3': 'images/salon3.png',
  };

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kRadiusLg),
        child: Container(
          decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(kRadiusLg), boxShadow: kShadowMd),
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
                padding: const EdgeInsets.all(kSpaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(salon.name, style: tt.titleMedium),
                    if (salon.address != null) ...[
                      const SizedBox(height: kSpaceXs),
                      Row(children: [
                        Icon(Icons.location_on_outlined, size: 16, color: kTextSecondary),
                        const SizedBox(width: kSpaceXs),
                        Expanded(child: Text(salon.address!, style: tt.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ]),
                    ],
                    if (salon.category != null) ...[
                      const SizedBox(height: kSpaceSm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: kSpaceXs),
                        decoration: BoxDecoration(color: kPrimary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(kRadiusSm)),
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
