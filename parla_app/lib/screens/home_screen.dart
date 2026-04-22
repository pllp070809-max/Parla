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
import 'notifications_screen.dart';


final _featuredProvider = FutureProvider<List<Salon>>((ref) {
  return ref.read(apiServiceProvider).getSalons();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _categories = [
    _Cat('Saç salony', 'images/BOLUMLER/SAC_SALONY.jpg', 'salon'),
    _Cat('Barberhana', 'images/BOLUMLER/BARBERHANA.png', 'barber'),
    _Cat('Dyrnak', 'images/BOLUMLER/DYRNAK.png', 'salon'),
    _Cat('Kirpik', 'images/BOLUMLER/KIRPIK.png', 'gözellik'),
    _Cat('Makiýaž', 'images/BOLUMLER/MAKIYAZ.png', 'gözellik'),
    _Cat('Spa', 'images/BOLUMLER/SPA.png', 'spa'),
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
                            IconButton(
                              icon: const Icon(
                                Icons.notifications_none_rounded,
                                size: 26,
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                fadeSlideRoute(const NotificationsScreen()),
                              ),
                              style: IconButton.styleFrom(
                                foregroundColor: kTextSecondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                Navigator.push(context,
                                    fadeSlideRoute(const SearchScreen()));
                              },
                              icon: const Icon(
                                Icons.search_rounded,
                                size: 24,
                                color: Color(0xFF0E7490),
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



              // ── Maslahat berilýän ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.paddingHorizontal,
                    homeSectionGap,
                    AppSizes.paddingHorizontal,
                    AppSizes.sectionTitleToCardGap,
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
                    AppSizes.sectionTitleToCardGap,
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
                    AppSizes.sectionTitleToCardGap,
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
                    24, // As per UI spec: 24px margin bottom below header
                  ),
                  child: Text(
                    'Esasy kategoriýalar',
                    style: AppTextStyles.sectionTitle,
                  ),
                ),
              ),

              // ── Category Grid ──
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingHorizontal),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: AppSizes.sectionGap,
                    crossAxisSpacing: 24,
                    mainAxisExtent: 142, // 96 image + 12 gap + label space
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final cat = _categories[index];
                      return _CategoryCircle(
                        label: cat.label,
                        imagePath: cat.imagePath,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.push(
                            context,
                            fadeSlideRoute(SalonsListScreen(category: cat.key)),
                          );
                        },
                      );
                    },
                    childCount: _categories.length,
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
                      const Icon(Icons.calendar_month_rounded,
                          color: Color(0xFF0E7490), size: 28),
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
                            if (b.resolvedServiceNames.isNotEmpty)
                              Text(b.serviceSummary(maxNames: 2),
                                  style: AppTextStyles.cardMeta
                                      .copyWith(color: kTextSecondary)),
                            const SizedBox(height: 2),
                            Text(
                              dateStr,
                              style: AppTextStyles.cardMeta.copyWith(
                                  color: const Color(0xFF0E7490), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded, color: Color(0xFF0E7490), size: 20),
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
                  AppSizes.sectionTitleToCardGap,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingHorizontal,
                  ),
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

  Widget _sectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.sectionTitle,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, fadeSlideRoute(const SalonsListScreen()));
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingHorizontal,
            ),
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
                    Icon(Icons.storefront_rounded,
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
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingHorizontal,
              ),
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
  final String imagePath;
  final String key;
  const _Cat(this.label, this.imagePath, this.key);
}

// ── Category Circle (Fresha style) ──

class _CategoryCircle extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;
  const _CategoryCircle(
      {required this.label, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: kCardBg,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: kCardBg),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: onTap,
                      customBorder: const CircleBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 104,
            child: Text(
              label,
              style: AppTextStyles.categoryLabel,
              textAlign: TextAlign.center,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
