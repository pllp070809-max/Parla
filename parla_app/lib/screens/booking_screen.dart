import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/providers.dart';
import '../models/salon.dart';
import '../services/api_service.dart';
import '../app_colors.dart';
import '../app_radius.dart';
import '../app_spacing.dart';
import '../theme.dart';
import '../utils/salon_images.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/service_catalog_section.dart';
import 'confirmation_screen.dart';

class _Staff {
  final int id;
  final String name;
  final String role;
  final double rating;
  const _Staff(this.id, this.name, this.role, this.rating);
}

enum _SelectedBannerDirection { top, bottom }

class _SelectedBannersState {
  final bool showTop;
  final bool showBottom;
  final int topCount;
  final int bottomCount;
  final List<int> topOffscreenServiceIds;
  final List<int> bottomOffscreenServiceIds;
  final int? topTargetServiceId;
  final int? bottomTargetServiceId;

  const _SelectedBannersState({
    required this.showTop,
    required this.showBottom,
    this.topCount = 0,
    this.bottomCount = 0,
    this.topOffscreenServiceIds = const [],
    this.bottomOffscreenServiceIds = const [],
    this.topTargetServiceId,
    this.bottomTargetServiceId,
  });

  static const hidden = _SelectedBannersState(
    showTop: false,
    showBottom: false,
  );
}

const _mockStaffList = <_Staff>[
  _Staff(0, 'Islendik usta', 'Ähli ustalar', 0),
  _Staff(1, 'Aýgül M.', 'Saç ussasy', 4.9),
  _Staff(2, 'Merjen A.', 'Dyrnak ussasy', 4.8),
  _Staff(3, 'Gözel B.', 'Gözellik ussasy', 4.7),
  _Staff(4, 'Jeren K.', 'Saç ussasy', 5.0),
];

class BookingScreen extends ConsumerStatefulWidget {
  final int salonId;
  final String salonName;
  final List<Service> services;
  final int? preselectedServiceId;

  const BookingScreen({
    super.key,
    required this.salonId,
    required this.salonName,
    required this.services,
    this.preselectedServiceId,
  });

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  int _step = 0;
  late final PageController _pageCtrl;
  bool _profileLoaded = false;
  bool _hasProfile = false;

  int get _totalSteps => _hasProfile ? 4 : 5;

  late List<int> _selectedServiceIds;
  late int _selectedServiceId;
  int _selectedStaffId = 0;
  late DateTime _selectedDate;
  String? _selectedSlot;
  List<String>? _slots;
  bool _loadingSlots = false;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final GlobalKey<_ServiceStepState> _serviceStepKey =
      GlobalKey<_ServiceStepState>();
  bool _submitting = false;
  bool _showTopServiceTitle = false;
  _SelectedBannersState _selectedBanners = _SelectedBannersState.hidden;
  int _topCycleIndex = 0;
  int _bottomCycleIndex = 0;

  late List<DateTime> _days;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    final pre = widget.preselectedServiceId;
    final hasPreselectedService =
        pre != null && widget.services.any((service) => service.id == pre);
    if (hasPreselectedService) {
      _selectedServiceId = pre;
      _selectedServiceIds = [pre];
    } else {
      _selectedServiceIds = [];
    }
    _selectedDate = DateTime.now();
    _days = List.generate(7, (i) => DateTime.now().add(Duration(days: i)));
    _loadSlots();
    _loadSavedProfile();
  }

  Future<void> _loadSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('profile_name') ?? '';
    final phone = prefs.getString('profile_phone') ?? '';
    String strippedPhone = '';
    if (phone.isNotEmpty) {
      if (phone.startsWith('+993')) {
        strippedPhone = phone.substring(4);
      } else if (phone.startsWith('993')) {
        strippedPhone = phone.substring(3);
      } else {
        strippedPhone = phone;
      }
    }
    if (mounted) {
      setState(() {
        if (name.isNotEmpty) _nameCtrl.text = name;
        if (strippedPhone.isNotEmpty) _phoneCtrl.text = strippedPhone;
        _hasProfile = name.trim().isNotEmpty && strippedPhone.trim().isNotEmpty;
        _profileLoaded = true;
      });
    }
  }

  Future<void> _loadSlots() async {
    if (_selectedServiceIds.isEmpty) {
      setState(() {
        _selectedSlot = null;
        _slots = const [];
        _loadingSlots = false;
      });
      return;
    }
    setState(() {
      _loadingSlots = true;
      _selectedSlot = null;
    });
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final slots = await ref.read(apiServiceProvider).getSlots(
            salonId: widget.salonId,
            date: dateStr,
            serviceId: _selectedServiceId,
            serviceIds: _selectedServiceIds,
            totalDurationMinutes: _selectedTotalDurationMinutes,
          );
      if (!mounted) return;
      setState(() {
        _slots = slots;
        _loadingSlots = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _slots = [];
        _loadingSlots = false;
      });
    }
  }

  List<Service> get _selectedServices {
    final selected = <Service>[];
    for (final id in _selectedServiceIds) {
      final match = _serviceById(id);
      if (match != null) selected.add(match);
    }
    return selected;
  }

  Service? _serviceById(int id) {
    for (final service in widget.services) {
      if (service.id == id) return service;
    }
    return null;
  }

  int get _selectedTotalDurationMinutes {
    return _selectedServices.fold<int>(
      0,
      (sum, service) => sum + service.durationMinutes,
    );
  }

  double get _selectedTotalPrice {
    return _selectedServices.fold<double>(
      0,
      (sum, service) => sum + (service.price ?? 0),
    );
  }

  Future<void> _toggleServiceSelection(int id) async {
    final nextIds = List<int>.from(_selectedServiceIds);
    if (nextIds.contains(id)) {
      nextIds.remove(id);
    } else {
      nextIds.add(id);
    }
    setState(() {
      _selectedServiceIds = nextIds;
      if (_selectedServiceIds.isNotEmpty) {
        _selectedServiceId = _selectedServiceIds.first;
      }
    });
    await _loadSlots();
  }

  // Sync guest controllers removed

  Future<void> _goToStep(int s) async {
    setState(() {
      _step = s;
      if (s != 0) _showTopServiceTitle = false;
    });
    _pageCtrl.animateToPage(s,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic);
  }

  bool get _canProceed {
    switch (_step) {
      case 0:
        return _selectedServiceIds.isNotEmpty;
      case 1:
        return true;
      case 2:
        return _selectedSlot != null;
      case 3:
        return true;
      case 4:
        return true;
      default:
        return false;
    }
  }

  Future<void> _onPrimaryAction() async {
    HapticFeedback.mediumImpact();
    if (!_hasProfile && _step == 3) {
      final name = _nameCtrl.text.trim();
      final phone = _phoneCtrl.text.replaceAll(RegExp(r'[^\d]'), '');
      if (name.length < 2) {
        _snack('Dowam etmek üçün adyňyzy ýazyň (iň az 2 harp).');
        return;
      }
      if (phone.length < 8) {
        _snack('Dowam etmek üçün telefon belgiňizi ýazyň (iň az 8 san).');
        return;
      }

      // Save contact info immediately to profile when pressing "Dowam et"
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_name', name);
      final fullPhone = '+993$phone';
      await prefs.setString('profile_phone', fullPhone);
      ref.read(userPhoneProvider.notifier).setPhone(fullPhone);
    }
    if (_step < _totalSteps - 1) {
      await _goToStep(_step + 1);
    } else {
      await _submit();
    }
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      final phoneDigits = _phoneCtrl.text.replaceAll(RegExp(r'[^\d]'), '');
      final fullPhone = '+993$phoneDigits';

      final booking = await ref.read(apiServiceProvider).createBooking(
            salonId: widget.salonId,
            serviceId: _selectedServiceId,
            serviceIds: _selectedServiceIds,
            guestName: _nameCtrl.text.trim(),
            guestPhone: fullPhone,
            slotAt: _selectedSlot!,
            totalDurationMinutes: _selectedTotalDurationMinutes,
            totalPrice: _selectedTotalPrice,
          );
      if (!mounted) return;
      ref.invalidate(myBookingsProvider);

      // Save name and phone to SharedPreferences and update provider
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_name', _nameCtrl.text.trim());
      await prefs.setString('profile_phone', fullPhone);
      ref.read(userPhoneProvider.notifier).setPhone(fullPhone);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        fadeSlideRoute(
          ConfirmationScreen(
            booking: booking,
            salonName: widget.salonName,
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 409) {
        _showConflict();
      } else {
        _snack(e.message);
      }
    } catch (e) {
      if (!mounted) return;
      _snack('$e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showConflict() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.m)),
        title: const Text('Wagt eýýäm bronlandy'),
        content: const Text('Başga wagt synap görüň.'),
        actions: [
          FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                _loadSlots();
              },
              child: const Text('Wagtlary täzelemek'))
        ],
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: kError,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 110, left: AppSpacing.l, right: AppSpacing.l),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
      ),
    );
  }

  String _primaryLabel() {
    if (_step == _totalSteps - 1) return 'Bron etmek';
    return 'Dowam et';
  }

  String _footerPriceLabel() {
    return '${_selectedTotalPrice.toStringAsFixed(0)} TMT';
  }

  String _footerInfoLabel() {
    final count = _selectedServiceIds.length;
    final duration = _selectedTotalDurationMinutes;
    return '$count hyzmat · $duration min';
  }

  void _onSelectedBannerTap(_SelectedBannerDirection direction) {
    final state = _serviceStepKey.currentState;
    if (state == null) return;
    if (direction == _SelectedBannerDirection.top) {
      final ids = _selectedBanners.topOffscreenServiceIds;
      if (ids.isEmpty) return;
      final index = _topCycleIndex.clamp(0, ids.length - 1);
      final id = ids[index];
      state.jumpToService(id);
      setState(() {
        _topCycleIndex =
            _topCycleIndex < ids.length - 1 ? _topCycleIndex + 1 : 0;
      });
      return;
    }
    final ids = _selectedBanners.bottomOffscreenServiceIds;
    if (ids.isEmpty) return;
    final index = _bottomCycleIndex.clamp(0, ids.length - 1);
    final id = ids[index];
    state.jumpToService(id);
    setState(() {
      _bottomCycleIndex =
          _bottomCycleIndex < ids.length - 1 ? _bottomCycleIndex + 1 : 0;
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_profileLoaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: kPrimary),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar (controls only)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 7, 9, AppSpacing.xs),
              child: Row(
                children: [
                  _BookingIconBtn(
                      icon: Icons.arrow_back_rounded,
                      onTap: () {
                        if (_step > 0) {
                          _goToStep(_step - 1);
                        } else {
                          Navigator.pop(context);
                        }
                      }),
                  const SizedBox(width: 6),
                  if (_step == 0 && _showTopServiceTitle)
                    Expanded(
                      child: Text(
                        'Hyzmatlar',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: kTextPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              height: 1.1,
                              letterSpacing: -0.5,
                            ),
                      ),
                    )
                  else
                    const Spacer(),
                  _BookingIconBtn(
                      icon: Icons.close_rounded,
                      onTap: () => Navigator.pop(context)),
                ],
              ),
            ),

            // ── Steps ──
            // -- Steps --
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: _pageCtrl,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _ServiceStep(
                        key: _serviceStepKey,
                        services: widget.services,
                        selectedIds: _selectedServiceIds.toSet(),
                        onScrollTitleVisibilityChanged: (visible) {
                          if (!mounted || _showTopServiceTitle == visible) return;
                          setState(() => _showTopServiceTitle = visible);
                        },
                        onSelectedBannersChanged: (state) {
                          if (!mounted) return;
                          final unchanged =
                              _selectedBanners.showTop == state.showTop &&
                                  _selectedBanners.showBottom == state.showBottom &&
                                  _selectedBanners.topCount == state.topCount &&
                                  _selectedBanners.bottomCount == state.bottomCount &&
                                  _selectedBanners.topOffscreenServiceIds.length ==
                                      state.topOffscreenServiceIds.length &&
                                  _selectedBanners.bottomOffscreenServiceIds.length ==
                                      state.bottomOffscreenServiceIds.length &&
                                  _selectedBanners.topTargetServiceId ==
                                      state.topTargetServiceId &&
                                  _selectedBanners.bottomTargetServiceId ==
                                      state.bottomTargetServiceId;
                          if (unchanged) return;
                          setState(() {
                            final topListChanged =
                                _selectedBanners.topOffscreenServiceIds.length !=
                                        state.topOffscreenServiceIds.length ||
                                    !_selectedBanners.topOffscreenServiceIds
                                        .every(state.topOffscreenServiceIds.contains);
                            final bottomListChanged =
                                _selectedBanners.bottomOffscreenServiceIds.length !=
                                        state.bottomOffscreenServiceIds.length ||
                                    !_selectedBanners.bottomOffscreenServiceIds
                                        .every(state.bottomOffscreenServiceIds.contains);
                            _selectedBanners = state;
                            if (topListChanged) _topCycleIndex = 0;
                            if (bottomListChanged) _bottomCycleIndex = 0;
                            if (_topCycleIndex >= state.topOffscreenServiceIds.length) {
                              _topCycleIndex = state.topOffscreenServiceIds.isEmpty
                                  ? 0
                                  : state.topOffscreenServiceIds.length - 1;
                            }
                            if (_bottomCycleIndex >= state.bottomOffscreenServiceIds.length) {
                              _bottomCycleIndex = state.bottomOffscreenServiceIds.isEmpty
                                  ? 0
                                  : state.bottomOffscreenServiceIds.length - 1;
                            }
                          });
                        },
                        onSelect: (id) {
                          _toggleServiceSelection(id);
                        },
                      ),
                      _StaffStep(
                          selectedId: _selectedStaffId,
                          onSelect: (id) => setState(() => _selectedStaffId = id)),
                      _DateTimeStep(
                        days: _days,
                        selectedDate: _selectedDate,
                        selectedSlot: _selectedSlot,
                        slots: _slots,
                        loadingSlots: _loadingSlots,
                        onSelectDate: (d) {
                          setState(() => _selectedDate = d);
                          _loadSlots();
                        },
                        onSelectSlot: (s) => setState(() => _selectedSlot = s),
                      ),
                      if (!_hasProfile)
                        _ContactStep(nameCtrl: _nameCtrl, phoneCtrl: _phoneCtrl),
                      _ReviewStep(
                        salonName: widget.salonName,
                        services: _selectedServices,
                        totalDurationMinutes: _selectedTotalDurationMinutes,
                        totalPrice: _selectedTotalPrice,
                        staffName: _mockStaffList
                            .firstWhere((s) => s.id == _selectedStaffId)
                            .name,
                        slot: _selectedSlot,
                        guestName: _nameCtrl.text.trim(),
                        guestPhone: _phoneCtrl.text.trim(),
                      ),
                    ],
                  ),
                  if (_step == 0 && _selectedServiceIds.isNotEmpty && _selectedBanners.showTop)
                    Positioned(
                      top: 72,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: _SelectedServicesBannerChip(
                          count: _selectedBanners.topCount,
                          arrow: Icons.arrow_upward_rounded,
                          onTap: () => _onSelectedBannerTap(_SelectedBannerDirection.top),
                        ),
                      ),
                    ),
                  if (_step == 0 &&
                      _selectedServiceIds.isNotEmpty &&
                      _selectedBanners.showBottom)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: _SelectedServicesBannerChip(
                          count: _selectedBanners.bottomCount,
                          arrow: Icons.arrow_downward_rounded,
                          onTap: () => _onSelectedBannerTap(_SelectedBannerDirection.bottom),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // ── Bottom CTA ──
            if (!(_step == 0 && _selectedServiceIds.isEmpty))
              BottomActionBar(
                topInfoLabel: _footerPriceLabel(),
                infoLabel: _footerInfoLabel(),
                buttonLabel: _primaryLabel(),
                onPressed: _canProceed ? _onPrimaryAction : null,
                loading: _submitting,
                showIcon: false,
              ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Step 1 — Hyzmat
// ═══════════════════════════════════════════════════════════
class _ServiceStep extends StatefulWidget {
  final List<Service> services;
  final Set<int> selectedIds;
  final ValueChanged<bool> onScrollTitleVisibilityChanged;
  final ValueChanged<_SelectedBannersState> onSelectedBannersChanged;
  final ValueChanged<int> onSelect;
  const _ServiceStep({
    super.key,
    required this.services,
    required this.selectedIds,
    required this.onScrollTitleVisibilityChanged,
    required this.onSelectedBannersChanged,
    required this.onSelect,
  });

  @override
  State<_ServiceStep> createState() => _ServiceStepState();
}

class _ServiceStepState extends State<_ServiceStep> {
  static const double _kStickyCategoryHeight = 60;
  static const double _kTopTitleTriggerOffset = 36;

  late final ScrollController _scrollController;
  late Map<String, GlobalKey> _sectionKeys;
  late Map<int, GlobalKey> _serviceRowKeys;
  late List<String> _categoryKeys;
  String? _activeCategoryKey;
  bool _isProgrammaticJump = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(_syncActiveCategoryFromScroll);
    _rebuildSections();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncActiveCategoryFromScroll();
    });
  }

  @override
  void didUpdateWidget(covariant _ServiceStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.services != widget.services) {
      _rebuildSections();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _syncActiveCategoryFromScroll();
      });
    }
    if (oldWidget.selectedIds.length != widget.selectedIds.length ||
        !oldWidget.selectedIds.containsAll(widget.selectedIds) ||
        !widget.selectedIds.containsAll(oldWidget.selectedIds)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _notifySelectedBannerPlacement();
      });
    }
  }

  void _rebuildSections() {
    _categoryKeys = serviceCategoryKeysForList(widget.services);
    _sectionKeys = {
      for (final key in _categoryKeys) key: GlobalKey(),
    };
    _serviceRowKeys = {
      for (final service in widget.services) service.id: GlobalKey(),
    };
    if (_categoryKeys.isEmpty) {
      _activeCategoryKey = null;
      return;
    }
    final initialCategory = _selectedCategoryKey();
    _activeCategoryKey = _categoryKeys.contains(initialCategory)
        ? initialCategory
        : _categoryKeys.first;
  }

  String? _selectedCategoryKey() {
    for (final service in widget.services) {
      if (widget.selectedIds.contains(service.id) &&
          service.categoryKey != null) {
        return service.categoryKey;
      }
    }
    return _categoryKeys.isNotEmpty ? _categoryKeys.first : null;
  }

  Future<void> _scrollToCategory(String categoryKey) async {
    final rootBox = context.findRenderObject() as RenderBox?;
    final sectionContext = _sectionKeys[categoryKey]?.currentContext;
    final sectionBox = sectionContext?.findRenderObject() as RenderBox?;
    if (rootBox == null ||
        sectionBox == null ||
        !_scrollController.hasClients) {
      return;
    }
    final rootTop = rootBox.localToGlobal(Offset.zero).dy;
    final sectionTop = sectionBox.localToGlobal(Offset.zero).dy;
    final targetOffset = (_scrollController.offset +
            sectionTop -
            rootTop -
            _kStickyCategoryHeight -
            8)
        .clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );
    if (_activeCategoryKey != categoryKey) {
      setState(() => _activeCategoryKey = categoryKey);
    }
    _isProgrammaticJump = true;
    _scrollController.jumpTo(targetOffset.toDouble());
    _isProgrammaticJump = false;
  }

  void jumpToService(int serviceId) {
    if (!_scrollController.hasClients) return;
    final rowContext = _serviceRowKeys[serviceId]?.currentContext;
    if (rowContext != null) {
      _isProgrammaticJump = true;
      Scrollable.ensureVisible(
        rowContext,
        duration: Duration.zero,
        alignment: 0.0,
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
      );
      _isProgrammaticJump = false;
      // postFrameCallback ensures RenderBox positions are refreshed
      // before we re-sync the active category and banner state.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _syncActiveCategoryFromScroll();
        _notifySelectedBannerPlacement();
      });
      return;
    }
    // Row not rendered yet – first scroll to the category, then retry.
    String? categoryKey;
    for (final service in widget.services) {
      if (service.id == serviceId) {
        categoryKey = service.categoryKey;
        break;
      }
    }
    if (categoryKey != null) {
      _scrollToCategory(categoryKey);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final retryContext = _serviceRowKeys[serviceId]?.currentContext;
        if (retryContext == null) return;
        _isProgrammaticJump = true;
        Scrollable.ensureVisible(
          retryContext,
          duration: Duration.zero,
          alignment: 0.0,
          alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
        );
        _isProgrammaticJump = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _syncActiveCategoryFromScroll();
          _notifySelectedBannerPlacement();
        });
      });
    }
  }

  void _syncActiveCategoryFromScroll() {
    if (!mounted) return;
    _notifyTopTitleVisibility();
    _notifySelectedBannerPlacement();
    if (_isProgrammaticJump) return;
    if (_categoryKeys.isEmpty) return;
    final rootBox = context.findRenderObject() as RenderBox?;
    if (rootBox == null) return;
    final threshold =
        rootBox.localToGlobal(Offset.zero).dy + _kStickyCategoryHeight + 12;
    var nextActive = _categoryKeys.first;
    for (final key in _categoryKeys) {
      final sectionContext = _sectionKeys[key]?.currentContext;
      final sectionBox = sectionContext?.findRenderObject() as RenderBox?;
      if (sectionBox == null) continue;
      final sectionTop = sectionBox.localToGlobal(Offset.zero).dy;
      if (sectionTop <= threshold) {
        nextActive = key;
      } else {
        break;
      }
    }
    if (nextActive != _activeCategoryKey) {
      setState(() => _activeCategoryKey = nextActive);
    }
  }

  void _notifyTopTitleVisibility() {
    if (!_scrollController.hasClients) return;
    widget.onScrollTitleVisibilityChanged(
      _scrollController.offset > _kTopTitleTriggerOffset,
    );
  }

  void _notifySelectedBannerPlacement() {
    if (!_scrollController.hasClients || widget.selectedIds.isEmpty) {
      widget.onSelectedBannersChanged(_SelectedBannersState.hidden);
      return;
    }
    final rootBox = context.findRenderObject() as RenderBox?;
    if (rootBox == null) return;
    final rootTop = rootBox.localToGlobal(Offset.zero).dy;
    final rootBottom = rootTop + rootBox.size.height;

    final topCandidates = <({int id, double rowBottom})>[];
    final bottomCandidates = <({int id, double rowTop})>[];
    bool anyRendered = false;

    // The sticky category header covers the top _kStickyCategoryHeight pixels,
    // so the truly visible area starts below it.
    final effectiveTop = rootTop + _kStickyCategoryHeight;

    for (final id in widget.selectedIds) {
      final rowContext = _serviceRowKeys[id]?.currentContext;
      final rowBox = rowContext?.findRenderObject() as RenderBox?;
      if (rowBox == null) continue;
      anyRendered = true;
      final rowTop = rowBox.localToGlobal(Offset.zero).dy;
      final rowBottom = rowTop + rowBox.size.height;
      // A row is truly visible only if it is below the sticky header and
      // above the bottom edge of the scroll area.
      final isVisible = rowBottom > effectiveTop && rowTop < rootBottom;
      if (isVisible) continue; // fully on-screen → no banner needed
      if (rowBottom <= effectiveTop) {
        // Row is above the visible area (including behind the sticky header).
        topCandidates.add((id: id, rowBottom: rowBottom));
      } else if (rowTop >= rootBottom) {
        // Row is below the visible area.
        bottomCandidates.add((id: id, rowTop: rowTop));
      }
    }

    // If nothing could be measured yet, keep current state to avoid flicker.
    if (!anyRendered) return;

    // Sort: top candidates nearest-first (highest rowBottom), bottom nearest-first.
    topCandidates.sort((a, b) => b.rowBottom.compareTo(a.rowBottom));
    bottomCandidates.sort((a, b) => a.rowTop.compareTo(b.rowTop));

    final topOrderedIds =
        topCandidates.map((e) => e.id).toList(growable: false);
    final bottomOrderedIds =
        bottomCandidates.map((e) => e.id).toList(growable: false);

    final showTop = topOrderedIds.isNotEmpty;
    final showBottom = bottomOrderedIds.isNotEmpty;

    // Hide banners when all selected services are visible on screen.
    if (!showTop && !showBottom) {
      widget.onSelectedBannersChanged(_SelectedBannersState.hidden);
      return;
    }

    widget.onSelectedBannersChanged(
      _SelectedBannersState(
        showTop: showTop,
        showBottom: showBottom,
        topCount: topOrderedIds.length,
        bottomCount: bottomOrderedIds.length,
        topOffscreenServiceIds: topOrderedIds,
        bottomOffscreenServiceIds: bottomOrderedIds,
        topTargetServiceId:
            topOrderedIds.isNotEmpty ? topOrderedIds.first : null,
        bottomTargetServiceId:
            bottomOrderedIds.isNotEmpty ? bottomOrderedIds.first : null,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_syncActiveCategoryFromScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    if (_categoryKeys.isEmpty) {
      return ListView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.l,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        children: [
          Text(
            'Hyzmatlar',
            style: tt.headlineSmall?.copyWith(
              color: kTextPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 21,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Bu bölümde hyzmat ýok',
            style: tt.bodyMedium?.copyWith(color: kTextSecondary),
          ),
        ],
      );
    }

    final promoServiceIds = widget.services.take(4).map((s) => s.id).toSet();

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.l,
              AppSpacing.xl,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hyzmatlar',
                  style: tt.headlineSmall?.copyWith(
                    color: kTextPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 21,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _BookingServiceCategoryHeaderDelegate(
            height: _kStickyCategoryHeight,
            child: _BookingServiceCategoryTabs(
              categoryKeys: _categoryKeys,
              activeCategoryKey: _activeCategoryKey ?? _categoryKeys.first,
              onTap: (categoryKey) async {
                HapticFeedback.selectionClick();
                await _scrollToCategory(categoryKey);
              },
            ),
          ),
        ),
        for (final categoryKey in _categoryKeys)
                  SliverToBoxAdapter(
            child: Padding(
              key: _sectionKeys[categoryKey],
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.l,
                AppSpacing.xl,
                0,
              ),
              child: _BookingServiceCategorySection(
                title: serviceCategoryLabel(categoryKey),
                services: widget.services
                    .where((service) => service.categoryKey == categoryKey)
                    .toList(),
                selectedIds: widget.selectedIds,
                rowKeys: _serviceRowKeys,
                promoServiceIds: promoServiceIds,
                onSelect: widget.onSelect,
              ),
            ),
          ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.xl),
        ),
      ],
    );
  }
}

class _BookingServiceCategoryHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  const _BookingServiceCategoryHeaderDelegate({
    required this.height,
    required this.child,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: kScaffoldBg,
      child: child,
    );
  }

  @override
  bool shouldRebuild(
      covariant _BookingServiceCategoryHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}

class _BookingServiceCategoryTabs extends StatefulWidget {
  final List<String> categoryKeys;
  final String activeCategoryKey;
  final ValueChanged<String> onTap;

  const _BookingServiceCategoryTabs({
    required this.categoryKeys,
    required this.activeCategoryKey,
    required this.onTap,
  });

  @override
  State<_BookingServiceCategoryTabs> createState() =>
      _BookingServiceCategoryTabsState();
}

class _BookingServiceCategoryTabsState extends State<_BookingServiceCategoryTabs> {
  final _listKey = GlobalKey();
  final _scrollController = ScrollController();
  late Map<String, GlobalKey> _itemKeys;

  @override
  void initState() {
    super.initState();
    _rebuildItemKeys();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerActiveCategory();
    });
  }

  @override
  void didUpdateWidget(covariant _BookingServiceCategoryTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryKeys.length != widget.categoryKeys.length ||
        oldWidget.categoryKeys.any((key) => !widget.categoryKeys.contains(key))) {
      _rebuildItemKeys();
    }
    if (oldWidget.activeCategoryKey != widget.activeCategoryKey ||
        oldWidget.categoryKeys != widget.categoryKeys) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _centerActiveCategory();
      });
    }
  }

  void _rebuildItemKeys() {
    _itemKeys = {
      for (final key in widget.categoryKeys) key: GlobalKey(),
    };
  }

  void _centerActiveCategory() {
    if (!mounted || !_scrollController.hasClients) return;
    final listContext = _listKey.currentContext;
    final itemContext = _itemKeys[widget.activeCategoryKey]?.currentContext;
    if (listContext == null || itemContext == null) return;

    final listBox = listContext.findRenderObject() as RenderBox?;
    final itemBox = itemContext.findRenderObject() as RenderBox?;
    if (listBox == null || itemBox == null) return;

    final listTopLeft = listBox.localToGlobal(Offset.zero);
    final itemTopLeft = itemBox.localToGlobal(Offset.zero);
    final chipCenterX = (itemTopLeft.dx - listTopLeft.dx) + (itemBox.size.width / 2);
    final viewportCenterX = listBox.size.width / 2;
    final rawTarget =
        _scrollController.offset + chipCenterX - viewportCenterX;

    final target = rawTarget.clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );

    if ((target - _scrollController.offset).abs() < 0.5) return;
    _scrollController.jumpTo(target.toDouble());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: const BoxDecoration(
        color: kScaffoldBg,
      ),
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        key: _listKey,
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: 10,
        ),
        itemCount: widget.categoryKeys.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final categoryKey = widget.categoryKeys[index];
          final selected = categoryKey == widget.activeCategoryKey;
          return Material(
            key: _itemKeys[categoryKey],
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {
                if (selected) return;
                widget.onTap(categoryKey);
              },
              child: Container(
                height: 40,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: selected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  serviceCategoryLabel(categoryKey),
                  style: tt.labelLarge?.copyWith(
                    fontFamily: tt.titleMedium?.fontFamily,
                    fontFamilyFallback: tt.titleMedium?.fontFamilyFallback,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: selected ? Colors.white : kTextSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BookingServiceCategorySection extends StatelessWidget {
  final String title;
  final List<Service> services;
  final Set<int> selectedIds;
  final Map<int, GlobalKey> rowKeys;
  final Set<int> promoServiceIds;
  final ValueChanged<int> onSelect;

  const _BookingServiceCategorySection({
    required this.title,
    required this.services,
    required this.selectedIds,
    required this.rowKeys,
    required this.promoServiceIds,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: tt.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: kTextPrimary,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 5),
        for (int index = 0; index < services.length; index++) ...[
          if (index > 0) const Divider(height: 1, color: kDetailDivider),
          _BookingServiceRow(
            service: services[index],
            isSelected: selectedIds.contains(services[index].id),
            rowKey: rowKeys[services[index].id],
            hasPromo: promoServiceIds.contains(services[index].id),
            onTap: () {
              HapticFeedback.selectionClick();
              onSelect(services[index].id);
            },
          ),
        ],
      ],
    );
  }
}

class _BookingServiceRow extends StatelessWidget {
  final Service service;
  final bool isSelected;
  final Key? rowKey;
  final bool hasPromo;
  final VoidCallback onTap;

  const _BookingServiceRow({
    required this.service,
    required this.isSelected,
    this.rowKey,
    required this.hasPromo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    const fallbackDiscountPercent = 10;

    return AnimatedContainer(
      key: rowKey,
      duration: const Duration(milliseconds: 180),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 16, 0, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${service.durationMinutes} min',
                    style: tt.labelSmall?.copyWith(
                      color: kTextSecondary,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '${service.price?.toStringAsFixed(0) ?? '?'} TMT',
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: kTextPrimary,
                          height: 1.3,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (hasPromo)
                        Text(
                            'Arzanladyş $fallbackDiscountPercent%',
                            style: tt.labelSmall?.copyWith(
                              color: AppColors.kSuccess,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(999),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : kDetailDivider,
                  ),
                  boxShadow: isSelected ? AppColors.kShadowCircleBtn : null,
                ),
                child: Icon(
                  isSelected ? Icons.check_rounded : Icons.add_rounded,
                  color: isSelected ? Colors.white : Colors.black,
                  size: 19,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Step 2 — Usta
// ═══════════════════════════════════════════════════════════
class _StaffStep extends StatelessWidget {
  final int selectedId;
  final ValueChanged<int> onSelect;
  const _StaffStep({required this.selectedId, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.l, AppSpacing.xl, AppSpacing.xl),
      children: [
        Text(
          'Ussalar',
          style: tt.headlineSmall?.copyWith(
            color: kTextPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 21,
            height: 1.1,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 25),
        ...List.generate(_mockStaffList.length, (i) {
          final s = _mockStaffList[i];
          final sel = s.id == selectedId;
          final isAny = s.id == 0;
          return Column(
            children: [
              if (i > 0) const Divider(height: 1, color: kDetailDivider),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onSelect(s.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                    child: Row(
                      children: [
                        if (isAny)
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                                color: kSurfaceBg,
                                shape: BoxShape.circle,
                                border: Border.all(color: kBorder)),
                            child: const Icon(Icons.groups_rounded,
                                color: kTextSecondary, size: 26),
                          )
                        else
                          ClipOval(
                            child: Image.asset(
                              imageForKey(null, fallbackId: s.id),
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                  width: 52,
                                  height: 52,
                                  color: kSurfaceBg,
                                  child: const Icon(Icons.person_rounded)),
                            ),
                          ),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.name,
                                  style: tt.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.2)),
                              const SizedBox(height: 2),
                              Text(s.role,
                                  style:
                                      tt.bodySmall?.copyWith(color: kTextSecondary)),
                              if (!isAny && s.rating > 0) ...[
                                const SizedBox(height: 6),
                                Row(mainAxisSize: MainAxisSize.min, children: [
                                  const Icon(Icons.star_rounded,
                                      size: 16, color: kStar),
                                  const SizedBox(width: 4),
                                  Text(s.rating.toStringAsFixed(1),
                                      style: tt.labelSmall
                                          ?.copyWith(fontWeight: FontWeight.w800)),
                                ]),
                              ],
                            ],
                          ),
                        ),
                        Icon(
                            sel
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: sel ? Colors.black : kBorderMedium,
                            size: 28),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Step 3 — Senä we wagt
// ═══════════════════════════════════════════════════════════
class _DateTimeStep extends StatelessWidget {
  final List<DateTime> days;
  final DateTime selectedDate;
  final String? selectedSlot;
  final List<String>? slots;
  final bool loadingSlots;
  final ValueChanged<DateTime> onSelectDate;
  final ValueChanged<String> onSelectSlot;

  const _DateTimeStep({
    required this.days,
    required this.selectedDate,
    required this.selectedSlot,
    required this.slots,
    required this.loadingSlots,
    required this.onSelectDate,
    required this.onSelectSlot,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final monthLabel = DateFormat('MMMM yyyy').format(selectedDate);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.l, AppSpacing.xl, AppSpacing.xl),
      children: [
        Text(
          'Sene we wagt',
          style: tt.headlineSmall?.copyWith(
            color: kTextPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 21,
            height: 1.1,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 25),
        Text(monthLabel,
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.m),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s),
            itemBuilder: (_, i) {
              final d = days[i];
              final sel = DateFormat('yyyy-MM-dd').format(d) ==
                  DateFormat('yyyy-MM-dd').format(selectedDate);
              return GestureDetector(
                onTap: () => onSelectDate(d),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52,
                  decoration: BoxDecoration(
                    color: sel ? kTextPrimary : kSurfaceBg,
                    borderRadius: BorderRadius.circular(AppRadius.m),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat('EE').format(d).toUpperCase(),
                          style: TextStyle(
                              fontSize: 11,
                              color: sel ? Colors.white70 : kTextSecondary,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('${d.day}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: sel ? Colors.white : kTextPrimary)),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: sel ? kPrimary : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Elýeterli wagtlar',
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.m),
        if (loadingSlots)
          const Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Center(child: CircularProgressIndicator(color: kPrimary)))
        else if (slots != null && slots!.isEmpty)
          Text('Bu gün üçin boş wagt ýok',
              style: tt.bodyMedium, textAlign: TextAlign.center)
        else if (slots != null)
          ..._buildGroupedSlots(tt),
      ],
    );
  }

  List<Widget> _buildGroupedSlots(TextTheme tt) {
    final grouped = <int, List<String>>{};
    for (final s in slots!) {
      final t = DateTime.parse(s);
      grouped.putIfAbsent(t.hour, () => []).add(s);
    }
    final hours = grouped.keys.toList()..sort();
    final widgets = <Widget>[];
    for (final h in hours) {
      widgets.add(Padding(
        padding:
            const EdgeInsets.only(top: AppSpacing.m, bottom: AppSpacing.xs),
        child: Text('${h.toString().padLeft(2, '0')}:00',
            style: tt.bodySmall?.copyWith(color: kTextTertiary)),
      ));
      widgets.add(Wrap(
        spacing: AppSpacing.s,
        runSpacing: AppSpacing.s,
        children: grouped[h]!.map((slot) {
          final t = DateTime.parse(slot);
          final label = DateFormat('HH:mm').format(t);
          final sel = slot == selectedSlot;
          return GestureDetector(
            onTap: () => onSelectSlot(slot),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: sel ? kTextPrimary : kSurfaceBg,
                borderRadius: BorderRadius.circular(AppRadius.m),
              ),
              child: Text(label,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: sel ? Colors.white : kTextPrimary)),
            ),
          );
        }).toList(),
      ));
    }
    return widgets;
  }
}

// ═══════════════════════════════════════════════════════════
// Step 6 — Habarlaşmak maglumatlary
// ═══════════════════════════════════════════════════════════
class _ContactStep extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  const _ContactStep({required this.nameCtrl, required this.phoneCtrl});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.l, AppSpacing.xl, AppSpacing.xl),
      children: [
        Text('Habarlaşmak üçin maglumat',
            style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.s),
        Text('Salon sizi tassyklamak üçin habarlaşar.',
            style: tt.bodyMedium?.copyWith(color: kTextSecondary)),
        const SizedBox(height: AppSpacing.xl),
        TextField(
          controller: nameCtrl,
          decoration: InputDecoration(
              labelText: 'Adyňyz',
              prefixIcon: const Icon(Icons.person_rounded)),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: AppSpacing.l),
        TextField(
          controller: phoneCtrl,
          decoration: InputDecoration(
            labelText: 'Telefon',
            prefixIcon: const Icon(Icons.phone_rounded),
            prefixText: '+993 ',
            prefixStyle: tt.bodyLarge?.copyWith(color: kTextSecondary),
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(8),
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Step 7 — Gözden geçir
// ═══════════════════════════════════════════════════════════
class _ReviewStep extends StatelessWidget {
  final String salonName;
  final List<Service> services;
  final int totalDurationMinutes;
  final double totalPrice;
  final String staffName;
  final String? slot;
  final String guestName;
  final String guestPhone;

  const _ReviewStep({
    required this.salonName,
    required this.services,
    required this.totalDurationMinutes,
    required this.totalPrice,
    required this.staffName,
    required this.slot,
    required this.guestName,
    required this.guestPhone,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final slotDt = slot != null ? DateTime.tryParse(slot!) : null;
    final dateLabel =
        slotDt != null ? DateFormat('dd MMMM yyyy').format(slotDt) : '—';
    final timeLabel = slotDt != null ? DateFormat('HH:mm').format(slotDt) : '—';
    final servicesLabel = services.isEmpty
        ? 'Hyzmat saýlanmady'
        : services.map((service) => service.name).join(', ');

    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.l, AppSpacing.xl, AppSpacing.xl),
      children: [
        Text('Bronyňyzy tassyklaň',
            style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.s),
        Text('Maglumatlaryňyzy barlaň we bron etmek basyň.',
            style: tt.bodyMedium?.copyWith(color: kTextSecondary)),
        const SizedBox(height: AppSpacing.xl),
        _RevCard(children: [
          _RevRow(
              icon: Icons.storefront_rounded, label: 'Salon', value: salonName),
          const Divider(height: 1),
          _RevRow(
            icon: Icons.content_cut_rounded,
            label: 'Hyzmatlar',
            value: servicesLabel,
            sub:
                '$totalDurationMinutes min · ${totalPrice.toStringAsFixed(0)} TMT',
          ),
          const Divider(height: 1),
          _RevRow(icon: Icons.badge_rounded, label: 'Usta', value: staffName),
        ]),
        const SizedBox(height: AppSpacing.m),
        _RevCard(children: [
          _RevRow(
              icon: Icons.calendar_month_rounded,
              label: 'Senä',
              value: dateLabel),
          const Divider(height: 1),
          _RevRow(
              icon: Icons.access_time_rounded, label: 'Wagt', value: timeLabel),
        ]),
        const SizedBox(height: AppSpacing.m),
        _RevCard(children: [
          _RevRow(
              icon: Icons.person_rounded,
              label: 'Müşderi',
              value: guestName),
          const Divider(height: 1),
          _RevRow(
              icon: Icons.phone_rounded,
              label: 'Telefon',
              value: guestPhone.startsWith('+993') ? guestPhone : '+993$guestPhone'),
        ]),
      ],
    );
  }
}

class _RevCard extends StatelessWidget {
  final List<Widget> children;
  const _RevCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: Border.all(color: kBorder),
        boxShadow: kShadowSm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _RevRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? sub;
  const _RevRow(
      {required this.icon, required this.label, required this.value, this.sub});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l, vertical: AppSpacing.m + 2),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: kSurfaceBg,
                borderRadius: BorderRadius.circular(AppRadius.s),
                border: Border.all(color: kBorder)),
            child: Icon(icon, size: 20, color: kTextSecondary),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: tt.bodySmall?.copyWith(color: kTextTertiary)),
                Text(value,
                    style:
                        tt.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                if (sub != null)
                  Text(sub!,
                      style: tt.bodySmall?.copyWith(color: kTextSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ──

class _SelectedServicesBannerChip extends StatelessWidget {
  final int count;
  final IconData arrow;
  final VoidCallback onTap;

  const _SelectedServicesBannerChip({
    required this.count,
    required this.arrow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: kPrimary, width: 1.5),
            boxShadow: kShadowSm,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$count hyzmat saýlandy',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: kPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                ),
                const SizedBox(width: 10),
                Icon(arrow, color: kPrimary, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BookingIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _BookingIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      highlightShape: BoxShape.circle,
      child: Padding(
        padding: const EdgeInsets.only(top: 1),
        child: SizedBox(
          width: 43,
          height: 43,
          child: Icon(icon, size: 23, color: kTextPrimary),
        ),
      ),
    );
  }
}

