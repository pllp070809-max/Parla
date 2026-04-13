import 'dart:async' show unawaited;
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderAbstractViewport;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../providers/providers.dart';
import '../app_radius.dart';
import '../app_spacing.dart';
import '../models/salon.dart';
import '../theme.dart';
import '../widgets/shared_widgets.dart';
import '../utils/launch_utils.dart';
import '../utils/salon_images.dart';
import 'booking_screen.dart';
import 'salon_gallery_screen.dart';
import 'salon_staff_screen.dart';

// ── Mock data ──

const _kMockRating = 4.5;
const _kMockReviewCount = 18;
const _kMockDescription =
    'Biziň salonymyz 2018-nji ýyldan bäri müşderilere ýokary hilli gözellik hyzmatlary hödürleýär. '
    'Tejribeli ussalar, arassa gurşaw we myhmansöýer hyzmat. Bize gelip görüň!';

const _kMockStaff = [
  {
    'name': 'Aýgözel',
    'role': 'Saç ussasy',
    'rating': 5.0,
    'imagePath': 'images/1.webp',
  },
  {
    'name': 'Mähri',
    'role': 'Dyrnak ussasy',
    'rating': 5.0,
    'imagePath': 'images/2.jpg',
  },
  {
    'name': 'Gunça',
    'role': 'Makiýaž ussasy',
    'rating': 5.0,
    'imagePath': 'images/7.webp',
  },
  {
    'name': 'Säher',
    'role': 'Creative director',
    'rating': 5.0,
    'imagePath': 'images/9.jpg',
  },
];

const _kOpeningHours = [
  {'day': 'Duşenbe', 'hours': '10:00 - 21:00'},
  {'day': 'Sişenbe', 'hours': '10:00 - 21:00'},
  {'day': 'Çarşenbe', 'hours': '10:00 - 21:00'},
  {'day': 'Penşenbe', 'hours': '10:00 - 21:00'},
  {'day': 'Anna', 'hours': '10:00 - 21:00'},
  {'day': 'Şenbe', 'hours': '10:00 - 21:00'},
  {'day': 'Ýekşenbe', 'hours': '10:00 - 18:00'},
];

const _kAdditionalInfo = [
  {'icon': Icons.verified_rounded, 'label': 'Tassyklama dessine'},
  {'icon': Icons.pets_rounded, 'label': 'Haýwan kabul edilýär'},
  {'icon': Icons.child_friendly_rounded, 'label': 'Çagalar üçin amatly'},
];

const _kDetailDivider = Color(0xFFF0F1F5);
const _kDetailChipLavenderBg = Color(0xFFF2EDFF);
const _kDetailChipLavenderFg = Color(0xFF6F5CC2);
const _kDetailChipMintBg = Color(0xFFEAF8EF);
const _kDetailChipMintFg = Color(0xFF258A52);
const _kDetailButtonBg = Color(0xFF151517);
const _kDetailMeta = Color(0xFF8D8D98);

const _kDetailBadges = [
  (
    label: 'Maslahat berilýär',
    background: _kDetailChipLavenderBg,
    foreground: _kDetailChipLavenderFg,
  ),
  (
    label: 'Arzanladyş',
    background: _kDetailChipMintBg,
    foreground: _kDetailChipMintFg,
  ),
];

class _SalonStatusInfo {
  final bool isOpen;
  final String title;
  final String subtitle;

  const _SalonStatusInfo({
    required this.isOpen,
    required this.title,
    required this.subtitle,
  });
}

_SalonStatusInfo _mockStatusForNow([DateTime? now]) {
  final current = now ?? DateTime.now();
  final hours = _openingRangeForWeekday(current.weekday);
  final openAt = DateTime(
    current.year,
    current.month,
    current.day,
    hours.hour.hour,
    hours.hour.minute,
  );
  final closeAt = DateTime(
    current.year,
    current.month,
    current.day,
    hours.close.hour,
    hours.close.minute,
  );
  if (current.isBefore(openAt)) {
    return _SalonStatusInfo(
      isOpen: false,
      title: 'Ýapyk',
      subtitle: 'Irden ${_formatClock(openAt)}-da açylýar',
    );
  }
  if (current.isBefore(closeAt)) {
    return _SalonStatusInfo(
      isOpen: true,
      title: 'Açyk',
      subtitle: 'Bu gün ${_formatClock(closeAt)}-da ýapylýar',
    );
  }
  final nextDay = current.add(const Duration(days: 1));
  final nextOpenRange = _openingRangeForWeekday(nextDay.weekday);
  final nextOpenAt = DateTime(
    nextDay.year,
    nextDay.month,
    nextDay.day,
    nextOpenRange.hour.hour,
    nextOpenRange.hour.minute,
  );
  return _SalonStatusInfo(
    isOpen: false,
    title: 'Ýapyk',
    subtitle: 'Ertir ${_formatClock(nextOpenAt)}-da açylýar',
  );
}

({TimeOfDay hour, TimeOfDay close}) _openingRangeForWeekday(int weekday) {
  switch (weekday) {
    case DateTime.sunday:
      return (
        hour: const TimeOfDay(hour: 10, minute: 0),
        close: const TimeOfDay(hour: 18, minute: 0)
      );
    default:
      return (
        hour: const TimeOfDay(hour: 10, minute: 0),
        close: const TimeOfDay(hour: 21, minute: 0)
      );
  }
}

String _formatClock(DateTime time) {
  final hh = time.hour.toString().padLeft(2, '0');
  final mm = time.minute.toString().padLeft(2, '0');
  return '$hh:$mm';
}

TextStyle? _detailSectionTitleStyle(TextTheme tt) {
  return tt.titleLarge?.copyWith(
    fontWeight: FontWeight.w600,
    color: kTextPrimary,
    letterSpacing: -0.1,
  );
}

// ── Helpers ──

Future<LatLng?> _getUserLocation() async {
  try {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return null;
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      return null;
    }
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 5)),
    );
    return LatLng(pos.latitude, pos.longitude);
  } catch (_) {
    return null;
  }
}

// ═════════════════════════════════════════════
// Main screen
// ═════════════════════════════════════════════
class SalonDetailScreen extends ConsumerStatefulWidget {
  final int salonId;
  const SalonDetailScreen({super.key, required this.salonId});
  @override
  ConsumerState<SalonDetailScreen> createState() => _SalonDetailScreenState();
}

class _SalonDetailScreenState extends ConsumerState<SalonDetailScreen> {
  late Future<Salon> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = ref.read(apiServiceProvider).getSalonDetail(widget.salonId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Salon>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: kPrimary));
          }
          if (snap.hasError) {
            return ErrorRetryWidget(
                message: 'Salon ýüklenip bilmedi', onRetry: _load);
          }
          final salon = snap.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(recentViewedSalonIdsProvider.notifier).add(salon.id);
          });
          return _SalonDetailBody(salon: salon);
        },
      ),
    );
  }
}

// ═════════════════════════════════════════════
// Body — chip bar + scrollable sections
// ═════════════════════════════════════════════
class _SalonDetailBody extends StatefulWidget {
  final Salon salon;
  const _SalonDetailBody({required this.salon});
  @override
  State<_SalonDetailBody> createState() => _SalonDetailBodyState();
}

@immutable
class _StickyNavState {
  final double revealProgress;
  final int activeTab;

  const _StickyNavState({
    required this.revealProgress,
    required this.activeTab,
  });

  static const initial = _StickyNavState(revealProgress: 0, activeTab: 0);

  _StickyNavState copyWith({
    double? revealProgress,
    int? activeTab,
  }) {
    return _StickyNavState(
      revealProgress: revealProgress ?? this.revealProgress,
      activeTab: activeTab ?? this.activeTab,
    );
  }
}

class _StickyNavController extends ValueNotifier<_StickyNavState> {
  _StickyNavController() : super(_StickyNavState.initial);

  static const double _kProgressEpsilon = 0.001;

  bool _lockActiveTabFromScroll = false;
  int _latestRequestId = 0;

  void syncFromScroll({
    required double revealProgress,
    required int activeTab,
  }) {
    final progressChanged =
        (revealProgress - value.revealProgress).abs() > _kProgressEpsilon;
    final nextActiveTab =
        _lockActiveTabFromScroll ? value.activeTab : activeTab;
    final tabChanged = nextActiveTab != value.activeTab;
    if (!progressChanged && !tabChanged) return;

    value = value.copyWith(
      revealProgress: progressChanged ? revealProgress : value.revealProgress,
      activeTab: tabChanged ? nextActiveTab : value.activeTab,
    );
  }

  int beginManualTabScroll(int activeTab) {
    _lockActiveTabFromScroll = true;
    final requestId = ++_latestRequestId;
    if (value.activeTab != activeTab) {
      value = value.copyWith(activeTab: activeTab);
    }
    return requestId;
  }

  void finishManualTabScrollIfLatest(int requestId) {
    if (requestId != _latestRequestId) return;
    _lockActiveTabFromScroll = false;
  }
}

class _SalonDetailBodyState extends State<_SalonDetailBody> {
  final _scrollCtrl = ScrollController();
  final _stickyNavController = _StickyNavController();
  final _tabs = const ['Hyzmatlar', 'Topar', 'Portfolio', 'Barada'];
  int _heroPage = 0;

  final _sectionKeys = List.generate(4, (_) => GlobalKey());
  static const double _kStickyRevealStart = 12;
  static const double _kStickyRevealEnd = 78;
  static const double _kStickyTabHeight = 58;
  static const double _kStickyTopRowHeight = 64;
  static const double _kStickyChromeHeight =
      _kStickyTopRowHeight + _kStickyTabHeight;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    _stickyNavController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final root = context.findRenderObject();
    if (root == null) return;

    final stickyRawProgress = ((_scrollCtrl.offset - _kStickyRevealStart) /
            (_kStickyRevealEnd - _kStickyRevealStart))
        .clamp(0.0, 1.0);
    final stickyRevealVisualProgress =
        Curves.easeOutCubic.transform(stickyRawProgress);
    final safeTop = MediaQuery.of(context).padding.top;
    final sectionTriggerLine = safeTop +
        (ui.lerpDouble(
              140,
              _kStickyChromeHeight + 16,
              stickyRevealVisualProgress,
            ) ??
            140);

    int nextActiveTab = 0;
    for (int i = _sectionKeys.length - 1; i >= 0; i--) {
      final key = _sectionKeys[i];
      final ctx = key.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox;
        final pos = box.localToGlobal(Offset.zero, ancestor: root);
        if (pos.dy <= sectionTriggerLine) {
          nextActiveTab = i;
          break;
        }
      }
    }

    _stickyNavController.syncFromScroll(
      revealProgress: stickyRawProgress,
      activeTab: nextActiveTab,
    );
  }

  void _scrollToSection(int i) {
    unawaited(_scrollToSectionImpl(i));
  }

  void _unlockTabScrollIfLatest(int requestId) {
    if (!mounted) return;
    _stickyNavController.finishManualTabScrollIfLatest(requestId);
    _onScroll();
  }

  Future<void> _scrollToSectionImpl(int i) async {
    final requestId = _stickyNavController.beginManualTabScroll(i);
    final ctx = _sectionKeys[i].currentContext;
    if (ctx == null) {
      _unlockTabScrollIfLatest(requestId);
      return;
    }
    final renderObject = ctx.findRenderObject();
    if (renderObject == null) {
      _unlockTabScrollIfLatest(requestId);
      return;
    }
    final viewport = RenderAbstractViewport.of(renderObject);
    final target = viewport.getOffsetToReveal(renderObject, 0).offset;
    final safeTop = MediaQuery.of(context).padding.top;
    final adjusted = (target - safeTop - _kStickyChromeHeight - 14).clamp(
      _scrollCtrl.position.minScrollExtent,
      _scrollCtrl.position.maxScrollExtent,
    );
    try {
      await _scrollCtrl.animateTo(
        adjusted.toDouble(),
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    } finally {
      _unlockTabScrollIfLatest(requestId);
    }
  }

  void _openBooking({int? preselectedServiceId}) {
    Navigator.push(
        context,
        fadeSlideRoute(BookingScreen(
          salonId: widget.salon.id,
          salonName: widget.salon.name,
          services: widget.salon.services,
          preselectedServiceId: preselectedServiceId,
        )));
  }

  @override
  Widget build(BuildContext context) {
    final salon = widget.salon;
    final images = portfolioImages(salon);
    final minPrice = salon.services.isNotEmpty
        ? salon.services
            .map((s) => s.price ?? 0)
            .reduce((a, b) => a < b ? a : b)
        : 0;

    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollCtrl,
          slivers: [
            // ── Hero image ──
            SliverToBoxAdapter(
                child: _HeroSection(
              images: images,
              salon: salon,
              onPageChanged: (p) => setState(() => _heroPage = p),
              currentPage: _heroPage,
            )),

            // ── Info block ──
            SliverToBoxAdapter(child: _InfoBlock(salon: salon)),

            // ── Hyzmatlar ──
            SliverToBoxAdapter(
              child: Padding(
                key: _sectionKeys[0],
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.m,
                  AppSpacing.xl,
                  0,
                ),
                child: _ServicesSection(
                    salon: salon,
                    onBook: (svc) =>
                        _openBooking(preselectedServiceId: svc.id)),
              ),
            ),

            // ── Topar ──
            SliverToBoxAdapter(
              child: Padding(
                key: _sectionKeys[1],
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.xl,
                  AppSpacing.xl,
                  0,
                ),
                child: _TeamSection(salon: salon),
              ),
            ),

            // ── Portefolio ──
            SliverToBoxAdapter(
              child: Padding(
                key: _sectionKeys[2],
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl, 0, AppSpacing.xl, 0),
                child: _PortfolioSection(salon: salon, images: images),
              ),
            ),

            // ── Barada ──
            SliverToBoxAdapter(
              child: Padding(
                key: _sectionKeys[3],
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 0),
                child: _AboutSection(salon: salon),
              ),
            ),

            // ── Map ──
            if (salon.hasLocation)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 0),
                  child: _SalonMapSection(salon: salon),
                ),
              ),

            // ── Nearby ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 0),
                child: _NearbySalonsSection(currentSalon: salon),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),

        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: ValueListenableBuilder<_StickyNavState>(
            valueListenable: _stickyNavController,
            builder: (context, stickyNavState, _) {
              return IgnorePointer(
                ignoring: stickyNavState.revealProgress <= 0,
                child: RepaintBoundary(
                  child: _StickySectionNav(
                    key: const ValueKey('sticky-section-nav'),
                    topInset: MediaQuery.of(context).padding.top,
                    revealProgress: stickyNavState.revealProgress,
                    salonName: salon.name,
                    tabs: _tabs,
                    activeTab: stickyNavState.activeTab,
                    onTap: _scrollToSection,
                  ),
                ),
              );
            },
          ),
        ),

        Positioned.fill(
          child: ValueListenableBuilder<_StickyNavState>(
            valueListenable: _stickyNavController,
            builder: (context, stickyNavState, _) {
              return Stack(
                children: [
                  _UnifiedBackButtonOverlay(
                    revealProgress: stickyNavState.revealProgress,
                    onTap: () => Navigator.pop(context),
                  ),
                  _UnifiedShareButtonOverlay(
                    revealProgress: stickyNavState.revealProgress,
                    onTap: () {},
                  ),
                  _UnifiedFavoriteButtonOverlay(
                    revealProgress: stickyNavState.revealProgress,
                    onTap: () {},
                  ),
                ],
              );
            },
          ),
        ),

        // ── Bottom bar ──
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _BottomBookBar(
            minPrice: minPrice.toDouble(),
            salonName: salon.name,
            onBook: () => _openBooking(),
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════
// Hero image section
// ═════════════════════════════════════════════
class _HeroSection extends StatelessWidget {
  final List<String> images;
  final Salon salon;
  final ValueChanged<int> onPageChanged;
  final int currentPage;

  const _HeroSection(
      {required this.images,
      required this.salon,
      required this.onPageChanged,
      required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 286,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: onPageChanged,
            itemBuilder: (_, i) => Image.asset(
              images[i],
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                  color: kPrimary.withValues(alpha: 0.12),
                  child: const Center(
                      child: Icon(Icons.storefront_rounded,
                          size: 72, color: kPrimary))),
            ),
          ),

          // Gradient overlay
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 100,
            child: DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black38, Colors.transparent]))),
          ),

          // Page counter
          Positioned(
            bottom: 12,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(AppRadius.s)),
              child: Text('${currentPage + 1}/${images.length}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════
// Info block (name, rating, address, status)
// ═════════════════════════════════════════════
class _InfoBlock extends StatelessWidget {
  final Salon salon;
  const _InfoBlock({required this.salon});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final status = _mockStatusForNow();
    final statusColor = status.isOpen ? kSuccess : kError;
    return Container(
      width: double.infinity,
      color: kScaffoldBg,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.s,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            salon.name,
            style: tt.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: kTextPrimary,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: [
              Text(
                _kMockRating.toStringAsFixed(1),
                style: tt.bodyMedium?.copyWith(
                  color: kTextPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Icon(Icons.star_rounded, size: 16, color: kStar),
              Text(
                '($_kMockReviewCount syn)',
                style: tt.bodySmall?.copyWith(color: _kDetailMeta),
              ),
            ],
          ),
          if (salon.address != null) ...[
            const SizedBox(height: 8),
            Text(
              salon.address!,
              style: tt.bodyMedium?.copyWith(color: _kDetailMeta),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${status.title} • ${status.subtitle}',
                  style: tt.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _kDetailBadges
                .map(
                  (badge) => _InfoBadge(
                    label: badge.label,
                    background: badge.background,
                    foreground: badge.foreground,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: _kDetailDivider),
        ],
      ),
    );
  }
}

class _StickySectionNav extends StatelessWidget {
  final double topInset;
  final double revealProgress;
  final String salonName;
  final List<String> tabs;
  final int activeTab;
  final ValueChanged<int> onTap;

  const _StickySectionNav({
    super.key,
    required this.topInset,
    required this.revealProgress,
    required this.salonName,
    required this.tabs,
    required this.activeTab,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    double segmentProgress(double start, double end, Curve curve) {
      final normalized =
          ((revealProgress - start) / (end - start)).clamp(0.0, 1.0).toDouble();
      return curve.transform(normalized);
    }

    final headerSurfaceProgress =
        segmentProgress(0.08, 0.52, Curves.easeOutCubic);
    final headerSurfaceOffsetY =
        ui.lerpDouble(-8, 0, headerSurfaceProgress) ?? 0;
    final headerContentProgress =
        segmentProgress(0.12, 0.56, Curves.easeOutCubic);
    final headerContentOffsetY =
        ui.lerpDouble(-10, 0, headerContentProgress) ?? 0;
    final tabSurfaceProgress = segmentProgress(0.48, 0.82, Curves.easeOutCubic);
    final tabSurfaceOffsetY = ui.lerpDouble(-10, 0, tabSurfaceProgress) ?? 0;
    final tabRowProgress = segmentProgress(0.54, 1.0, Curves.easeOutQuart);
    final tabRowOffsetY = ui.lerpDouble(-14, 0, tabRowProgress) ?? 0;
    final stickyNavOpacity =
        math.max(headerSurfaceProgress, tabSurfaceProgress);
    final navOffsetY = ui.lerpDouble(-8, 0, stickyNavOpacity) ?? 0;
    return Material(
      color: Colors.transparent,
      child: Transform.translate(
        offset: Offset(0, navOffsetY),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              key: const ValueKey('sticky-header-surface-opacity'),
              opacity: headerSurfaceProgress,
              child: Transform.translate(
                offset: Offset(0, headerSurfaceOffsetY),
                child: Container(
                  decoration: BoxDecoration(
                    color: kScaffoldBg,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha:
                              ui.lerpDouble(0, 0.035, headerSurfaceProgress) ??
                                  0.035,
                        ),
                        blurRadius:
                            ui.lerpDouble(8, 18, headerSurfaceProgress) ?? 18,
                        offset: Offset(
                            0, ui.lerpDouble(2, 6, headerSurfaceProgress) ?? 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: topInset),
                    child: Opacity(
                      key: const ValueKey('sticky-top-row-opacity'),
                      opacity: headerContentProgress,
                      child: Transform.translate(
                        offset: Offset(0, headerContentOffsetY),
                        child: SizedBox(
                          height: _SalonDetailBodyState._kStickyTopRowHeight,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 92),
                                  child: Text(
                                    salonName,
                                    key: const ValueKey('sticky-salon-title'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: tt.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 21,
                                      height: 1.1,
                                      letterSpacing: -0.5,
                                      color: kTextPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Row(
                                    children: [
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Opacity(
              key: const ValueKey('sticky-tab-surface-opacity'),
              opacity: tabSurfaceProgress,
              child: Transform.translate(
                offset: Offset(0, tabSurfaceOffsetY),
                child: Container(
                  decoration: const BoxDecoration(
                    color: kScaffoldBg,
                    border: Border(
                      bottom: BorderSide(color: _kDetailDivider),
                    ),
                  ),
                  child: Opacity(
                    key: const ValueKey('sticky-section-nav-opacity'),
                    opacity: stickyNavOpacity,
                    child: Opacity(
                      key: const ValueKey('sticky-tab-row-opacity'),
                      opacity: tabRowProgress,
                      child: Transform.translate(
                        offset: Offset(0, tabRowOffsetY),
                        child: IgnorePointer(
                          ignoring: tabRowProgress < 0.95,
                          child: SizedBox(
                            height: _SalonDetailBodyState._kStickyTabHeight,
                            child: ListView.separated(
                              key: const ValueKey('sticky-tabs-scroll'),
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xl,
                              ),
                              itemCount: tabs.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 28),
                              itemBuilder: (_, i) {
                                final sel = i == activeTab;
                                final indicatorWidth = math
                                    .max(36.0,
                                        math.min(86.0, tabs[i].length * 8.5))
                                    .toDouble();
                                return Semantics(
                                  button: true,
                                  selected: sel,
                                  child: GestureDetector(
                                    key: ValueKey('sticky-tab-$i'),
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      onTap(i);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            tabs[i],
                                            style: tt.titleLarge?.copyWith(
                                              fontSize: 18,
                                              fontWeight: sel
                                                  ? FontWeight.w700
                                                  : FontWeight.w600,
                                              letterSpacing: -0.35,
                                              height: 1.1,
                                              color: sel
                                                  ? kTextPrimary
                                                  : _kDetailMeta,
                                            ),
                                          ),
                                          const SizedBox(height: 11),
                                          AnimatedContainer(
                                            key: sel
                                                ? ValueKey(
                                                    'sticky-tab-indicator-$i')
                                                : null,
                                            duration: const Duration(
                                                milliseconds: 220),
                                            curve: Curves.easeOutCubic,
                                            height: 3,
                                            width: sel ? indicatorWidth : 0,
                                            decoration: BoxDecoration(
                                              color: kTextPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
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

class _UnifiedTopActionButtonOverlay extends StatelessWidget {
  final double revealProgress;
  final VoidCallback onTap;
  final IconData icon;
  final double? left;
  final double? right;
  final Key? buttonKey;

  const _UnifiedTopActionButtonOverlay({
    this.buttonKey,
    required this.revealProgress,
    required this.onTap,
    required this.icon,
    this.left,
    this.right,
  }) : assert((left == null) != (right == null));

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final raw = revealProgress.clamp(0.0, 1.0);
    final p = raw <= 0.3
        ? Curves.easeInOut.transform(raw / 0.3) * 0.3
        : 0.3 + Curves.easeOutCubic.transform((raw - 0.3) / 0.7) * 0.7;
    final backgroundColor = Color.lerp(
      Colors.white.withValues(alpha: 0.96),
      Colors.white.withValues(alpha: 0.0),
      p,
    );
    final shadowAlpha = ui.lerpDouble(0.12, 0.0, p) ?? 0.0;
    final shadowBlur = ui.lerpDouble(10, 0, p) ?? 0.0;
    final shadowYOffset = ui.lerpDouble(3, 0, p) ?? 0.0;
    return Positioned(
      left: left,
      right: right,
      top: safeTop + 15,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: Ink(
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: shadowAlpha > 0
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: shadowAlpha),
                        blurRadius: shadowBlur,
                        offset: Offset(0, shadowYOffset),
                      ),
                    ]
                  : null,
            ),
            child: InkWell(
              key: buttonKey,
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: Center(
                child: Icon(
                  icon,
                  color: kTextPrimary,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UnifiedBackButtonOverlay extends StatelessWidget {
  final double revealProgress;
  final VoidCallback onTap;

  const _UnifiedBackButtonOverlay({
    required this.revealProgress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: false,
      child: Stack(
        children: [
          _UnifiedTopActionButtonOverlay(
            revealProgress: revealProgress,
            onTap: onTap,
            icon: Icons.arrow_back_rounded,
            left: AppSpacing.m,
            buttonKey: const ValueKey('unified-back-button'),
          ),
        ],
      ),
    );
  }
}

class _UnifiedShareButtonOverlay extends StatelessWidget {
  final double revealProgress;
  final VoidCallback onTap;

  const _UnifiedShareButtonOverlay({
    required this.revealProgress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: false,
      child: Stack(
        children: [
          _UnifiedTopActionButtonOverlay(
            revealProgress: revealProgress,
            onTap: onTap,
            icon: Icons.share_rounded,
            right: AppSpacing.m + 31 + AppSpacing.s,
            buttonKey: const ValueKey('unified-share-button'),
          ),
        ],
      ),
    );
  }
}

class _UnifiedFavoriteButtonOverlay extends StatelessWidget {
  final double revealProgress;
  final VoidCallback onTap;

  const _UnifiedFavoriteButtonOverlay({
    required this.revealProgress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: false,
      child: Stack(
        children: [
          _UnifiedTopActionButtonOverlay(
            revealProgress: revealProgress,
            onTap: onTap,
            icon: Icons.favorite_border_rounded,
            right: AppSpacing.m - 5,
            buttonKey: const ValueKey('unified-favorite-button'),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════
// Services section
// ═════════════════════════════════════════════
class _ServicesSection extends StatefulWidget {
  final Salon salon;
  final ValueChanged<Service> onBook;
  const _ServicesSection({required this.salon, required this.onBook});

  @override
  State<_ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<_ServicesSection> {
  static const int _initialVisibleCount = 5;

  /// Salonda görünjek tertip; API-den täze açar gelende aşakda goşulýar.
  static const List<String> _categoryKeyOrder = [
    'haircut',
    'color',
    'beard',
    'styling',
    'treatment',
    'nails',
    'spa',
    'brows',
    'wax',
    'massage',
  ];

  static const Map<String, String> _categoryLabels = {
    'haircut': 'Saç kesim',
    'color': 'Saç boýag',
    'beard': 'Sakal',
    'styling': 'Ustilleme',
    'treatment': 'Bejeriş',
    'nails': 'Dyrnak',
    'spa': 'Spa',
    'brows': 'Göz we gaş',
    'wax': 'Depilýasiýa',
    'massage': 'Massage',
  };

  bool _showAll = false;
  String _selectedCategoryKey = 'all';

  static List<String> _categoryKeysForSalon(List<Service> services) {
    final present =
        services.map((s) => s.categoryKey).whereType<String>().toSet();
    final ordered = <String>[];
    for (final k in _categoryKeyOrder) {
      if (present.contains(k)) ordered.add(k);
    }
    final rest = present.where((k) => !ordered.contains(k)).toList()..sort();
    ordered.addAll(rest);
    return ordered;
  }

  static String _labelForCategoryKey(String key) {
    if (key == 'all') return 'Hemmesi';
    return _categoryLabels[key] ?? key;
  }

  @override
  void didUpdateWidget(covariant _ServicesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final keys = _categoryKeysForSalon(widget.salon.services);
    if (_selectedCategoryKey != 'all' && !keys.contains(_selectedCategoryKey)) {
      _selectedCategoryKey = 'all';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final allServices = widget.salon.services;
    final categoryKeysRow = _categoryKeysForSalon(allServices);
    final filteredServices = _selectedCategoryKey == 'all'
        ? allServices
        : allServices
            .where((s) => s.categoryKey == _selectedCategoryKey)
            .toList();
    final selectedCategoryLabel = _labelForCategoryKey(_selectedCategoryKey);
    final display = _showAll
        ? filteredServices
        : filteredServices.take(_initialVisibleCount).toList();
    final showViewAll = filteredServices.length > _initialVisibleCount;
    final content = <Widget>[
      Text(
        'Hyzmatlar',
        key: const ValueKey('section-title-services'),
        style: _detailSectionTitleStyle(tt),
      ),
      const SizedBox(height: 18),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            'all',
            ...categoryKeysRow,
          ].map((categoryKey) {
            final selected = categoryKey == _selectedCategoryKey;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(
                  begin: selected ? 0.98 : 1.0,
                  end: selected ? 1.0 : 0.98,
                ),
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () {
                      if (_selectedCategoryKey == categoryKey) return;
                      setState(() {
                        _selectedCategoryKey = categoryKey;
                        _showAll = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      height: 38,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: selected ? Colors.black : Colors.transparent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _labelForCategoryKey(categoryKey),
                        style: tt.labelLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: selected ? Colors.white : kTextSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      const SizedBox(height: 10),
    ];

    if (filteredServices.isEmpty) {
      content.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            _selectedCategoryKey == 'all'
                ? 'Bu bölümde hyzmat ýok'
                : '$selectedCategoryLabel kategoriýasynda hyzmat ýok',
            style: tt.bodyMedium?.copyWith(color: _kDetailMeta),
          ),
        ),
      );
    } else {
      for (int i = 0; i < display.length; i++) {
        final svc = display[i];
        content.add(
          Column(
            children: [
              if (i > 0) const Divider(height: 1, color: _kDetailDivider),
              _ServiceRow(service: svc, onBook: () => widget.onBook(svc)),
            ],
          ),
        );
      }
      if (showViewAll) {
        content.addAll([
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => setState(() => _showAll = !_showAll),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: kPrimary),
                foregroundColor: kTextPrimary,
                backgroundColor: kCardBg,
                shape: const StadiumBorder(),
                elevation: 0,
                minimumSize: const Size.fromHeight(42),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: 10,
                ),
                textStyle:
                    tt.labelMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              child: Text(_showAll ? 'Az görkez' : 'Hemmesi'),
            ),
          ),
        ]);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content,
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final Service service;
  final VoidCallback onBook;
  const _ServiceRow({required this.service, required this.onBook});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: kTextPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${service.durationMinutes} min',
                  style: tt.labelSmall?.copyWith(
                    color: _kDetailMeta,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${service.price?.toStringAsFixed(0) ?? '?'} TMT',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: kTextPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: OutlinedButton(
              onPressed: onBook,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: kPrimary),
                foregroundColor: kTextPrimary,
                backgroundColor: kCardBg,
                shape: const StadiumBorder(),
                minimumSize: const Size(118, 38),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                textStyle: tt.labelMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: kTextPrimary,
                ),
              ),
              child: const Text('Bron et'),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════
// Team section
// ═════════════════════════════════════════════
class _TeamSection extends StatelessWidget {
  final Salon salon;
  const _TeamSection({required this.salon});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Topar',
              key: const ValueKey('section-title-team'),
              style: _detailSectionTitleStyle(tt),
            ),
            const Spacer(),
            TextButton(
              key: const ValueKey('team-see-all'),
              onPressed: () {
                Navigator.push(
                  context,
                  fadeSlideRoute(SalonStaffScreen(salonName: salon.name)),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: _kDetailMeta,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Ählisi',
                style: tt.labelMedium?.copyWith(
                  color: _kDetailMeta,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 158,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: AppSpacing.s),
            itemCount: _kMockStaff.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final s = _kMockStaff[i];
              final name = (s['name'] as String).toUpperCase();
              final role = (s['role'] as String).toUpperCase();
              final imagePath = s['imagePath'] as String;
              final rating = s['rating'] as double?;
              return SizedBox(
                width: 92,
                child: Column(
                  children: [
                    SizedBox(
                      width: 78,
                      height: 88,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: 78,
                            height: 78,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _kDetailDivider,
                                width: 1.2,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: kSurfaceBg,
                                alignment: Alignment.center,
                                child: Text(
                                  name[0],
                                  style: tt.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (rating != null)
                            Positioned(
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.pill,
                                  ),
                                  border: Border.all(
                                    color: _kDetailDivider,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 11,
                                      color: kStar,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      rating.toStringAsFixed(1),
                                      style: tt.labelSmall?.copyWith(
                                        color: kTextPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: tt.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: kTextPrimary,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      style: tt.labelSmall?.copyWith(
                        color: _kDetailMeta,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════
// Portfolio section
// ═════════════════════════════════════════════
class _PortfolioSection extends StatelessWidget {
  final Salon salon;
  final List<String> images;
  const _PortfolioSection({required this.salon, required this.images});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final totalCount = images.length;
    final showOverflowTile = totalCount > 9;
    final visibleCount = showOverflowTile ? 9 : math.min(9, totalCount);
    final hiddenCount = showOverflowTile ? totalCount - 8 : 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Portfolio',
              key: const ValueKey('section-title-portfolio'),
              style: _detailSectionTitleStyle(tt),
            ),
            const SizedBox(width: 6),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '$totalCount',
                style: tt.labelSmall?.copyWith(
                  color: _kDetailMeta,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (images.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Surat ýok',
              style: tt.bodyMedium?.copyWith(color: _kDetailMeta),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visibleCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (_, i) => ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.s),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    images[i],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: kSurfaceBg,
                      child: const Icon(Icons.image_not_supported_rounded),
                    ),
                  ),
                  if (showOverflowTile && i == visibleCount - 1)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.42),
                        alignment: Alignment.center,
                        child: Text(
                          '+$hiddenCount',
                          style: tt.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        key: ValueKey('portfolio-tile-$i'),
                        onTap: () => Navigator.push(
                          context,
                          fadeSlideRoute(
                            SalonGalleryScreen(salon: salon, initialIndex: i),
                          ),
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ═════════════════════════════════════════════
// About section
// ═════════════════════════════════════════════
class _AboutSection extends StatefulWidget {
  final Salon salon;
  const _AboutSection({required this.salon});
  @override
  State<_AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<_AboutSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Barada',
          key: const ValueKey('section-title-about'),
          style: _detailSectionTitleStyle(tt),
        ),
        const SizedBox(height: 18),
        // Description card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.l),
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(AppRadius.m),
            border: Border.all(color: kStickerOutline),
            boxShadow: kStickerShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _kMockDescription,
                style: tt.bodyMedium?.copyWith(height: 1.55),
                maxLines: _expanded ? null : 3,
                overflow: _expanded ? null : TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.s),
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(_expanded ? 'Az gör' : 'Doly oka',
                    style: tt.bodySmall?.copyWith(
                        color: kPrimary, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.l),

        // Opening hours
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.l),
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(AppRadius.m),
            border: Border.all(color: kStickerOutline),
            boxShadow: kStickerShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time_rounded,
                      size: 22, color: kPrimary),
                  const SizedBox(width: AppSpacing.s),
                  Text('Iş wagty',
                      style: _detailSectionTitleStyle(tt)),
                ],
              ),
              const SizedBox(height: AppSpacing.m),
              ..._kOpeningHours.map((h) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s),
                    child: Row(
                      children: [
                        Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                color: kSuccess, shape: BoxShape.circle)),
                        const SizedBox(width: AppSpacing.s),
                        SizedBox(
                            width: 100,
                            child: Text(h['day'] as String,
                                style: tt.bodyMedium
                                    ?.copyWith(color: kTextPrimary))),
                        Text(h['hours'] as String,
                            style:
                                tt.bodyMedium?.copyWith(color: kTextSecondary)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.l),

        // Additional info
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.l),
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(AppRadius.m),
            border: Border.all(color: kStickerOutline),
            boxShadow: kStickerShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      size: 22, color: kSuccess),
                  const SizedBox(width: AppSpacing.s),
                  Text('Goşmaça maglumat',
                      style: _detailSectionTitleStyle(tt)),
                ],
              ),
              const SizedBox(height: AppSpacing.m),
              ..._kAdditionalInfo.map((info) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s),
                    child: Row(
                      children: [
                        Icon(info['icon'] as IconData,
                            size: 20, color: kTextSecondary),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                            child: Text(info['label'] as String,
                                style: tt.bodyMedium
                                    ?.copyWith(color: kTextPrimary))),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════
// Nearby salons
// ═════════════════════════════════════════════
class _NearbySalonsSection extends StatelessWidget {
  final Salon currentSalon;
  const _NearbySalonsSection({required this.currentSalon});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on_rounded, size: 22, color: kPrimary),
            const SizedBox(width: AppSpacing.s),
            Text('Töwerekde salonlar',
                style: _detailSectionTitleStyle(tt)),
          ],
        ),
        const SizedBox(height: AppSpacing.m),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.m),
            itemBuilder: (_, i) {
              final images = portfolioImages(currentSalon);
              final imgIdx = (i + 1) % images.length;
              return Container(
                width: 170,
                decoration: BoxDecoration(
                  color: kCardBg,
                  borderRadius: BorderRadius.circular(AppRadius.m),
                  border: Border.all(color: kStickerOutline),
                  boxShadow: kStickerShadow,
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.asset(
                        images[imgIdx],
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                            color: kSurfaceBg,
                            child: const Icon(Icons.storefront_rounded)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.s),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ýakyndaky salon ${i + 1}',
                              style: tt.labelSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text(
                              '${(1.1 + i * 0.4).toStringAsFixed(1)} km · mock',
                              style: tt.labelSmall
                                  ?.copyWith(color: kTextTertiary)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════
// Bottom book bar
// ═════════════════════════════════════════════
class _BottomBookBar extends StatelessWidget {
  final double minPrice;
  final String salonName;
  final VoidCallback onBook;
  const _BottomBookBar(
      {required this.minPrice, required this.salonName, required this.onBook});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        border: const Border(top: BorderSide(color: _kDetailDivider)),
        boxShadow: kShadowUpMd,
      ),
      padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.m, AppSpacing.xl,
          MediaQuery.of(context).padding.bottom + AppSpacing.m),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${minPrice.toStringAsFixed(0)} TMT-dan',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: kTextPrimary,
                  ),
                ),
                Text(
                  salonName,
                  style: tt.bodySmall?.copyWith(color: _kDetailMeta),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: onBook,
            icon: const Icon(Icons.calendar_month_rounded, size: 18),
            label: const Text('Bron et'),
            style: FilledButton.styleFrom(
              backgroundColor: _kDetailButtonBg,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl, vertical: AppSpacing.m),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const _InfoBadge({
    required this.label,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: tt.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════
// Map section (kept from previous)
// ═════════════════════════════════════════════
List<Widget> _buildMapLayers(LatLng salonPoint, {LatLng? userLocation}) {
  return [
    TileLayer(
      urlTemplate:
          'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
      subdomains: const ['a', 'b', 'c', 'd'],
      userAgentPackageName: 'com.parla.app',
      maxZoom: 19,
    ),
    CircleLayer(circles: [
      CircleMarker(
          point: salonPoint,
          radius: 48,
          color: kPrimary.withValues(alpha: 0.08),
          borderColor: kPrimary.withValues(alpha: 0.2),
          borderStrokeWidth: 1.5),
    ]),
    if (userLocation != null) ...[
      MarkerLayer(markers: [
        Marker(
            point: userLocation,
            width: 28,
            height: 28,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF4285F4),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF4285F4).withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ]),
            )),
      ]),
      CircleLayer(circles: [
        CircleMarker(
            point: userLocation,
            radius: 24,
            color: const Color(0xFF4285F4).withValues(alpha: 0.08),
            borderColor: const Color(0xFF4285F4).withValues(alpha: 0.15),
            borderStrokeWidth: 1),
      ]),
    ],
    MarkerLayer(markers: [
      Marker(
          point: salonPoint,
          width: 48,
          height: 56,
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF00BCD4), kPrimary]),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: kPrimary.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4))
                    ],
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(Icons.content_cut_rounded,
                      color: Colors.white, size: 18)),
              CustomPaint(
                  size: const Size(14, 8),
                  painter: _TrianglePainter(color: kPrimary)),
            ],
          )),
    ]),
  ];
}

class _SalonMapSection extends StatefulWidget {
  final Salon salon;
  const _SalonMapSection({required this.salon});
  @override
  State<_SalonMapSection> createState() => _SalonMapSectionState();
}

class _SalonMapSectionState extends State<_SalonMapSection> {
  LatLng? _userLoc;

  @override
  void initState() {
    super.initState();
    _loadUserLoc();
  }

  Future<void> _loadUserLoc() async {
    final loc = await _getUserLocation();
    if (mounted && loc != null) setState(() => _userLoc = loc);
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final salon = widget.salon;
    final point = LatLng(salon.latitude!, salon.longitude!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: kPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.s)),
              child: const Icon(Icons.map_rounded, size: 18, color: kPrimary)),
          const SizedBox(width: AppSpacing.s + 2),
          Expanded(
            child: Text('Ýerleşýän ýeri', style: _detailSectionTitleStyle(tt)),
          ),
        ]),
        const SizedBox(height: AppSpacing.m),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.m),
              boxShadow: kStickerShadow,
              border: Border.all(color: kStickerOutline)),
          clipBehavior: Clip.antiAlias,
          child: Column(children: [
            SizedBox(
                height: 180,
                child: AbsorbPointer(
                    child: FlutterMap(
                  options: MapOptions(initialCenter: point, initialZoom: 16),
                  children: _buildMapLayers(point, userLocation: _userLoc),
                ))),
            Container(
              width: double.infinity,
              color: kCardBg,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.l, vertical: AppSpacing.m),
              child: Row(children: [
                Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        color: kPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.s)),
                    child: const Icon(Icons.location_on_rounded,
                        size: 18, color: kPrimary)),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(salon.name, style: tt.labelLarge),
                      if (salon.address != null)
                        Text(salon.address!,
                            style: tt.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                    ])),
                const SizedBox(width: AppSpacing.s),
                FilledButton.tonalIcon(
                  onPressed: () => openMapsDirection(salon),
                  icon: const Icon(Icons.navigation_rounded, size: 18),
                  label: const Text('Ugur'),
                  style: FilledButton.styleFrom(
                      foregroundColor: const Color(0xFF0E7490),
                      backgroundColor: const Color(0x1F0E7490),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.m, vertical: AppSpacing.s),
                      textStyle: tt.labelLarge),
                ),
              ]),
            ),
          ]),
        ),
      ],
    );
  }
}

// ignore: unused_element
String _distanceText(LatLng a, LatLng b) {
  const d = Distance();
  final meters = d.as(LengthUnit.Meter, a, b);
  if (meters < 1000) return '${meters.round()} m uzaklykda';
  return '${(meters / 1000).toStringAsFixed(1)} km uzaklykda';
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        ui.Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width / 2, size.height)
          ..close(),
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
