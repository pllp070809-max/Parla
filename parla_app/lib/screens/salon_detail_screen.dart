import 'dart:async' show unawaited;
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderAbstractViewport;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../app_text_styles.dart';
import '../providers/providers.dart';
import '../app_radius.dart';
import '../app_spacing.dart';
import '../models/salon.dart';
import '../theme.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/service_catalog_section.dart';
import '../widgets/shared_widgets.dart';
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

TextStyle? _detailSubsectionTitleStyle(TextTheme tt) {
  return tt.titleMedium?.copyWith(
    fontWeight: FontWeight.w500,
    color: kTextPrimary,
    letterSpacing: -0.05,
    height: 1.3,
  );
}

TextStyle? _detailRowTitleStyle(TextTheme tt) {
  return tt.titleMedium?.copyWith(
    fontWeight: FontWeight.w500,
    color: kTextPrimary,
    height: 1.3,
  );
}

TextStyle? _detailRowMetaStyle(TextTheme tt) {
  return tt.labelSmall?.copyWith(
    color: _kDetailMeta,
    fontWeight: FontWeight.w400,
  );
}

ButtonStyle _detailWideOutlinedButtonStyle(TextTheme tt) {
  return OutlinedButton.styleFrom(
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
    textStyle: tt.labelMedium?.copyWith(fontWeight: FontWeight.w700),
  );
}

// ── Helpers ──

// ═════════════════════════════════════════════
// Main screen
// ═════════════════════════════════════════════
class SalonDetailScreen extends ConsumerStatefulWidget {
  final int salonId;
  final Future<void> Function(BuildContext context, String text)? shareLauncher;

  const SalonDetailScreen({
    super.key,
    required this.salonId,
    this.shareLauncher,
  });
  @override
  ConsumerState<SalonDetailScreen> createState() => _SalonDetailScreenState();
}

Future<void> _defaultSalonShareLauncher(
  BuildContext context,
  String text,
) async {
  final box = context.findRenderObject() as RenderBox?;
  await SharePlus.instance.share(
    ShareParams(
      text: text,
      title: 'Parla',
      subject: 'Parla',
      sharePositionOrigin:
          box == null ? null : box.localToGlobal(Offset.zero) & box.size,
    ),
  );
}

String _buildSalonShareText(Salon salon) {
  final lines = <String>[salon.name];
  final address = salon.address?.trim();
  if (address != null && address.isNotEmpty) {
    lines.add(address);
  }
  lines.add('Parla arkaly bu salon bilen tanyş boluň.');
  return lines.join('\n');
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
          return _SalonDetailBody(
            salon: salon,
            shareLauncher: widget.shareLauncher ?? _defaultSalonShareLauncher,
          );
        },
      ),
    );
  }
}

// ═════════════════════════════════════════════
// Body — chip bar + scrollable sections
// ═════════════════════════════════════════════
class _SalonDetailBody extends ConsumerStatefulWidget {
  final Salon salon;
  final Future<void> Function(BuildContext context, String text) shareLauncher;

  const _SalonDetailBody({
    required this.salon,
    required this.shareLauncher,
  });
  @override
  ConsumerState<_SalonDetailBody> createState() => _SalonDetailBodyState();
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

class _SalonDetailBodyState extends ConsumerState<_SalonDetailBody> {
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

  void _openGallery() {
    Navigator.push(
      context,
      fadeSlideRoute(
        SalonGalleryScreen(
          salon: widget.salon,
          initialIndex: _heroPage,
        ),
      ),
    );
  }

  Future<void> _shareSalon(BuildContext buttonContext) async {
    final messenger = ScaffoldMessenger.of(context);
    final shareText = _buildSalonShareText(widget.salon);
    try {
      await widget.shareLauncher(buttonContext, shareText);
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: shareText));
      if (!mounted) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Salon maglumatlary göçürildi')),
        );
    }
  }

  void _toggleFavourite(BuildContext _) {
    ref.read(favouriteSalonsProvider.notifier).toggle(widget.salon.id);
  }

  @override
  Widget build(BuildContext context) {
    final salon = widget.salon;
    final images = portfolioImages(salon);
    final isFavourite = ref.watch(favouriteSalonsProvider).contains(salon.id);

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
              onTap: _openGallery,
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
                  onBook: (svc) => _openBooking(preselectedServiceId: svc.id),
                ),
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
                    onTap: (_) => Navigator.pop(context),
                  ),
                  _UnifiedShareButtonOverlay(
                    revealProgress: stickyNavState.revealProgress,
                    onTap: _shareSalon,
                  ),
                  _UnifiedFavoriteButtonOverlay(
                    revealProgress: stickyNavState.revealProgress,
                    onTap: _toggleFavourite,
                    isFavourite: isFavourite,
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
            serviceCount: salon.services.length,
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
  final VoidCallback onTap;

  const _HeroSection(
      {required this.images,
      required this.salon,
      required this.onPageChanged,
      required this.currentPage,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 286,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            key: const ValueKey('hero-image-tap-target'),
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: PageView.builder(
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
  final ValueChanged<BuildContext> onTap;
  final IconData icon;
  final Color iconColor;
  final double? left;
  final double? right;
  final Key? buttonKey;

  const _UnifiedTopActionButtonOverlay({
    this.buttonKey,
    required this.revealProgress,
    required this.onTap,
    required this.icon,
    this.iconColor = kTextPrimary,
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
            child: Builder(
              builder: (buttonContext) => InkWell(
                key: buttonKey,
                customBorder: const CircleBorder(),
                onTap: () => onTap(buttonContext),
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 18,
                  ),
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
  final ValueChanged<BuildContext> onTap;

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
  final ValueChanged<BuildContext> onTap;

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
  final ValueChanged<BuildContext> onTap;
  final bool isFavourite;

  const _UnifiedFavoriteButtonOverlay({
    required this.revealProgress,
    required this.onTap,
    required this.isFavourite,
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
            icon: isFavourite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            iconColor: isFavourite ? kError : kTextPrimary,
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
class _ServicesSection extends StatelessWidget {
  final Salon salon;
  final ValueChanged<Service> onBook;
  const _ServicesSection({required this.salon, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return ServiceCatalogSection(
      services: salon.services,
      actionMode: ServiceCatalogActionMode.book,
      onAction: onBook,
      showTitle: true,
      showViewAllButton: true,
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
        const SizedBox(height: 8),
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
        const SizedBox(height: 4),
        _AboutDescriptionFlat(
          expanded: _expanded,
          onToggle: () => setState(() => _expanded = !_expanded),
        ),
        const SizedBox(height: 20),
        const _AboutOpeningHoursFlat(),
        const SizedBox(height: 24),
        const _AboutAdditionalInfoFlat(),
      ],
    );
  }
}

class _AboutDescriptionFlat extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;

  const _AboutDescriptionFlat({
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final toggleLabelStyle = tt.labelMedium?.copyWith(
      color: _kDetailMeta,
      fontWeight: FontWeight.w500,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: Text(
            _kMockDescription,
            key: const ValueKey('about-description'),
            style: tt.bodyMedium?.copyWith(
              color: kTextPrimary,
              height: 1.55,
            ),
            maxLines: expanded ? null : 3,
            overflow: expanded ? null : TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          key: const ValueKey('about-toggle-button'),
          onPressed: onToggle,
          style: TextButton.styleFrom(
            foregroundColor: _kDetailMeta,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft,
          ),
          child: Text(
            expanded ? 'Az görkez' : 'Doly oka',
            style: toggleLabelStyle,
          ),
        ),
      ],
    );
  }
}

class _AboutOpeningHoursFlat extends StatelessWidget {
  const _AboutOpeningHoursFlat();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final todayIndex = DateTime.now().weekday - 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Iş wagty',
          key: const ValueKey('about-opening-hours-title'),
          style: _detailSubsectionTitleStyle(tt),
        ),
        const SizedBox(height: 16),
        ..._kOpeningHours.asMap().entries.map((entry) {
          final index = entry.key;
          final hours = entry.value;
          final isToday = index == todayIndex;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == _kOpeningHours.length - 1 ? 0 : 12,
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: kSuccess,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    hours['day'] as String,
                    style: tt.bodyMedium?.copyWith(
                      color: kTextPrimary,
                      fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  hours['hours'] as String,
                  style: tt.bodyMedium?.copyWith(
                    color: kTextPrimary,
                    fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _AboutAdditionalInfoFlat extends StatelessWidget {
  const _AboutAdditionalInfoFlat();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Goşmaça maglumat',
          key: const ValueKey('about-additional-info-title'),
          style: _detailSubsectionTitleStyle(tt),
        ),
        const SizedBox(height: 16),
        ..._kAdditionalInfo.asMap().entries.map((entry) {
          final index = entry.key;
          final info = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == _kAdditionalInfo.length - 1 ? 0 : 14,
            ),
            child: Row(
              children: [
                Icon(
                  info['icon'] as IconData,
                  size: 20,
                  color: kTextPrimary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    info['label'] as String,
                    style: tt.bodyMedium?.copyWith(color: kTextPrimary),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _NearbySalonsSection extends StatelessWidget {
  final Salon currentSalon;
  const _NearbySalonsSection({required this.currentSalon});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final images = portfolioImages(currentSalon);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on_rounded,
                size: 20, color: kTextPrimary),
            const SizedBox(width: 12),
            Text(
              'Töwerekde salonlar',
              style: _detailSubsectionTitleStyle(tt),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.m),
            itemBuilder: (_, i) {
              final imgIdx = (i + 1) % images.length;
              return _NearbySalonCard(
                imagePath: images[imgIdx],
                title: 'Ýakyndaky salon ${i + 1}',
                distance: '${(1.1 + i * 0.4).toStringAsFixed(1)} km · mock',
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NearbySalonCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String distance;

  const _NearbySalonCard({
    required this.imagePath,
    required this.title,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    final metaStyle = AppTextStyles.cardMeta.copyWith(
      fontSize: 11.5,
      color: kTextSecondary,
    );
    final radius = BorderRadius.circular(AppRadius.m);
    return ClipRRect(
      borderRadius: radius,
      child: Material(
        color: kCardBg,
        child: SizedBox(
          width: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: kSurfaceBg,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: kTextSecondary,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s,
                  10,
                  AppSpacing.s,
                  AppSpacing.s,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 15, color: kStar),
                        const SizedBox(width: 4),
                        Text(
                          _kMockRating.toStringAsFixed(1),
                          style: metaStyle.copyWith(
                            color: kTextPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' ($_kMockReviewCount)',
                          style: metaStyle,
                        ),
                        Expanded(
                          child: Text(
                            ' • $distance',
                            style: metaStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════
// Bottom book bar
// ═════════════════════════════════════════════
class _BottomBookBar extends StatelessWidget {
  final int serviceCount;
  final VoidCallback onBook;
  const _BottomBookBar({required this.serviceCount, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return BottomActionBar(
      infoLabel: '$serviceCount hyzmat elýeter',
      infoKey: const ValueKey('bottom-book-bar-service-count'),
      buttonLabel: 'Bron',
      onPressed: onBook,
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
