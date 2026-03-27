import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../providers/providers.dart';
import '../models/salon.dart';
import '../theme.dart';
import '../widgets/shared_widgets.dart';
import '../utils/launch_utils.dart';
import '../utils/service_categories.dart';
import '../utils/salon_images.dart';
import 'booking_screen.dart';
import 'salon_gallery_screen.dart';

// ── Mock data ──

const _kMockRating = 4.5;
const _kMockReviewCount = 18;
const _kMockDescription =
    'Biziň salonymyz 2018-nji ýyldan bäri müşderilere ýokary hilli gözellik hyzmatlary hödürleýär. '
    'Tejribeli ussalar, arassa gurşaw we myhmansöýer hyzmat. Bize gelip görüň!';

const _kMockStaff = [
  {'name': 'Aýgözel', 'role': 'Saç ussasy', 'rating': 4.9, 'reviews': 142},
  {'name': 'Mähri', 'role': 'Dyrnak ussasy', 'rating': 4.7, 'reviews': 98},
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

// ── Helpers ──

Future<LatLng?> _getUserLocation() async {
  bool enabled = await Geolocator.isLocationServiceEnabled();
  if (!enabled) return null;
  LocationPermission perm = await Geolocator.checkPermission();
  if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
  if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) return null;
  try {
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 5)),
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
            return const Center(child: CircularProgressIndicator(color: kPrimary));
          }
          if (snap.hasError) {
            return ErrorRetryWidget(message: 'Salon ýüklenip bilmedi', onRetry: _load);
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

class _SalonDetailBodyState extends State<_SalonDetailBody> {
  final _scrollCtrl = ScrollController();
  final _tabs = const ['Hyzmatlar', 'Topar', 'Portefolio', 'Barada'];
  int _activeTab = 0;
  bool _showTopBar = false;
  int _heroPage = 0;

  final _sectionKeys = List.generate(4, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollCtrl.offset;
    final show = offset > 240;
    if (show != _showTopBar) setState(() => _showTopBar = show);

    for (int i = _sectionKeys.length - 1; i >= 0; i--) {
      final key = _sectionKeys[i];
      final ctx = key.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox;
        final pos = box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
        if (pos.dy < 160) {
          if (_activeTab != i) setState(() => _activeTab = i);
          return;
        }
      }
    }
    if (_activeTab != 0) setState(() => _activeTab = 0);
  }

  void _scrollToSection(int i) {
    setState(() => _activeTab = i);
    final ctx = _sectionKeys[i].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic, alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart);
    }
  }

  void _openBooking({int? preselectedServiceId}) {
    Navigator.push(context, fadeSlideRoute(BookingScreen(
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
        ? salon.services.map((s) => s.price ?? 0).reduce((a, b) => a < b ? a : b)
        : 0;

    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollCtrl,
          slivers: [
            // ── Hero image ──
            SliverToBoxAdapter(child: _HeroSection(
              images: images,
              salon: salon,
              onPageChanged: (p) => setState(() => _heroPage = p),
              currentPage: _heroPage,
            )),

            // ── Info block ──
            SliverToBoxAdapter(child: _InfoBlock(salon: salon)),

            // ── Sticky chip bar ──
            SliverPersistentHeader(
              pinned: true,
              delegate: _ChipBarDelegate(
                tabs: _tabs,
                activeTab: _activeTab,
                onTap: _scrollToSection,
                salon: salon,
                showTitle: _showTopBar,
              ),
            ),

            // ── Hyzmatlar ──
            SliverToBoxAdapter(
              child: Padding(
                key: _sectionKeys[0],
                padding: const EdgeInsets.fromLTRB(kSpaceXl, kSpaceLg, kSpaceXl, 0),
                child: _ServicesSection(salon: salon, onBook: (svc) => _openBooking(preselectedServiceId: svc.id)),
              ),
            ),

            // ── Topar ──
            SliverToBoxAdapter(
              child: Padding(
                key: _sectionKeys[1],
                padding: const EdgeInsets.fromLTRB(kSpaceXl, kSpace2xl, kSpaceXl, 0),
                child: _TeamSection(salon: salon, onBook: _openBooking),
              ),
            ),

            // ── Portefolio ──
            SliverToBoxAdapter(
              child: Padding(
                key: _sectionKeys[2],
                padding: const EdgeInsets.fromLTRB(kSpaceXl, kSpace2xl, kSpaceXl, 0),
                child: _PortfolioSection(salon: salon, images: images),
              ),
            ),

            // ── Barada ──
            SliverToBoxAdapter(
              child: Padding(
                key: _sectionKeys[3],
                padding: const EdgeInsets.fromLTRB(kSpaceXl, kSpace2xl, kSpaceXl, 0),
                child: _AboutSection(salon: salon),
              ),
            ),

            // ── Map ──
            if (salon.hasLocation)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(kSpaceXl, kSpace2xl, kSpaceXl, 0),
                  child: _SalonMapSection(salon: salon),
                ),
              ),

            // ── Nearby ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(kSpaceXl, kSpace2xl, kSpaceXl, 0),
                child: _NearbySalonsSection(currentSalon: salon),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),

        // ── Bottom bar ──
        Positioned(
          left: 0, right: 0, bottom: 0,
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

  const _HeroSection({required this.images, required this.salon, required this.onPageChanged, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: onPageChanged,
            itemBuilder: (_, i) => Image.asset(
              images[i], fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: kPrimary.withValues(alpha: 0.12), child: const Center(child: Icon(Icons.storefront, size: 72, color: kPrimary))),
            ),
          ),

          // Gradient overlay
          const Positioned(
            left: 0, right: 0, top: 0, height: 100,
            child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black38, Colors.transparent]))),
          ),

          // Top buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: kSpaceMd, right: kSpaceMd,
            child: Row(
              children: [
                _HeroBtn(icon: Icons.arrow_back_rounded, onTap: () => Navigator.pop(context)),
                const Spacer(),
                _HeroBtn(icon: Icons.ios_share_rounded, onTap: () {}),
                const SizedBox(width: kSpaceSm),
                _HeroBtn(icon: Icons.favorite_border_rounded, onTap: () {}),
              ],
            ),
          ),

          // Page counter
          Positioned(
            bottom: 12, right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(kRadiusSm)),
              child: Text('${currentPage + 1}/${images.length}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeroBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(kSpaceXl, kSpaceLg, kSpaceXl, kSpaceSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(salon.name, style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: kSpaceSm),
          Row(
            children: [
              Text('$_kMockRating', style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(width: 4),
              ...List.generate(5, (i) {
                if (i < _kMockRating.floor()) return const Icon(Icons.star_rounded, size: 18, color: kStar);
                if (i < _kMockRating.ceil() && _kMockRating % 1 >= 0.3) return const Icon(Icons.star_half_rounded, size: 18, color: kStar);
                return Icon(Icons.star_outline_rounded, size: 18, color: kStar.withValues(alpha: 0.4));
              }),
              const SizedBox(width: 6),
              Text('($_kMockReviewCount)', style: tt.bodySmall?.copyWith(color: kTextTertiary)),
            ],
          ),
          const SizedBox(height: kSpaceSm),
          if (salon.address != null)
            Text(salon.address!, style: tt.bodyMedium),
          const SizedBox(height: kSpaceSm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: kError.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(kRadiusPill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 7, height: 7, decoration: const BoxDecoration(color: kError, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text('Ýapyk', style: tt.bodySmall?.copyWith(color: kError, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════
// Chip bar delegate
// ═════════════════════════════════════════════
class _ChipBarDelegate extends SliverPersistentHeaderDelegate {
  final List<String> tabs;
  final int activeTab;
  final ValueChanged<int> onTap;
  final Salon salon;
  final bool showTitle;

  _ChipBarDelegate({required this.tabs, required this.activeTab, required this.onTap, required this.salon, required this.showTitle});

  @override
  double get minExtent => 50;
  @override
  double get maxExtent => 50;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final tt = Theme.of(context).textTheme;
    return Container(
      color: kScaffoldBg,
      child: Column(
        children: [
          if (showTitle)
            SizedBox(
              height: 0,
              child: OverflowBox(
                maxHeight: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _HeroBtn(icon: Icons.arrow_back_rounded, onTap: () => Navigator.pop(context)),
                    const SizedBox(width: kSpaceSm),
                    Text(salon.name, style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                    const Spacer(),
                    _HeroBtn(icon: Icons.ios_share_rounded, onTap: () {}),
                    const SizedBox(width: kSpaceSm),
                    _HeroBtn(icon: Icons.favorite_border_rounded, onTap: () {}),
                  ],
                ),
              ),
            ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: kSpaceXl),
              itemCount: tabs.length,
              separatorBuilder: (_, __) => const SizedBox(width: kSpaceMd),
              itemBuilder: (_, i) {
                final sel = i == activeTab;
                return GestureDetector(
                  onTap: () { HapticFeedback.selectionClick(); onTap(i); },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          tabs[i],
                          style: tt.titleSmall?.copyWith(
                            fontWeight: sel ? FontWeight.w800 : FontWeight.w500,
                            color: sel ? kTextPrimary : kTextSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 2.5,
                        width: sel ? 40 : 0,
                        decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(2)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(height: 1, color: kBorder),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _ChipBarDelegate old) =>
      old.activeTab != activeTab || old.showTitle != showTitle;
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
  int _activeTab = 0;
  static const int _initialVisibleCount = 4;

  List<Service> get _visibleServices {
    final all = widget.salon.services;
    if (_activeTab == 0) return all;
    final key = kServiceCategories[_activeTab - 1]['key'];
    return all.where((s) => s.categoryKey == key).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final visible = _visibleServices;
    final display = visible.take(_initialVisibleCount).toList();
    final showViewAll = visible.length > _initialVisibleCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hyzmatlar', style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: Colors.black)),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _ServiceTab(label: 'Hemmesi', isActive: _activeTab == 0, onTap: () => setState(() => _activeTab = 0)),
                ...kServiceCategories.asMap().entries.map((e) {
                  final tabIndex = e.key + 1;
                  return Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: _ServiceTab(
                      label: e.value['label']!,
                      isActive: _activeTab == tabIndex,
                      onTap: () => setState(() => _activeTab = tabIndex),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (visible.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text('Bu bölümde hyzmat ýok', style: tt.bodyMedium?.copyWith(color: const Color(0xFF757575))),
            )
          else ...[
            ...display.asMap().entries.map((e) {
              final i = e.key;
              final svc = e.value;
              return Column(
                children: [
                  if (i > 0) const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _ServiceRow(service: svc, onBook: () => widget.onBook(svc)),
                ],
              );
            }),
            if (showViewAll) ...[
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFCCCCCC), width: 1),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  child: const Text('Hemmesini görmek'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ],
      ),
    );
  }
}

class _ServiceTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _ServiceTab({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.black)),
                const SizedBox(height: 4),
                Text('${service.durationMinutes} min', style: tt.bodySmall?.copyWith(color: const Color(0xFF757575))),
                const SizedBox(height: 4),
                Text('${service.price?.toStringAsFixed(0) ?? '?'} TMT', style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.black)),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onBook,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE0E0E0)),
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text('Bron et'),
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
  final VoidCallback onBook;
  const _TeamSection({required this.salon, required this.onBook});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(kSpaceLg),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(kRadiusLg),
        border: Border.all(color: kBorder),
        boxShadow: kShadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Topar', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const Spacer(),
              Text('${_kMockStaff.length} ussa', style: tt.bodySmall?.copyWith(color: kTextTertiary)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Islän ussaňyzy saýlaň we bron ediň', style: tt.bodySmall?.copyWith(color: kTextSecondary)),
          const SizedBox(height: kSpaceLg),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _kMockStaff.length,
              separatorBuilder: (_, __) => const SizedBox(width: kSpaceMd),
              itemBuilder: (_, i) {
                final s = _kMockStaff[i];
                final initial = (s['name'] as String)[0];
                final color = i == 0 ? kPrimary : const Color(0xFFE91E63);
                return Container(
                  width: 160,
                  padding: const EdgeInsets.symmetric(vertical: kSpaceLg, horizontal: kSpaceMd),
                  decoration: BoxDecoration(
                    color: kCardBg,
                    borderRadius: BorderRadius.circular(kRadiusLg),
                    border: Border.all(color: kBorder),
                    boxShadow: kShadowSm,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Text(initial, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
                      ),
                      const SizedBox(height: kSpaceSm),
                      Text(s['name'] as String, style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                      Text(s['role'] as String, style: tt.bodySmall?.copyWith(color: kTextSecondary, fontSize: 12)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star_rounded, size: 15, color: kStar),
                          const SizedBox(width: 3),
                          Text('${s['rating']}', style: tt.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
                          Text(' (${s['reviews']})', style: tt.bodySmall?.copyWith(color: kTextTertiary, fontSize: 11)),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: onBook,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: kPrimary),
                            foregroundColor: kPrimary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusMd)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Text('Bron et', style: tt.labelSmall?.copyWith(color: kPrimary, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
    return Container(
      padding: const EdgeInsets.all(kSpaceLg),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(kRadiusLg),
        border: Border.all(color: kBorder),
        boxShadow: kShadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: kPrimary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(kRadiusSm)),
                child: const Icon(Icons.photo_library_rounded, size: 16, color: kPrimary),
              ),
              const SizedBox(width: kSpaceSm),
              Text('Portefolio', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: kSpaceMd),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: kSpaceSm),
              itemBuilder: (_, i) => ClipRRect(
                borderRadius: BorderRadius.circular(kRadiusMd),
                child: SizedBox(
                  width: 140,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(images[i], fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: kPrimary.withValues(alpha: 0.12), child: const Icon(Icons.image_not_supported_rounded)),
                      ),
                      Positioned(
                        bottom: 8, left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(kRadiusSm)),
                          child: Text('${i + 1}/${images.length}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      Positioned.fill(child: Material(color: Colors.transparent, child: InkWell(
                        onTap: () => Navigator.push(context, fadeSlideRoute(SalonGalleryScreen(salon: salon, initialIndex: i))),
                      ))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
        // Description card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(kSpaceLg),
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(kRadiusLg),
            border: Border.all(color: kBorder),
            boxShadow: kShadowSm,
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
              const SizedBox(height: kSpaceSm),
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(_expanded ? 'Az gör' : 'Doly oka', style: tt.bodySmall?.copyWith(color: kPrimary, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        const SizedBox(height: kSpaceLg),

        // Opening hours
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(kSpaceLg),
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(kRadiusLg),
            border: Border.all(color: kBorder),
            boxShadow: kShadowSm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 22, color: kPrimary),
                  const SizedBox(width: kSpaceSm),
                  Text('Iş wagty', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: kSpaceMd),
              ..._kOpeningHours.map((h) => Padding(
                padding: const EdgeInsets.only(bottom: kSpaceSm),
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: kSuccess, shape: BoxShape.circle)),
                    const SizedBox(width: kSpaceSm),
                    SizedBox(width: 100, child: Text(h['day'] as String, style: tt.bodyMedium?.copyWith(color: kTextPrimary))),
                    Text(h['hours'] as String, style: tt.bodyMedium?.copyWith(color: kTextSecondary)),
                  ],
                ),
              )),
            ],
          ),
        ),
        const SizedBox(height: kSpaceLg),

        // Additional info
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(kSpaceLg),
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(kRadiusLg),
            border: Border.all(color: kBorder),
            boxShadow: kShadowSm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle_rounded, size: 22, color: kSuccess),
                  const SizedBox(width: kSpaceSm),
                  Text('Goşmaça maglumat', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: kSpaceMd),
              ..._kAdditionalInfo.map((info) => Padding(
                padding: const EdgeInsets.only(bottom: kSpaceSm),
                child: Row(
                  children: [
                    Icon(info['icon'] as IconData, size: 20, color: kTextSecondary),
                    const SizedBox(width: kSpaceMd),
                    Expanded(child: Text(info['label'] as String, style: tt.bodyMedium?.copyWith(color: kTextPrimary))),
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
            const SizedBox(width: kSpaceSm),
            Text('Töwerekde salonlar', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: kSpaceMd),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            separatorBuilder: (_, __) => const SizedBox(width: kSpaceMd),
            itemBuilder: (_, i) {
              final images = portfolioImages(currentSalon);
              final imgIdx = (i + 1) % images.length;
              return Container(
                width: 170,
                decoration: BoxDecoration(
                  color: kCardBg,
                  borderRadius: BorderRadius.circular(kRadiusLg),
                  border: Border.all(color: kBorder),
                  boxShadow: kShadowSm,
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.asset(images[imgIdx], width: double.infinity, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: kSurfaceBg, child: const Icon(Icons.storefront)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(kSpaceSm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ýakyndaky salon ${i + 1}', style: tt.labelSmall?.copyWith(fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text('${(1.1 + i * 0.4).toStringAsFixed(1)} km · mock', style: tt.bodySmall?.copyWith(color: kTextTertiary, fontSize: 11)),
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
  const _BottomBookBar({required this.minPrice, required this.salonName, required this.onBook});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        boxShadow: kShadowUpMd,
      ),
      padding: EdgeInsets.fromLTRB(kSpaceXl, kSpaceMd, kSpaceXl, MediaQuery.of(context).padding.bottom + kSpaceMd),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${minPrice.toStringAsFixed(0)} TMT-dan', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                Text(salonName, style: tt.bodySmall?.copyWith(color: kTextSecondary)),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: onBook,
            icon: const Icon(Icons.calendar_today_rounded, size: 18),
            label: const Text('Bron et'),
            style: FilledButton.styleFrom(
              backgroundColor: kPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusMd)),
              padding: const EdgeInsets.symmetric(horizontal: kSpaceXl, vertical: kSpaceMd),
            ),
          ),
        ],
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
      urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
      subdomains: const ['a', 'b', 'c', 'd'],
      userAgentPackageName: 'com.parla.app', maxZoom: 19,
    ),
    CircleLayer(circles: [
      CircleMarker(point: salonPoint, radius: 48, color: kPrimary.withValues(alpha: 0.08), borderColor: kPrimary.withValues(alpha: 0.2), borderStrokeWidth: 1.5),
    ]),
    if (userLocation != null) ...[
      MarkerLayer(markers: [
        Marker(point: userLocation, width: 28, height: 28, child: Container(
          decoration: BoxDecoration(color: const Color(0xFF4285F4), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3),
            boxShadow: [BoxShadow(color: const Color(0xFF4285F4).withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 2))]),
        )),
      ]),
      CircleLayer(circles: [
        CircleMarker(point: userLocation, radius: 24, color: const Color(0xFF4285F4).withValues(alpha: 0.08), borderColor: const Color(0xFF4285F4).withValues(alpha: 0.15), borderStrokeWidth: 1),
      ]),
    ],
    MarkerLayer(markers: [
      Marker(point: salonPoint, width: 48, height: 56, alignment: Alignment.topCenter, child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 42, height: 42, decoration: BoxDecoration(
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF00BCD4), kPrimary]),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: kPrimary.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
            border: Border.all(color: Colors.white, width: 3),
          ), child: const Icon(Icons.content_cut_rounded, color: Colors.white, size: 18)),
          CustomPaint(size: const Size(14, 8), painter: _TrianglePainter(color: kPrimary)),
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
  void initState() { super.initState(); _loadUserLoc(); }

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
          Container(width: 32, height: 32, decoration: BoxDecoration(color: kPrimary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(kRadiusSm)),
            child: const Icon(Icons.map_rounded, size: 18, color: kPrimary)),
          const SizedBox(width: kSpaceSm + 2),
          Expanded(child: Text('Ýerleşýän ýeri', style: tt.titleMedium)),
        ]),
        const SizedBox(height: kSpaceMd),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(kRadiusLg), boxShadow: kShadowSm, border: Border.all(color: kBorder)),
          clipBehavior: Clip.antiAlias,
          child: Column(children: [
            SizedBox(height: 180, child: AbsorbPointer(child: FlutterMap(
              options: MapOptions(initialCenter: point, initialZoom: 16),
              children: _buildMapLayers(point, userLocation: _userLoc),
            ))),
            Container(
              width: double.infinity, color: kCardBg,
              padding: const EdgeInsets.symmetric(horizontal: kSpaceLg, vertical: kSpaceMd),
              child: Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(color: kPrimary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(kRadiusSm)),
                  child: const Icon(Icons.location_on_rounded, size: 18, color: kPrimary)),
                const SizedBox(width: kSpaceMd),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(salon.name, style: tt.labelLarge),
                  if (salon.address != null) Text(salon.address!, style: tt.bodyMedium?.copyWith(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                ])),
                const SizedBox(width: kSpaceSm),
                FilledButton.tonalIcon(
                  onPressed: () => openMapsDirection(salon),
                  icon: const Icon(Icons.directions_rounded, size: 18),
                  label: const Text('Ugur'),
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: kSpaceMd, vertical: kSpaceSm), textStyle: tt.labelLarge?.copyWith(fontSize: 13)),
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
    canvas.drawPath(ui.Path()..moveTo(0, 0)..lineTo(size.width, 0)..lineTo(size.width / 2, size.height)..close(), Paint()..color = color..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
