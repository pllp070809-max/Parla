import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../providers/providers.dart';
import '../models/salon.dart';
import '../theme.dart';
import '../widgets/shared_widgets.dart';
import '../utils/launch_utils.dart';
import 'booking_screen.dart';
import 'salon_gallery_screen.dart';
import 'salon_reviews_screen.dart';
import 'salon_staff_screen.dart';

Future<LatLng?> _getUserLocation() async {
  bool enabled = await Geolocator.isLocationServiceEnabled();
  if (!enabled) return null;
  LocationPermission perm = await Geolocator.checkPermission();
  if (perm == LocationPermission.denied) {
    perm = await Geolocator.requestPermission();
  }
  if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
    return null;
  }
  try {
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 5)),
    );
    return LatLng(pos.latitude, pos.longitude);
  } catch (_) {
    return null;
  }
}

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

  static const _imageMap = {
    'salon1': 'images/salon1.png',
    'salon2': 'images/salon2.png',
    'salon3': 'images/salon3.png',
  };

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

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
          final hasImage = _imageMap.containsKey(salon.imageKey);
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(salon.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  background: GestureDetector(
                    onTap: () => Navigator.push(context, fadeSlideRoute(SalonGalleryScreen(salon: salon))),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (hasImage)
                          Image.asset(_imageMap[salon.imageKey]!, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _bgPlaceholder())
                        else
                          _bgPlaceholder(),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black54],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.photo_library_rounded, size: 18, color: Colors.white),
                                SizedBox(width: 6),
                                Text('Suratlary gör', style: TextStyle(color: Colors.white, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(kSpaceXl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (salon.address != null) ...[
                        Row(children: [
                          const Icon(Icons.location_on_outlined, size: 20, color: kPrimary),
                          const SizedBox(width: kSpaceSm),
                          Expanded(child: Text(salon.address!, style: tt.bodyLarge)),
                        ]),
                        const SizedBox(height: kSpaceXl),
                      ],

                      _OpeningHoursTile(salonName: salon.name),
                      const SizedBox(height: kSpaceXl),

                      if (salon.hasLocation) ...[
                        _SalonMapSection(salon: salon),
                        const SizedBox(height: kSpaceXl),
                      ],

                      Row(
                        children: [
                          Expanded(
                            child: _DetailNavTile(
                              icon: Icons.star_rounded,
                              label: 'Synlar',
                              onTap: () => Navigator.push(context, fadeSlideRoute(SalonReviewsScreen(salonName: salon.name))),
                            ),
                          ),
                          const SizedBox(width: kSpaceMd),
                          Expanded(
                            child: _DetailNavTile(
                              icon: Icons.people_rounded,
                              label: 'Topar',
                              onTap: () => Navigator.push(context, fadeSlideRoute(SalonStaffScreen(salonName: salon.name))),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: kSpaceXl),

                      Text('Hyzmatlar', style: tt.titleLarge),
                      const SizedBox(height: kSpaceMd),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: kSpaceXl),
                sliver: SliverList.separated(
                  itemCount: salon.services.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final svc = salon.services[i];
                    return _ServiceTile(
                      service: svc,
                      onBook: () => Navigator.push(
                        context,
                        fadeSlideRoute(BookingScreen(
                          salonId: salon.id,
                          salonName: salon.name,
                          services: salon.services,
                          preselectedServiceId: svc.id,
                        )),
                      ),
                    );
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  Widget _bgPlaceholder() => Container(
    color: kPrimary.withValues(alpha: 0.12),
    child: const Center(child: Icon(Icons.storefront, size: 72, color: kPrimary)),
  );
}

// ── Shared map layers builder ──
List<Widget> _buildMapLayers(LatLng salonPoint, {LatLng? userLocation}) {
  return [
    TileLayer(
      urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
      subdomains: const ['a', 'b', 'c', 'd'],
      userAgentPackageName: 'com.parla.app',
      maxZoom: 19,
    ),
    CircleLayer(
      circles: [
        CircleMarker(
          point: salonPoint,
          radius: 48,
          color: kPrimary.withValues(alpha: 0.08),
          borderColor: kPrimary.withValues(alpha: 0.2),
          borderStrokeWidth: 1.5,
        ),
      ],
    ),
    if (userLocation != null)
      MarkerLayer(
        markers: [
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
                  BoxShadow(color: const Color(0xFF4285F4).withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
            ),
          ),
        ],
      ),
    if (userLocation != null)
      CircleLayer(
        circles: [
          CircleMarker(
            point: userLocation,
            radius: 24,
            color: const Color(0xFF4285F4).withValues(alpha: 0.08),
            borderColor: const Color(0xFF4285F4).withValues(alpha: 0.15),
            borderStrokeWidth: 1,
          ),
        ],
      ),
    MarkerLayer(
      markers: [
        Marker(
          point: salonPoint,
          width: 48,
          height: 56,
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [Color(0xFF00BCD4), kPrimary],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: kPrimary.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.content_cut_rounded, color: Colors.white, size: 18),
              ),
              CustomPaint(size: const Size(14, 8), painter: _TrianglePainter(color: kPrimary)),
            ],
          ),
        ),
      ],
    ),
  ];
}

// ── Mini map in detail page ──
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

  void _openFullScreen() {
    Navigator.push(context, fadeSlideRoute(
      _FullScreenMapPage(salon: widget.salon, initialUserLocation: _userLoc),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final salon = widget.salon;
    final point = LatLng(salon.latitude!, salon.longitude!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: kPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(kRadiusSm),
              ),
              child: const Icon(Icons.map_rounded, size: 18, color: kPrimary),
            ),
            const SizedBox(width: kSpaceSm + 2),
            Expanded(child: Text('Ýerleşýän ýeri', style: tt.titleMedium)),
          ],
        ),
        const SizedBox(height: kSpaceMd),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kRadiusLg),
            boxShadow: kShadowLg,
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              GestureDetector(
                onTap: _openFullScreen,
                child: SizedBox(
                  height: 220,
                  child: Stack(
                    children: [
                      AbsorbPointer(
                        child: FlutterMap(
                          options: MapOptions(initialCenter: point, initialZoom: 16),
                          children: _buildMapLayers(point, userLocation: _userLoc),
                        ),
                      ),
                      Positioned(
                        top: kSpaceSm, left: kSpaceSm,
                        child: _GlassChip(icon: Icons.fullscreen_rounded, label: 'Ulaltmak', onTap: _openFullScreen),
                      ),
                      Positioned(
                        top: kSpaceSm, right: kSpaceSm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: kSpaceSm, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(kRadiusSm), boxShadow: kShadowSm,
                          ),
                          child: Text('© OpenStreetMap © CARTO', style: tt.bodyMedium?.copyWith(fontSize: 9, color: kTextSecondary)),
                        ),
                      ),
                      if (_userLoc != null)
                        Positioned(
                          bottom: kSpaceSm, left: kSpaceSm,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: kSpaceSm + 2, vertical: kSpaceXs),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(kRadiusSm), boxShadow: kShadowSm,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF4285F4), shape: BoxShape.circle)),
                                const SizedBox(width: kSpaceXs),
                                Text(_distanceText(point, _userLoc!), style: tt.labelLarge?.copyWith(fontSize: 11, color: kTextSecondary)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity, color: kCardBg,
                padding: const EdgeInsets.symmetric(horizontal: kSpaceLg, vertical: kSpaceMd),
                child: Row(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: kPrimary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(kRadiusSm)),
                      child: const Icon(Icons.location_on_rounded, size: 18, color: kPrimary),
                    ),
                    const SizedBox(width: kSpaceMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(salon.name, style: tt.labelLarge),
                          if (salon.address != null)
                            Text(salon.address!, style: tt.bodyMedium?.copyWith(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: kSpaceSm),
                    FilledButton.tonalIcon(
                      onPressed: () => openMapsDirection(salon),
                      icon: const Icon(Icons.directions_rounded, size: 18),
                      label: const Text('Ugur'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: kSpaceMd, vertical: kSpaceSm),
                        textStyle: tt.labelLarge?.copyWith(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _distanceText(LatLng a, LatLng b) {
  const d = Distance();
  final meters = d.as(LengthUnit.Meter, a, b);
  if (meters < 1000) return '${meters.round()} m uzaklykda';
  return '${(meters / 1000).toStringAsFixed(1)} km uzaklykda';
}

// ── Full screen map ──
class _FullScreenMapPage extends StatefulWidget {
  final Salon salon;
  final LatLng? initialUserLocation;
  const _FullScreenMapPage({required this.salon, this.initialUserLocation});

  @override
  State<_FullScreenMapPage> createState() => _FullScreenMapPageState();
}

class _FullScreenMapPageState extends State<_FullScreenMapPage> {
  final _mapCtrl = MapController();
  LatLng? _userLoc;
  bool _locatingUser = false;

  @override
  void initState() {
    super.initState();
    _userLoc = widget.initialUserLocation;
    if (_userLoc == null) _fetchUserLoc();
  }

  Future<void> _fetchUserLoc() async {
    setState(() => _locatingUser = true);
    final loc = await _getUserLocation();
    if (mounted) setState(() { _userLoc = loc; _locatingUser = false; });
  }

  void _zoomIn() {
    final z = _mapCtrl.camera.zoom;
    _mapCtrl.move(_mapCtrl.camera.center, (z + 1).clamp(2, 19));
  }

  void _zoomOut() {
    final z = _mapCtrl.camera.zoom;
    _mapCtrl.move(_mapCtrl.camera.center, (z - 1).clamp(2, 19));
  }

  void _goToSalon() {
    _mapCtrl.move(LatLng(widget.salon.latitude!, widget.salon.longitude!), 16);
  }

  void _goToUser() {
    if (_userLoc != null) {
      _mapCtrl.move(_userLoc!, 16);
    } else {
      _fetchUserLoc();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final salon = widget.salon;
    final salonPoint = LatLng(salon.latitude!, salon.longitude!);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(kSpaceSm),
          child: Material(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(kRadiusMd), elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(kRadiusMd),
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close_rounded, color: kTextPrimary),
            ),
          ),
        ),
        actions: [
          if (_userLoc != null)
            Padding(
              padding: const EdgeInsets.only(right: kSpaceSm),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: kSpaceMd, vertical: kSpaceSm),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(kRadiusMd), boxShadow: kShadowSm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF4285F4), shape: BoxShape.circle)),
                    const SizedBox(width: kSpaceSm),
                    Text(_distanceText(salonPoint, _userLoc!), style: tt.labelLarge?.copyWith(fontSize: 12, color: kTextSecondary)),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapCtrl,
              options: MapOptions(initialCenter: salonPoint, initialZoom: 16, interactionOptions: const InteractionOptions(flags: InteractiveFlag.all)),
              children: _buildMapLayers(salonPoint, userLocation: _userLoc),
            ),
          ),

          Positioned(
            right: kSpaceLg,
            bottom: MediaQuery.of(context).padding.bottom + kSpaceLg + 96 + kSpaceMd,
            child: Column(
              children: [
                _MapControlButton(
                  icon: _locatingUser ? Icons.hourglass_top_rounded : Icons.my_location_rounded,
                  accent: true,
                  onTap: _goToUser,
                ),
                const SizedBox(height: kSpaceSm),
                _MapControlButton(icon: Icons.storefront_rounded, onTap: _goToSalon),
                const SizedBox(height: kSpaceMd),
                _MapControlButton(icon: Icons.add, onTap: _zoomIn),
                const SizedBox(height: kSpaceSm),
                _MapControlButton(icon: Icons.remove, onTap: _zoomOut),
              ],
            ),
          ),

          Positioned(
            left: kSpaceLg, right: kSpaceLg,
            bottom: MediaQuery.of(context).padding.bottom + kSpaceLg,
            child: Container(
              padding: const EdgeInsets.all(kSpaceLg),
              decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(kRadiusLg), boxShadow: kShadowLg),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: [kPrimary.withValues(alpha: 0.2), kPrimary.withValues(alpha: 0.08)],
                      ),
                      borderRadius: BorderRadius.circular(kRadiusMd),
                    ),
                    child: const Icon(Icons.storefront_rounded, size: 24, color: kPrimary),
                  ),
                  const SizedBox(width: kSpaceMd),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(salon.name, style: tt.titleMedium),
                        if (salon.address != null) ...[
                          const SizedBox(height: kSpaceXs),
                          Text(salon.address!, style: tt.bodyMedium?.copyWith(fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: kSpaceSm),
                  FloatingActionButton.small(
                    heroTag: 'directions', backgroundColor: kPrimary,
                    onPressed: () => openMapsDirection(salon),
                    child: const Icon(Icons.directions_rounded, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable widgets ──
class _GlassChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _GlassChip({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(kRadiusSm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: kSpaceSm + 2, vertical: kSpaceXs + 1),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(kRadiusSm), boxShadow: kShadowSm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: kPrimary),
              const SizedBox(width: kSpaceXs),
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool accent;
  const _MapControlButton({required this.icon, required this.onTap, this.accent = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: accent ? const Color(0xFF4285F4) : kCardBg,
      borderRadius: BorderRadius.circular(kRadiusMd),
      elevation: 4, shadowColor: Colors.black26,
      child: InkWell(
        borderRadius: BorderRadius.circular(kRadiusMd), onTap: onTap,
        child: SizedBox(
          width: 44, height: 44,
          child: Icon(icon, color: accent ? Colors.white : kTextPrimary, size: 22),
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    canvas.drawPath(_trianglePath(size), paint);
  }

  static ui.Path _trianglePath(Size size) {
    final p = ui.Path();
    p.moveTo(0, 0);
    p.lineTo(size.width, 0);
    p.lineTo(size.width / 2, size.height);
    p.close();
    return p;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OpeningHoursTile extends StatelessWidget {
  final String salonName;
  const _OpeningHoursTile({required this.salonName});

  static const _mockHours = [
    'Duşenbe – Şenbe: 09:00 – 20:00',
    'Ýekşenbe: 10:00 – 18:00',
  ];

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Iş wagty', style: tt.titleLarge),
                const SizedBox(height: 16),
                ..._mockHours.map((h) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(h, style: tt.bodyLarge),
                    )),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(kRadiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: kSpaceSm),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: kPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(kRadiusSm),
                ),
                child: const Icon(Icons.schedule_rounded, size: 22, color: kPrimary),
              ),
              const SizedBox(width: kSpaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Iş wagty', style: tt.titleMedium),
                    Text('Duş–Şen: 09:00–20:00', style: tt.bodySmall?.copyWith(color: kTextSecondary)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: kTextTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailNavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _DetailNavTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kRadiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: kSurfaceBg,
            borderRadius: BorderRadius.circular(kRadiusMd),
            border: Border.all(color: kBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: kPrimary),
              const SizedBox(width: 8),
              Text(label, style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final Service service;
  final VoidCallback onBook;
  const _ServiceTile({required this.service, required this.onBook});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSpaceMd),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: tt.titleMedium),
                const SizedBox(height: kSpaceXs),
                Text(
                  '${service.durationMinutes} min'
                  '${service.price != null ? '  •  ${service.price!.toStringAsFixed(0)} TMT' : ''}',
                  style: tt.bodyMedium,
                ),
              ],
            ),
          ),
          FilledButton.tonal(onPressed: onBook, child: const Text('Bron et')),
        ],
      ),
    );
  }
}
