import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/salon.dart';
import '../theme.dart';
import '../widgets/shared_widgets.dart';
import 'salons_list_screen.dart';
import 'salon_detail_screen.dart';
import 'search_screen.dart';
import 'all_categories_screen.dart';
import 'location_picker_screen.dart';
import 'notifications_screen.dart';
import 'deals_screen.dart';

final _featuredProvider = FutureProvider<List<Salon>>((ref) {
  return ref.read(apiServiceProvider).getSalons();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _categories = [
    _Cat('Saç salony', Icons.content_cut_rounded, 'salon'),
    _Cat('Barberhana', Icons.face_rounded, 'barber'),
    _Cat('Dyrnak', Icons.brush_rounded, 'salon'),
    _Cat('Kirpik', Icons.visibility_rounded, 'gözellik'),
    _Cat('Massage', Icons.spa_rounded, 'spa'),
    _Cat('Makiýaž', Icons.palette_rounded, 'gözellik'),
    _Cat('Spa', Icons.hot_tub_rounded, 'spa'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salons = ref.watch(_featuredProvider);
    final tt = Theme.of(context).textTheme;
    final screenW = MediaQuery.of(context).size.width;
    final cardW = (screenW * 0.72).clamp(240.0, 320.0);

    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: SafeArea(
        child: RefreshIndicator(
          color: kPrimary,
          onRefresh: () async => ref.invalidate(_featuredProvider),
          child: CustomScrollView(
            slivers: [
              // ── Fresha header: Gözle (uly) + location chip + bell + avatar ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Gözle',
                              style: tt.headlineLarge?.copyWith(fontSize: 26, letterSpacing: -0.6),
                            ),
                            const SizedBox(height: 2),
                            GestureDetector(
                              onTap: () => Navigator.push(context, fadeSlideRoute(const LocationPickerScreen())),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.location_on_rounded, size: 14, color: kTextSecondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    ref.watch(selectedLocationProvider),
                                    style: tt.bodySmall?.copyWith(color: kTextSecondary, fontSize: 13),
                                  ),
                                  Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: kTextSecondary),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, size: 24),
                        onPressed: () => Navigator.push(context, fadeSlideRoute(const NotificationsScreen())),
                        style: IconButton.styleFrom(foregroundColor: kTextPrimary),
                      ),
                      GestureDetector(
                        onTap: () => ref.read(selectedTabIndexProvider.notifier).state = 2,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: kSurfaceBg,
                            shape: BoxShape.circle,
                            border: Border.all(color: kBorder),
                          ),
                          child: const Icon(Icons.person_rounded, color: kPrimary, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Search bar (Fresha: doly giňlik, 14px radius) ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Material(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: () => Navigator.push(context, fadeSlideRoute(const SearchScreen())),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(Icons.search_rounded, color: kTextTertiary, size: 22),
                            const SizedBox(width: 10),
                            Text(
                              'Salonlary we hyzmatlary gözle',
                              style: tt.bodyMedium?.copyWith(color: kTextTertiary, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Top categories (Fresha: "Top categories" + See all) ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                  child: _sectionHeader(context, tt, 'Esasy kategoriýalar', toAllCategories: true),
                ),
              ),

              // ── Category circles: ak fon, inje çyzyk, 60px tegelek ──
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 92,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 20),
                    itemBuilder: (_, i) {
                      final cat = _categories[i];
                      return _CategoryCircle(
                        label: cat.label,
                        icon: cat.icon,
                        onTap: () => Navigator.push(
                          context,
                          fadeSlideRoute(SalonsListScreen(category: cat.key)),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // ── Arzanladyşlar (Fresha promo carousel) ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: _sectionHeader(context, tt, 'Arzanladyşlar', toDeals: true),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 104,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _DealPreviewCard(
                          title: 'Ilkinji zyýaretde 20%',
                          onTap: () => Navigator.push(context, fadeSlideRoute(const DealsScreen())),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _DealPreviewCard(
                          title: 'Massage paketi 15%',
                          onTap: () => Navigator.push(context, fadeSlideRoute(const DealsScreen())),
                        ),
                      ),
                      _DealPreviewCard(
                        title: 'Dyrnak + kirpik 10%',
                        onTap: () => Navigator.push(context, fadeSlideRoute(const DealsScreen())),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Maslahat berilýän ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                  child: _sectionHeader(context, tt, 'Maslahat berilýän'),
                ),
              ),
              _salonRow(salons, ref, context, cardW, false),

              // ── Meşhur ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                  child: _sectionHeader(context, tt, 'Meşhur'),
                ),
              ),
              _salonRow(salons, ref, context, cardW, true),

              // ── Täze Parla-da ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                  child: _sectionHeader(context, tt, 'Täze Parla-da'),
                ),
              ),
              _salonRow(salons, ref, context, cardW, false),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, TextTheme tt, String title, {bool toAllCategories = false, bool toDeals = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: tt.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w700, color: kTextPrimary),
        ),
        GestureDetector(
          onTap: () {
            if (toAllCategories) {
              Navigator.push(context, fadeSlideRoute(const AllCategoriesScreen()));
            } else if (toDeals) {
              Navigator.push(context, fadeSlideRoute(const DealsScreen()));
            } else {
              Navigator.push(context, fadeSlideRoute(const SalonsListScreen()));
            }
          },
          child: Text(
            'Hemmesini gör',
            style: tt.bodyMedium?.copyWith(
              color: kPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _salonRow(
    AsyncValue<List<Salon>> data,
    WidgetRef ref,
    BuildContext context,
    double cardW,
    bool reversed,
  ) {
    return data.when(
      loading: () => SliverToBoxAdapter(
        child: SizedBox(
          height: 262,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, __) => SizedBox(
              width: cardW,
              child: const _VenueCardSkeleton(),
            ),
          ),
        ),
      ),
      error: (e, _) => SliverToBoxAdapter(
        child: ErrorRetryWidget(
          message: 'Salonlary ýükläp bolmady',
          onRetry: () => ref.invalidate(_featuredProvider),
        ),
      ),
      data: (salons) {
        final list = reversed ? salons.reversed.toList() : salons;
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 262,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => SizedBox(
                width: cardW,
                child: _VenueCard(
                  salon: list[i],
                  onTap: () => Navigator.push(
                    context,
                    fadeSlideRoute(SalonDetailScreen(salonId: list[i].id)),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Data ──

class _Cat {
  final String label;
  final IconData icon;
  final String key;
  const _Cat(this.label, this.icon, this.key);
}

// ── Category Circle (Fresha style) ──

class _CategoryCircle extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _CategoryCircle({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
                boxShadow: kShadowSm,
              ),
              child: Icon(icon, color: kPrimary, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: kTextPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Venue Card (Fresha style) ──

class _VenueCard extends StatelessWidget {
  final Salon salon;
  final VoidCallback onTap;
  const _VenueCard({required this.salon, required this.onTap});

  static const _images = {
    'salon1': 'images/salon1.png',
    'salon2': 'images/salon2.png',
    'salon3': 'images/salon3.png',
  };

  double get _rating {
    const r = [5.0, 4.9, 4.8, 4.7, 4.6];
    return r[salon.id % r.length];
  }

  int get _reviews => (salon.id * 127 + 42) % 500 + 10;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image (Fresha: 14px radius, ýyldyz + salgy aşakda) ──
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: double.infinity,
              height: 160,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _images.containsKey(salon.imageKey)
                      ? Image.asset(
                          _images[salon.imageKey]!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 18,
                        color: kTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── Name (Fresha: 15–16px semibold) ──
          Text(
            salon.name,
            style: tt.titleSmall?.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: kTextPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // ── Rating + syn sany ──
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 15, color: kStar),
              const SizedBox(width: 4),
              Text(
                _rating.toStringAsFixed(1),
                style: tt.bodySmall?.copyWith(color: kTextPrimary, fontWeight: FontWeight.w600, fontSize: 13),
              ),
              Text(
                ' ($_reviews)',
                style: tt.bodySmall?.copyWith(fontSize: 13, color: kTextSecondary),
              ),
            ],
          ),
          if (salon.address != null) ...[
            const SizedBox(height: 2),
            Text(
              salon.address!,
              style: tt.bodySmall?.copyWith(fontSize: 13, color: kTextSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (salon.category != null) ...[
            const SizedBox(height: 1),
            Text(
              _catLabel(salon.category!),
              style: tt.bodySmall?.copyWith(fontSize: 12, color: kTextTertiary),
            ),
          ],
        ],
      ),
    );
  }

  String _catLabel(String key) {
    switch (key) {
      case 'salon':
        return 'Gözellik salony';
      case 'barber':
        return 'Barberhana';
      case 'spa':
        return 'Spa';
      default:
        return key;
    }
  }

  Widget _placeholder() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kPrimary.withValues(alpha: 0.15),
              kPrimary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Center(
          child: Icon(
            Icons.storefront_rounded,
            size: 48,
            color: kPrimary.withValues(alpha: 0.4),
          ),
        ),
      );
}

// ── Deal preview card ──

class _DealPreviewCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _DealPreviewCard({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              kPrimary.withValues(alpha: 0.18),
              kPrimary.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: kShadowSm,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: kPrimary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.local_offer_rounded, color: kPrimary, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: kTextPrimary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Skeleton ──

class _VenueCardSkeleton extends StatelessWidget {
  const _VenueCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBox(width: double.infinity, height: 160, radius: 14),
        const SizedBox(height: 10),
        const SkeletonBox(width: 140, height: 16),
        const SizedBox(height: 6),
        const SkeletonBox(width: 90, height: 14),
        const SizedBox(height: 4),
        const SkeletonBox(width: 160, height: 13),
      ],
    );
  }
}
