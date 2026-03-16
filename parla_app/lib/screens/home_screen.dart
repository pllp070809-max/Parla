import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: kSurfaceBg,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: kBorder),
                                ),
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
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined, size: 24),
                            onPressed: () => Navigator.push(context, fadeSlideRoute(const NotificationsScreen())),
                            style: IconButton.styleFrom(foregroundColor: kTextPrimary),
                          ),
                          if (ref.watch(hasUnreadNotificationsProvider))
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: kError,
                                  shape: BoxShape.circle,
                                  border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1)),
                                ),
                              ),
                            ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => ref.read(selectedTabIndexProvider.notifier).state = 2,
                        child: Consumer(
                          builder: (_, ref2, __) {
                            final name = ref2.watch(profileNameProvider).valueOrNull?.trim();
                            final initial = (name != null && name.isNotEmpty)
                                ? name[0].toUpperCase()
                                : 'P';
                            return Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: kPrimary.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                                border: Border.all(color: kBorder),
                              ),
                              child: Center(
                                child: Text(
                                  initial,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: kPrimary,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Search bar (pill + semantics) ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Semantics(
                    label: 'Salonlary we hyzmatlary gözle',
                    button: true,
                    child: Material(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(22),
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.push(context, fadeSlideRoute(const SearchScreen()));
                        },
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
              ),

              // ── Siziň geljekki bronyňyz ──
              _upcomingBookingStrip(ref, context, tt),

              // ── Soňky görülen salonlar ──
              _recentlyViewedRow(salons, ref, context, cardW),

              // ── Top categories ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                  child: _sectionHeader(context, tt, 'Esasy kategoriýalar', toAllCategories: true),
                ),
              ),

              // ── Category circles + sag tarap fade (scroll görkezijisi) ──
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 92,
                  child: Stack(
                    children: [
                      ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 20),
                        itemBuilder: (_, i) {
                          final cat = _categories[i];
                          return _CategoryCircle(
                            label: cat.label,
                            icon: cat.icon,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.push(
                                context,
                                fadeSlideRoute(SalonsListScreen(category: cat.key)),
                              );
                            },
                          );
                        },
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        width: 24,
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.white.withValues(alpha: 0), Colors.white],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        bottom: 0,
                        width: 24,
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [Colors.white.withValues(alpha: 0), Colors.white],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Arzanladyşlar ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(context, tt, 'Arzanladyşlar', toDeals: true),
                      const SizedBox(height: 2),
                      Text(
                        'Täzelikler ýakyn',
                        style: tt.bodySmall?.copyWith(color: kTextTertiary, fontSize: 12),
                      ),
                    ],
                  ),
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
                          showBadge: true,
                          badgeText: '2 gün',
                          gradientIndex: 0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _DealPreviewCard(
                          title: 'Massage paketi 15%',
                          onTap: () => Navigator.push(context, fadeSlideRoute(const DealsScreen())),
                          showBadge: false,
                          gradientIndex: 1,
                        ),
                      ),
                      _DealPreviewCard(
                        title: 'Dyrnak + kirpik 10%',
                        onTap: () => Navigator.push(context, fadeSlideRoute(const DealsScreen())),
                        showBadge: false,
                        gradientIndex: 2,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Maslahat berilýän ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                  child: Semantics(
                    label: 'Maslahat berilýän salonlar',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(context, tt, 'Maslahat berilýän'),
                        const SizedBox(height: 2),
                        Text(
                          'Saýlanan salonlar',
                          style: tt.bodySmall?.copyWith(color: kTextTertiary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _salonRow(salons, ref, context, cardW, false),

              // ── Meşhur ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                  child: Semantics(
                    label: 'Meşhur salonlar',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(context, tt, 'Meşhur'),
                        const SizedBox(height: 2),
                        Text(
                          'Ters tertipde',
                          style: tt.bodySmall?.copyWith(color: kTextTertiary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _salonRow(salons, ref, context, cardW, true),

              // ── Täze Parla-da ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                  child: Semantics(
                    label: 'Täze Parla-da goşulan salonlar',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(context, tt, 'Täze Parla-da'),
                        const SizedBox(height: 2),
                        Text(
                          'Saýlanan salonlar',
                          style: tt.bodySmall?.copyWith(color: kTextTertiary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _salonRow(salons, ref, context, cardW, false),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _upcomingBookingStrip(WidgetRef ref, BuildContext context, TextTheme tt) {
    final phone = ref.watch(userPhoneProvider);
    if (phone == null || phone.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    final bookingsAsync = ref.watch(myBookingsProvider);
    return bookingsAsync.when(
      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
      error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
      data: (bookings) {
        final now = DateTime.now();
        final upcoming = bookings
            .where((b) => b.slotAt.isAfter(now) && b.status == 'confirmed')
            .toList()
          ..sort((a, b) => a.slotAt.compareTo(b.slotAt));
        if (upcoming.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
        final b = upcoming.first;
        final dateStr = DateFormat('dd MMM, HH:mm').format(b.slotAt);
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Material(
              color: kPrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(kRadiusLg),
              child: InkWell(
                onTap: () => ref.read(selectedTabIndexProvider.notifier).state = 1,
                borderRadius: BorderRadius.circular(kRadiusLg),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: kPrimary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(kRadiusMd),
                        ),
                        child: const Icon(Icons.calendar_today_rounded, color: kPrimary, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Siziň geljekki bronyňyz', style: tt.labelMedium?.copyWith(color: kTextSecondary)),
                            const SizedBox(height: 2),
                            Text(b.salonName ?? 'Salon #${b.salonId}', style: tt.titleSmall),
                            if (b.serviceName != null) Text(b.serviceName!, style: tt.bodySmall?.copyWith(color: kTextSecondary)),
                            const SizedBox(height: 2),
                            Text(dateStr, style: tt.bodySmall?.copyWith(color: kPrimary, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: kPrimary),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _recentlyViewedRow(AsyncValue<List<Salon>> salons, WidgetRef ref, BuildContext context, double cardW) {
    final recentIds = ref.watch(recentViewedSalonIdsProvider);
    if (recentIds.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    return salons.when(
      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
      error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
      data: (allSalons) {
        final idToSalon = {for (var s in allSalons) s.id: s};
        final list = recentIds.map((id) => idToSalon[id]).whereType<Salon>().toList();
        if (list.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                child: Text(
                  'Soňky görülen salonlar',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w700, color: kTextPrimary),
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => SizedBox(
                    width: cardW,
                    child: _VenueCard(
                      salon: list[i],
                      onTap: () => Navigator.push(context, fadeSlideRoute(SalonDetailScreen(salonId: list[i].id))),
                      onFavouriteTap: () {
                        HapticFeedback.lightImpact();
                        ref.read(favouriteSalonsProvider.notifier).toggle(list[i].id);
                      },
                      isFavourite: ref.watch(favouriteSalonsProvider).contains(list[i].id),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
          height: 300,
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
        final location = ref.watch(selectedLocationProvider).trim().toLowerCase();
        var list = salons.where((s) {
          if (location.isEmpty) return true;
          if (s.address != null && s.address!.toLowerCase().contains(location)) return true;
          if (s.name.toLowerCase().contains(location)) return true;
          return false;
        }).toList();
        if (list.isEmpty) list = List.from(salons);
        if (reversed) list = list.reversed.toList();
        if (list.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.storefront_outlined, size: 48, color: kTextTertiary),
                    const SizedBox(height: 12),
                    Text(
                      'Bu bölümde häzir salon ýok',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kTextSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 300,
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
                  onFavouriteTap: () {
                    HapticFeedback.lightImpact();
                    ref.read(favouriteSalonsProvider.notifier).toggle(list[i].id);
                  },
                  isFavourite: ref.watch(favouriteSalonsProvider).contains(list[i].id),
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
    return Semantics(
      label: label,
      button: true,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.white,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
                    boxShadow: kShadowSm,
                  ),
                  child: Icon(icon, color: kPrimary, size: 26),
                ),
              ),
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

// ── Venue Card (Material+InkWell, ýürek animasiýa, semantics) ──

class _VenueCard extends StatelessWidget {
  final Salon salon;
  final VoidCallback onTap;
  final VoidCallback onFavouriteTap;
  final bool isFavourite;
  const _VenueCard({
    required this.salon,
    required this.onTap,
    required this.onFavouriteTap,
    required this.isFavourite,
  });

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

  String get _distanceKm {
    final km = (salon.id % 5 + 1) + (salon.id % 10) / 10.0;
    return '${km.toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Semantics(
      label: '${salon.name}, reýting $_rating, $_reviews syn, takmynan $_distanceKm. Bron etmek üçin basyň.',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        child: GestureDetector(
                          onTap: onFavouriteTap,
                          child: AnimatedScale(
                            scale: isFavourite ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
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
                              child: Icon(
                                isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                size: 18,
                                color: isFavourite ? Colors.red : kTextPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Text(
                salon.name,
                style: tt.titleSmall?.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: kTextPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              Tooltip(
                message: 'Reýting we uzaklyk nümunä maglumat',
                child: Row(
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
                    Text(
                      ' • ~$_distanceKm',
                      style: tt.bodySmall?.copyWith(fontSize: 13, color: kTextSecondary),
                    ),
                  ],
                ),
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
              const SizedBox(height: 8),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTap();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: kPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kPrimary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'Bron et',
                      style: tt.labelMedium?.copyWith(
                        color: kPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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

// ── Deal preview card (gradient üýtgeşigi + möhlet badge) ──

class _DealPreviewCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool showBadge;
  final String? badgeText;
  final int gradientIndex;
  const _DealPreviewCard({
    required this.title,
    required this.onTap,
    this.showBadge = false,
    this.badgeText,
    this.gradientIndex = 0,
  });

  List<Color> _gradientColors() {
    switch (gradientIndex % 3) {
      case 1:
        return [kPrimary.withValues(alpha: 0.22), kAccentLight.withValues(alpha: 0.08)];
      case 2:
        return [kSecondary.withValues(alpha: 0.2), kPrimary.withValues(alpha: 0.06)];
      default:
        return [kPrimary.withValues(alpha: 0.18), kPrimary.withValues(alpha: 0.08)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 260,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: _gradientColors(),
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
            if (showBadge && badgeText != null)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: kError,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText!,
                    style: tt.bodySmall?.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
