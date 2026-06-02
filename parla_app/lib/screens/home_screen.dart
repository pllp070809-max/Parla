import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/providers.dart';
import '../models/salon.dart';
import '../app_radius.dart';
import '../app_sizes.dart';
import '../app_spacing.dart';
import '../app_colors.dart';
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
    final tt = Theme.of(context).textTheme;

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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSizes.paddingHorizontal,
                      AppSpacing.l,
                      AppSizes.paddingHorizontal,
                      AppSpacing.s),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              'Siz üçin',
                              style: tt.displaySmall,
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
                        ],
                      ),
                      const SizedBox(height: 12),
                      const _HomeSearchBar(),
                    ],
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



              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _upcomingBookingStrip(WidgetRef ref, BuildContext context) {
    final tt = Theme.of(context).textTheme;
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
                          color: AppColors.kPrimary, size: 28),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Siziň geljekki bronyňyz',
                              style: tt.bodyMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(b.salonName ?? 'Salon #${b.salonId}',
                                style: tt.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
                            if (b.resolvedServiceNames.isNotEmpty)
                              Text(b.serviceSummary(maxNames: 2),
                                  style: tt.bodyMedium),
                            const SizedBox(height: 2),
                            Text(
                              dateStr,
                              style: tt.bodyMedium!.copyWith(
                                  color: kPrimary, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded, color: AppColors.kPrimary, size: 20),
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
    final tt = Theme.of(context).textTheme;
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
                  style: tt.titleLarge,
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
          style: Theme.of(context).textTheme.titleLarge,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, fadeSlideRoute(const SalonsListScreen()));
          },
          child: Text(
            'Ählisi',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: kPrimary),
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
    final tt = Theme.of(context).textTheme;
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
              style: tt.titleSmall,
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
    final tt = Theme.of(context).textTheme;
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
                        style: tt.titleMedium!.copyWith(fontWeight: FontWeight.w600),
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
                              style: tt.bodyMedium!.copyWith(
                                  color: kTextPrimary,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              ' ($_reviews)',
                              style: tt.bodyMedium,
                            ),
                            Text(
                              ' • ~$_distanceKm',
                              style: tt.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      if (salon.address != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          salon.address!,
                          style: tt.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (salon.category != null) ...[
                        const SizedBox(height: 1),
                        Text(
                          _catLabel(salon.category!),
                          style: tt.bodyMedium!.copyWith(color: kTextTertiary),
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

// ── Home Search Bar ──

class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Semantics(
      label: 'Ähli prosedurary gözle',
      button: true,
      child: Material(
        color: AppColors.kCardBg,
        borderRadius: BorderRadius.circular(100),
        elevation: 0,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(context, fadeSlideRoute(const SearchScreen()));
          },
          borderRadius: BorderRadius.circular(100),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.kCardBg,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.kBorder), // has gowşak border däl-de standart border
              boxShadow: AppColors.kShadowSm, // Uly kölegäniň ýerine standart we has asuda kölege
            ),
            padding: const EdgeInsets.only(left: 14, right: 6),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: AppColors.kTextPrimary,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ähli hyzmatlary gözle',
                    style: tt.bodyMedium?.copyWith(
                      color: AppColors.kInputHint,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimary, // Kapyalaşmagy üçin programmanyň esasy reňki (Primary)
                    borderRadius: BorderRadius.circular(100),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Gözleg',
                    style: tt.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
