import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/providers.dart';
import '../models/salon.dart';
import '../app_radius.dart';
import '../app_sizes.dart';
import '../app_spacing.dart';
import '../app_text_styles.dart';
import '../theme.dart';
import '../utils/salon_images.dart';
import '../widgets/shared_widgets.dart';
import 'salons_list_screen.dart';
import 'salon_detail_screen.dart';
import 'search_screen.dart';
import 'all_categories_screen.dart';
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
    const homeSectionGap = AppSizes.sectionGap;
    final salons = ref.watch(_featuredProvider);
    final cardW = AppSizes.cardWidth;

    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: SafeArea(
        child: RefreshIndicator(
          color: kPrimary,
          onRefresh: () async => ref.invalidate(_featuredProvider),
          child: CustomScrollView(
            slivers: [
              // ── Baş sahypa header: Siz üçin + bildirişler + gözleg ──
              SliverToBoxAdapter(
                child: SizedBox(
                  height: AppSizes.headerHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingHorizontal),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'Siz üçin',
                                style: AppTextStyles.headerTitle,
                              ),
                            ),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                      Icons.notifications_outlined,
                                      size: 24),
                                  onPressed: () => Navigator.push(
                                      context,
                                      fadeSlideRoute(
                                          const NotificationsScreen())),
                                  style: IconButton.styleFrom(
                                      foregroundColor: kTextPrimary),
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
                                        border: Border.fromBorderSide(
                                            BorderSide(
                                                color: kCardBg, width: 1)),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.push(context,
                                    fadeSlideRoute(const SearchScreen()));
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: kSurfaceBg,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: kBorder),
                                ),
                                child: const Center(
                                  child: Icon(Icons.search_rounded,
                                      size: 20, color: kPrimary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Siziň geljekki bronyňyz ──
              _upcomingBookingStrip(ref, context),

              // ── Soňky görülen salonlar ──
              _recentlyViewedRow(salons, ref, context, cardW),

              // ── Arzanladyşlar ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.paddingHorizontal,
                    homeSectionGap,
                    AppSizes.paddingHorizontal,
                    AppSizes.elementSpacing,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(context, 'Arzanladyşlar', toDeals: true),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: AppSizes.exploreCardHeight,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.only(left: AppSizes.paddingHorizontal),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: AppSizes.elementSpacing),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: _DealPreviewCard(
                            title: 'Ilkinji zyýaretde 20%',
                            onTap: () => Navigator.push(
                                context, fadeSlideRoute(const DealsScreen())),
                            showBadge: true,
                            badgeText: '2 gün',
                            gradientIndex: 0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: AppSizes.elementSpacing),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: _DealPreviewCard(
                            title: 'Massage paketi 15%',
                            onTap: () => Navigator.push(
                                context, fadeSlideRoute(const DealsScreen())),
                            showBadge: false,
                            gradientIndex: 1,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: _DealPreviewCard(
                          title: 'Dyrnak + kirpik 10%',
                          onTap: () => Navigator.push(
                              context, fadeSlideRoute(const DealsScreen())),
                          showBadge: false,
                          gradientIndex: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Maslahat berilýän ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.paddingHorizontal,
                    homeSectionGap,
                    AppSizes.paddingHorizontal,
                    AppSizes.elementSpacing,
                  ),
                  child: Semantics(
                    label: 'Maslahat berilýän salonlar',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(context, 'Maslahat berilýän'),
                      ],
                    ),
                  ),
                ),
              ),
              _salonRow(salons, ref, context, cardW, false),

              // ── Meşhur ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.paddingHorizontal,
                    homeSectionGap,
                    AppSizes.paddingHorizontal,
                    AppSizes.elementSpacing,
                  ),
                  child: Semantics(
                    label: 'Meşhur salonlar',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(context, 'Meşhur'),
                      ],
                    ),
                  ),
                ),
              ),
              _salonRow(salons, ref, context, cardW, true),

              // ── Täze Parla-da ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.paddingHorizontal,
                    homeSectionGap,
                    AppSizes.paddingHorizontal,
                    AppSizes.elementSpacing,
                  ),
                  child: Semantics(
                    label: 'Täze Parla-da goşulan salonlar',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(context, 'Täze Parla-da'),
                      ],
                    ),
                  ),
                ),
              ),
              _salonRow(salons, ref, context, cardW, false),

              // ── Top categories ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.paddingHorizontal,
                    homeSectionGap,
                    AppSizes.paddingHorizontal,
                    AppSizes.elementSpacing,
                  ),
                  child: _sectionHeader(context, 'Esasy kategoriýalar',
                      toAllCategories: true),
                ),
              ),

              // ── Category circles + sag tarap fade (scroll görkezijisi) ──
              SliverToBoxAdapter(
                child: SizedBox(
                  height: AppSizes.categorySize + AppSizes.smallSpacing + 36,
                  child: Stack(
                    children: [
                      ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(
                            left: AppSizes.paddingHorizontal),
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: AppSpacing.xl),
                        itemBuilder: (_, i) {
                          final cat = _categories[i];
                          return _CategoryCircle(
                            label: cat.label,
                            icon: cat.icon,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.push(
                                context,
                                fadeSlideRoute(
                                    SalonsListScreen(category: cat.key)),
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
                                colors: [
                                  Colors.white.withValues(alpha: 0),
                                  Colors.white
                                ],
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
                                colors: [
                                  Colors.white.withValues(alpha: 0),
                                  Colors.white
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _upcomingBookingStrip(WidgetRef ref, BuildContext context) {
    final phone = ref.watch(userPhoneProvider);
    if (phone == null || phone.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
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
        if (upcoming.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        final b = upcoming.first;
        final dateStr = DateFormat('dd MMM, HH:mm').format(b.slotAt);
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingHorizontal,
              AppSpacing.m,
              AppSizes.paddingHorizontal,
              0,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () =>
                    ref.read(selectedTabIndexProvider.notifier).state = 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingHorizontal,
                    vertical: AppSpacing.s,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          color: kPrimary, size: 28),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Siziň geljekki bronyňyz',
                              style: AppTextStyles.cardMeta
                                  .copyWith(color: kTextSecondary),
                            ),
                            const SizedBox(height: 2),
                            Text(b.salonName ?? 'Salon #${b.salonId}',
                                style: AppTextStyles.cardTitle),
                            if (b.serviceName != null)
                              Text(b.serviceName!,
                                  style: AppTextStyles.cardMeta
                                      .copyWith(color: kTextSecondary)),
                            const SizedBox(height: 2),
                            Text(
                              dateStr,
                              style: AppTextStyles.cardMeta.copyWith(
                                  color: kPrimary, fontWeight: FontWeight.w600),
                            ),
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

  Widget _recentlyViewedRow(AsyncValue<List<Salon>> salons, WidgetRef ref,
      BuildContext context, double cardW) {
    final recentIds = ref.watch(recentViewedSalonIdsProvider);
    if (recentIds.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return salons.when(
      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
      error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
      data: (allSalons) {
        final idToSalon = {for (var s in allSalons) s.id: s};
        final list =
            recentIds.map((id) => idToSalon[id]).whereType<Salon>().toList();
        if (list.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.paddingHorizontal,
                  AppSizes.sectionGap,
                  AppSizes.paddingHorizontal,
                  AppSizes.elementSpacing,
                ),
                child: Text(
                  'Soňky görülen salonlar',
                  style: AppTextStyles.sectionTitle,
                ),
              ),
              SizedBox(
                height: AppSizes.cardHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.only(left: AppSizes.paddingHorizontal),
                  itemCount: list.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSizes.elementSpacing),
                  itemBuilder: (_, i) => SizedBox(
                    width: cardW,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: _VenueCard(
                        salon: list[i],
                        onTap: () => Navigator.push(
                            context,
                            fadeSlideRoute(
                                SalonDetailScreen(salonId: list[i].id))),
                        onFavouriteTap: () {
                          HapticFeedback.lightImpact();
                          ref
                              .read(favouriteSalonsProvider.notifier)
                              .toggle(list[i].id);
                        },
                        isFavourite: ref
                            .watch(favouriteSalonsProvider)
                            .contains(list[i].id),
                      ),
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

  Widget _sectionHeader(BuildContext context, String title,
      {bool toAllCategories = false, bool toDeals = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.sectionTitle,
        ),
        GestureDetector(
          onTap: () {
            if (toAllCategories) {
              Navigator.push(
                  context, fadeSlideRoute(const AllCategoriesScreen()));
            } else if (toDeals) {
              Navigator.push(context, fadeSlideRoute(const DealsScreen()));
            } else {
              Navigator.push(context, fadeSlideRoute(const SalonsListScreen()));
            }
          },
          child: Text(
            'Ählisi',
            style: AppTextStyles.sectionLink,
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
          height: AppSizes.cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: AppSizes.paddingHorizontal),
            itemCount: 3,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppSizes.elementSpacing),
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
        final location =
            ref.watch(selectedLocationProvider).trim().toLowerCase();
        var list = salons.where((s) {
          if (location.isEmpty) {
            return true;
          }
          if (s.address != null && s.address!.toLowerCase().contains(location)) {
            return true;
          }
          if (s.name.toLowerCase().contains(location)) {
            return true;
          }
          return false;
        }).toList();
        if (list.isEmpty) list = List.from(salons);
        if (reversed) list = list.reversed.toList();
        if (list.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingHorizontal,
                vertical: AppSpacing.s,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.storefront_outlined,
                        size: 48, color: kTextTertiary),
                    const SizedBox(height: AppSizes.elementSpacing),
                    Text(
                      'Bu bölümde häzir salon ýok',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: kTextSecondary),
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
            height: AppSizes.cardHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: AppSizes.paddingHorizontal),
              itemCount: list.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSizes.elementSpacing),
              itemBuilder: (_, i) => SizedBox(
                width: cardW,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: _VenueCard(
                    salon: list[i],
                    onTap: () => Navigator.push(
                      context,
                      fadeSlideRoute(SalonDetailScreen(salonId: list[i].id)),
                    ),
                    onFavouriteTap: () {
                      HapticFeedback.lightImpact();
                      ref
                          .read(favouriteSalonsProvider.notifier)
                          .toggle(list[i].id);
                    },
                    isFavourite:
                        ref.watch(favouriteSalonsProvider).contains(list[i].id),
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
  const _CategoryCircle(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: SizedBox(
        width: AppSizes.categoryColumnWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: kCardBg,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                customBorder: const CircleBorder(),
                child: Container(
                  width: AppSizes.categorySize,
                  height: AppSizes.categorySize,
                  decoration: const BoxDecoration(
                    color: kPrimarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: kPrimary, size: 31),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.smallSpacing),
            Text(
              label,
              style: AppTextStyles.categoryLabel,
              textAlign: TextAlign.center,
              maxLines: 1,
              softWrap: false,
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
    final radius = BorderRadius.circular(AppRadius.m);
    return Semantics(
      label:
          '${salon.name}, reýting $_rating, $_reviews syn, takmynan $_distanceKm. Bron etmek üçin basyň.',
      button: true,
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.cardImageHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.m),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          salonMainImage(salon),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        ),
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
                                decoration: const BoxDecoration(
                                  color: kCardBg,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFavourite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  size: 18,
                                  color: isFavourite ? kError : kTextPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      0, 10, AppSpacing.l, AppSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        salon.name,
                        style: AppTextStyles.cardTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Tooltip(
                        message: 'Reýting we uzaklyk nümunä maglumat',
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 15, color: kStar),
                            const SizedBox(width: 4),
                            Text(
                              _rating.toStringAsFixed(1),
                              style: AppTextStyles.cardMeta.copyWith(
                                  color: kTextPrimary,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              ' ($_reviews)',
                              style: AppTextStyles.cardMeta
                                  .copyWith(color: kTextSecondary),
                            ),
                            Text(
                              ' • ~$_distanceKm',
                              style: AppTextStyles.cardMeta
                                  .copyWith(color: kTextSecondary),
                            ),
                          ],
                        ),
                      ),
                      if (salon.address != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          salon.address!,
                          style: AppTextStyles.cardMeta
                              .copyWith(color: kTextSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (salon.category != null) ...[
                        const SizedBox(height: 1),
                        Text(
                          _catLabel(salon.category!),
                          style: AppTextStyles.cardMeta
                              .copyWith(color: kTextTertiary),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
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
        return [
          kPrimary.withValues(alpha: 0.22),
          kAccentLight.withValues(alpha: 0.08)
        ];
      case 2:
        return [
          kSecondary.withValues(alpha: 0.2),
          kPrimary.withValues(alpha: 0.06)
        ];
      default:
        return [
          kPrimary.withValues(alpha: 0.18),
          kPrimary.withValues(alpha: 0.08)
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgeStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.m),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: AppSizes.cardWidth,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingHorizontal, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: _gradientColors(),
                ),
                borderRadius: BorderRadius.circular(AppRadius.m),
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
                    child: const Icon(Icons.local_offer_rounded,
                        color: kPrimary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.cardTitle,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: kError,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText!,
                    style: badgeStyle,
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
        SkeletonBox(
            width: double.infinity,
            height: AppSizes.cardImageHeight,
            radius: AppRadius.m),
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
