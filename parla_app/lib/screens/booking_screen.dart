import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/providers.dart';
import '../models/salon.dart';
import '../services/api_service.dart';
import '../app_radius.dart';
import '../app_spacing.dart';
import '../theme.dart';
import '../utils/salon_images.dart';
import 'confirmation_screen.dart';

class _Staff {
  final int id;
  final String name;
  final String role;
  final double rating;
  const _Staff(this.id, this.name, this.role, this.rating);
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
  static const int _kTotalSteps = 7;

  final _stepTitles = const [
    'Hyzmat saylaň',
    'Usta saylaň',
    'Senä we wagt',
    'Näçe adam?',
    'Adamlar',
    'Maglumatlaryňyz',
    'Gözden geçiriň',
  ];

  int _step = 0;
  late final PageController _pageCtrl;

  late Set<int> _selectedServiceIds;
  late int _selectedServiceId;
  int _selectedStaffId = 0;
  late DateTime _selectedDate;
  String? _selectedSlot;
  List<String>? _slots;
  bool _loadingSlots = false;
  int _guestCount = 1;
  late List<TextEditingController> _guestCtrls;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _submitting = false;

  late List<DateTime> _days;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    final pre = widget.preselectedServiceId ?? widget.services.first.id;
    _selectedServiceId = pre;
    _selectedServiceIds = {pre};
    _selectedDate = DateTime.now();
    _days = List.generate(7, (i) => DateTime.now().add(Duration(days: i)));
    _guestCtrls = [TextEditingController()];
    _loadSlots();
    _loadSavedProfile();
  }

  Future<void> _loadSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('profile_name') ?? '';
    final phone = prefs.getString('profile_phone') ?? '';
    if (name.isNotEmpty) _nameCtrl.text = name;
    if (phone.isNotEmpty) _phoneCtrl.text = phone;
  }

  Future<void> _loadSlots() async {
    setState(() { _loadingSlots = true; _selectedSlot = null; });
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final slots = await ref.read(apiServiceProvider).getSlots(
        salonId: widget.salonId, date: dateStr, serviceId: _selectedServiceId,
      );
      if (!mounted) return;
      setState(() { _slots = slots; _loadingSlots = false; });
    } catch (_) {
      if (!mounted) return;
      setState(() { _slots = []; _loadingSlots = false; });
    }
  }

  void _syncGuestControllers() {
    while (_guestCtrls.length < _guestCount) {
      _guestCtrls.add(TextEditingController());
    }
    while (_guestCtrls.length > _guestCount) {
      _guestCtrls.removeLast().dispose();
    }
  }

  Future<void> _goToStep(int s) async {
    setState(() => _step = s);
    _pageCtrl.animateToPage(s, duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
  }

  bool get _canProceed {
    switch (_step) {
      case 0: return _selectedServiceIds.isNotEmpty;
      case 1: return true;
      case 2: return _selectedSlot != null;
      case 3: return _guestCount >= 1;
      case 4: return true;
      case 5: return _nameCtrl.text.trim().length >= 2 && _phoneCtrl.text.replaceAll(RegExp(r'[^\d]'), '').length >= 8;
      case 6: return true;
      default: return false;
    }
  }

  Future<void> _onPrimaryAction() async {
    HapticFeedback.mediumImpact();
    if (_step < _kTotalSteps - 1) {
      if (_step == 3) _syncGuestControllers();
      await _goToStep(_step + 1);
    } else {
      await _submit();
    }
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      final booking = await ref.read(apiServiceProvider).createBooking(
        salonId: widget.salonId,
        serviceId: _selectedServiceId,
        guestName: _nameCtrl.text.trim(),
        guestPhone: _phoneCtrl.text.trim(),
        slotAt: _selectedSlot!,
      );
      if (!mounted) return;
      ref.invalidate(myBookingsProvider);
      final svc = widget.services.firstWhere((s) => s.id == _selectedServiceId);
      Navigator.pushReplacement(
        context,
        fadeSlideRoute(ConfirmationScreen(booking: booking, salonName: widget.salonName, serviceName: svc.name)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
        title: const Text('Wagt eýýäm bronlandy'),
        content: const Text('Başga wagt synap görüň.'),
        actions: [FilledButton(onPressed: () { Navigator.pop(ctx); _loadSlots(); }, child: const Text('Wagtlary täzelemek'))],
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: kError));
  }

  String _primaryLabel() {
    if (_step == _kTotalSteps - 1) return 'Bron etmek';
    return 'Dowam et';
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    for (final c in _guestCtrls) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──
            DecoratedBox(
              decoration: BoxDecoration(color: kCardBg, boxShadow: kShadowDownSm),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xs, AppSpacing.s - 2, AppSpacing.xs, AppSpacing.m - 2),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _BookingIconBtn(icon: Icons.arrow_back_rounded, onTap: () {
                          if (_step > 0) { _goToStep(_step - 1); } else { Navigator.pop(context); }
                        }),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.salonName, style: tt.bodySmall?.copyWith(color: kTextSecondary)),
                              Text(_stepTitles[_step], style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(AppRadius.pill)),
                          child: Text('Ädim ${_step + 1} / $_kTotalSteps', style: tt.labelSmall?.copyWith(color: kCardBg, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 6),
                        _BookingIconBtn(icon: Icons.close_rounded, onTap: () => Navigator.pop(context)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _BookingSegmentProgress(current: _step, total: _kTotalSteps),
                  ],
                ),
              ),
            ),

            // ── Steps ──
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _ServiceStep(services: widget.services, selectedIds: _selectedServiceIds, onSelect: (id) {
                    setState(() {
                      if (_selectedServiceIds.contains(id)) { _selectedServiceIds.remove(id); } else { _selectedServiceIds.add(id); }
                      _selectedServiceId = id;
                    });
                  }),
                  _StaffStep(selectedId: _selectedStaffId, onSelect: (id) => setState(() => _selectedStaffId = id)),
                  _DateTimeStep(
                    days: _days, selectedDate: _selectedDate, selectedSlot: _selectedSlot,
                    slots: _slots, loadingSlots: _loadingSlots,
                    onSelectDate: (d) { setState(() => _selectedDate = d); _loadSlots(); },
                    onSelectSlot: (s) => setState(() => _selectedSlot = s),
                  ),
                  _GuestCountStep(count: _guestCount, onChanged: (c) => setState(() => _guestCount = c)),
                  _GuestNamesStep(count: _guestCount, controllers: _guestCtrls),
                  _ContactStep(nameCtrl: _nameCtrl, phoneCtrl: _phoneCtrl),
                  _ReviewStep(
                    salonName: widget.salonName,
                    service: widget.services.firstWhere((s) => s.id == _selectedServiceId),
                    staffName: _mockStaffList.firstWhere((s) => s.id == _selectedStaffId).name,
                    slot: _selectedSlot,
                    guestCount: _guestCount,
                  ),
                ],
              ),
            ),

            // ── Bottom CTA ──
            Material(
              child: DecoratedBox(
                decoration: BoxDecoration(color: kCardBg, boxShadow: kShadowUpMd),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.m, AppSpacing.xl, AppSpacing.l),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: (_canProceed && !_submitting) ? _onPrimaryAction : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: kTextPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
                      ),
                      child: _submitting
                          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                          : Text(_primaryLabel(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
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

// ═══════════════════════════════════════════════════════════
// Step 1 — Hyzmat
// ═══════════════════════════════════════════════════════════
class _ServiceStep extends StatelessWidget {
  final List<Service> services;
  final Set<int> selectedIds;
  final ValueChanged<int> onSelect;
  const _ServiceStep({required this.services, required this.selectedIds, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.l, AppSpacing.xl, AppSpacing.xl),
      itemCount: services.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
      itemBuilder: (_, i) {
        final s = services[i];
        final sel = selectedIds.contains(s.id);
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () { HapticFeedback.selectionClick(); onSelect(s.id); },
            borderRadius: BorderRadius.circular(AppRadius.m),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.all(AppSpacing.l),
              decoration: BoxDecoration(
                color: sel ? kPrimarySoft : kCardBg,
                borderRadius: BorderRadius.circular(AppRadius.m),
                border: Border.all(color: sel ? kPrimary.withValues(alpha: 0.45) : kBorder, width: sel ? 1.5 : 1),
                boxShadow: sel ? kShadowMd : kShadowSm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.name, style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(
                          '${s.durationMinutes} min  ·  ${s.price != null ? '${s.price!.toStringAsFixed(0)} TMT' : ''}',
                          style: tt.bodySmall?.copyWith(color: kTextSecondary),
                        ),
                      ],
                    ),
                  ),
                  Icon(sel ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: sel ? kPrimary : kBorderMedium, size: 28),
                ],
              ),
            ),
          ),
        );
      },
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
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.l, AppSpacing.xl, AppSpacing.xl),
      itemCount: _mockStaffList.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
      itemBuilder: (_, i) {
        final s = _mockStaffList[i];
        final sel = s.id == selectedId;
        final isAny = s.id == 0;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () { HapticFeedback.selectionClick(); onSelect(s.id); },
            borderRadius: BorderRadius.circular(AppRadius.m),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.m + 2),
              decoration: BoxDecoration(
                color: sel ? kPrimarySoft : kCardBg,
                borderRadius: BorderRadius.circular(AppRadius.m),
                border: Border.all(color: sel ? kPrimary.withValues(alpha: 0.45) : kBorder, width: sel ? 1.5 : 1),
                boxShadow: sel ? kShadowMd : kShadowSm,
              ),
              child: Row(
                children: [
                  if (isAny)
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(color: sel ? kCardBg : kSurfaceBg, shape: BoxShape.circle, border: Border.all(color: sel ? kPrimary.withValues(alpha: 0.35) : kBorder)),
                      child: Icon(Icons.groups_rounded, color: sel ? kPrimary : kTextSecondary, size: 26),
                    )
                  else
                    ClipOval(
                      child: Image.asset(
                        imageForKey(null, fallbackId: s.id),
                        width: 52, height: 52, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 52, height: 52, color: kSurfaceBg, child: const Icon(Icons.person_rounded)),
                      ),
                    ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.name, style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.2)),
                        const SizedBox(height: 2),
                        Text(s.role, style: tt.bodySmall?.copyWith(color: kTextSecondary)),
                        if (!isAny && s.rating > 0) ...[
                          const SizedBox(height: 6),
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.star_rounded, size: 16, color: kStar),
                            const SizedBox(width: 4),
                            Text(s.rating.toStringAsFixed(1), style: tt.labelSmall?.copyWith(fontWeight: FontWeight.w800)),
                          ]),
                        ],
                      ],
                    ),
                  ),
                  Icon(sel ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: sel ? kPrimary : kBorderMedium, size: 28),
                ],
              ),
            ),
          ),
        );
      },
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
    required this.days, required this.selectedDate, required this.selectedSlot,
    required this.slots, required this.loadingSlots,
    required this.onSelectDate, required this.onSelectSlot,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final monthLabel = DateFormat('MMMM yyyy').format(selectedDate);

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.l, AppSpacing.xl, AppSpacing.xl),
      children: [
        Text(monthLabel, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.m),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s),
            itemBuilder: (_, i) {
              final d = days[i];
              final sel = DateFormat('yyyy-MM-dd').format(d) == DateFormat('yyyy-MM-dd').format(selectedDate);
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
                      Text(DateFormat('EE').format(d).toUpperCase(), style: TextStyle(fontSize: 11, color: sel ? Colors.white70 : kTextSecondary, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('${d.day}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: sel ? Colors.white : kTextPrimary)),
                      if (sel) Container(margin: const EdgeInsets.only(top: 4), width: 6, height: 6, decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Elýeterli wagtlar', style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.m),
        if (loadingSlots)
          const Padding(padding: EdgeInsets.all(AppSpacing.xl), child: Center(child: CircularProgressIndicator(color: kPrimary)))
        else if (slots != null && slots!.isEmpty)
          Text('Bu gün üçin boş wagt ýok', style: tt.bodyMedium, textAlign: TextAlign.center)
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
        padding: const EdgeInsets.only(top: AppSpacing.m, bottom: AppSpacing.xs),
        child: Text('${h.toString().padLeft(2, '0')}:00', style: tt.bodySmall?.copyWith(color: kTextTertiary)),
      ));
      widgets.add(Wrap(
        spacing: AppSpacing.s, runSpacing: AppSpacing.s,
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
              child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: sel ? Colors.white : kTextPrimary)),
            ),
          );
        }).toList(),
      ));
    }
    return widgets;
  }
}

// ═══════════════════════════════════════════════════════════
// Step 4 — Näçe adam?
// ═══════════════════════════════════════════════════════════
class _GuestCountStep extends StatelessWidget {
  final int count;
  final ValueChanged<int> onChanged;
  const _GuestCountStep({required this.count, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: kSurfaceBg, shape: BoxShape.circle),
            child: const Icon(Icons.groups_rounded, size: 40, color: kPrimary),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Myhmanlaryň sany', style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSpacing.m),
          Text(
            'Bir wagtda birnäçe adam üçin bron edip bilersiňiz.\nHer myhman üçin soňraky ädimde ady görkezip bilersiňiz.',
            textAlign: TextAlign.center,
            style: tt.bodyMedium?.copyWith(color: kTextSecondary, height: 1.5),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CounterBtn(icon: Icons.remove_rounded, onTap: count > 1 ? () => onChanged(count - 1) : null),
              SizedBox(
                width: 80,
                child: Column(
                  children: [
                    Text('$count', style: tt.headlineLarge?.copyWith(fontWeight: FontWeight.w900)),
                    Text('adam', style: tt.bodySmall?.copyWith(color: kTextSecondary)),
                  ],
                ),
              ),
              _CounterBtn(icon: Icons.add_rounded, onTap: count < 10 ? () => onChanged(count + 1) : null, filled: true),
            ],
          ),
          const SizedBox(height: AppSpacing.l),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline_rounded, size: 16, color: kTextTertiary),
              const SizedBox(width: 6),
              Text('Iň köp 10 myhman', style: tt.bodySmall?.copyWith(color: kTextTertiary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool filled;
  const _CounterBtn({required this.icon, this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 52, height: 52,
        decoration: BoxDecoration(
          color: filled ? (enabled ? kTextPrimary : kBorderMedium) : kSurfaceBg,
          shape: BoxShape.circle,
          border: filled ? null : Border.all(color: enabled ? kBorderMedium : kBorder),
        ),
        child: Icon(icon, color: filled ? Colors.white : (enabled ? kTextPrimary : kTextTertiary), size: 24),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Step 5 — Adamlar (myhman atlary)
// ═══════════════════════════════════════════════════════════
class _GuestNamesStep extends StatelessWidget {
  final int count;
  final List<TextEditingController> controllers;
  const _GuestNamesStep({required this.count, required this.controllers});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.l, AppSpacing.xl, AppSpacing.xl),
      children: [
        Text('Myhmanlaryň maglumaty', style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.s),
        Text('Islege görä dolduryň — salon myhmanlaryň sanawyny görüp bilýär.', style: tt.bodyMedium?.copyWith(color: kTextSecondary)),
        const SizedBox(height: AppSpacing.m),
        Container(
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(color: kSurfaceBg, borderRadius: BorderRadius.circular(AppRadius.m)),
          child: Row(
            children: [
              const Icon(Icons.verified_rounded, color: kPrimary, size: 22),
              const SizedBox(width: AppSpacing.s),
              Expanded(child: Text('Maglumatlar diňe brony tassyklamak we habarlaşmak üçin ulanylýar.', style: tt.bodySmall?.copyWith(color: kTextSecondary))),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        for (int i = 0; i < count && i < controllers.length; i++) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(AppRadius.m), border: Border.all(color: kBorder), boxShadow: kShadowSm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: kSurfaceBg, borderRadius: BorderRadius.circular(AppRadius.s), border: Border.all(color: kBorder)),
                  alignment: Alignment.center,
                  child: Text('${i + 1}', style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Adyňyz', style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      Text('Islege görä', style: tt.bodySmall?.copyWith(color: kTextTertiary)),
                      const SizedBox(height: AppSpacing.s),
                      TextField(
                        controller: controllers[i],
                        decoration: InputDecoration(hintText: 'Meselem: Aýgül Amanowa', hintStyle: tt.bodyMedium?.copyWith(color: kTextTertiary)),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (i < count - 1) const SizedBox(height: AppSpacing.m),
        ],
      ],
    );
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
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.l, AppSpacing.xl, AppSpacing.xl),
      children: [
        Text('Habarlaşmak üçin maglumat', style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.s),
        Text('Salon sizi tassyklamak üçin habarlaşar.', style: tt.bodyMedium?.copyWith(color: kTextSecondary)),
        const SizedBox(height: AppSpacing.xl),
        TextField(
          controller: nameCtrl,
          decoration: InputDecoration(labelText: 'Adyňyz', prefixIcon: const Icon(Icons.person_rounded)),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: AppSpacing.l),
        TextField(
          controller: phoneCtrl,
          decoration: InputDecoration(labelText: 'Telefon', prefixIcon: const Icon(Icons.phone_rounded), hintText: '+993...'),
          keyboardType: TextInputType.phone,
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
  final Service service;
  final String staffName;
  final String? slot;
  final int guestCount;

  const _ReviewStep({
    required this.salonName, required this.service, required this.staffName,
    required this.slot, required this.guestCount,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final slotDt = slot != null ? DateTime.tryParse(slot!) : null;
    final dateLabel = slotDt != null ? DateFormat('dd MMMM yyyy').format(slotDt) : '—';
    final timeLabel = slotDt != null ? DateFormat('HH:mm').format(slotDt) : '—';

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.l, AppSpacing.xl, AppSpacing.xl),
      children: [
        Text('Bronyňyzy tassyklaň', style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.s),
        Text('Maglumatlaryňyzy barlaň we bron etmek basyň.', style: tt.bodyMedium?.copyWith(color: kTextSecondary)),
        const SizedBox(height: AppSpacing.xl),
        _RevCard(children: [
          _RevRow(icon: Icons.storefront_rounded, label: 'Salon', value: salonName),
          const Divider(height: 1),
          _RevRow(icon: Icons.content_cut_rounded, label: 'Hyzmat', value: service.name, sub: '${service.durationMinutes} min · ${service.price?.toStringAsFixed(0) ?? ''} TMT'),
          const Divider(height: 1),
          _RevRow(icon: Icons.badge_rounded, label: 'Usta', value: staffName),
        ]),
        const SizedBox(height: AppSpacing.m),
        _RevCard(children: [
          _RevRow(icon: Icons.calendar_month_rounded, label: 'Senä', value: dateLabel),
          const Divider(height: 1),
          _RevRow(icon: Icons.access_time_rounded, label: 'Wagt', value: timeLabel),
        ]),
        const SizedBox(height: AppSpacing.m),
        _RevCard(children: [
          _RevRow(icon: Icons.groups_rounded, label: 'Adam sany', value: '$guestCount'),
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
        color: kCardBg, borderRadius: BorderRadius.circular(AppRadius.m),
        border: Border.all(color: kBorder), boxShadow: kShadowSm,
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
  const _RevRow({required this.icon, required this.label, required this.value, this.sub});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.m + 2),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: kSurfaceBg, borderRadius: BorderRadius.circular(AppRadius.s), border: Border.all(color: kBorder)),
            child: Icon(icon, size: 20, color: kTextSecondary),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: tt.bodySmall?.copyWith(color: kTextTertiary)),
                Text(value, style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                if (sub != null) Text(sub!, style: tt.bodySmall?.copyWith(color: kTextSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ──

class _BookingIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _BookingIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(shape: BoxShape.circle, color: kSurfaceBg, border: Border.all(color: kBorder)),
        child: Icon(icon, size: 20, color: kTextPrimary),
      ),
    );
  }
}

class _BookingSegmentProgress extends StatelessWidget {
  final int current;
  final int total;
  const _BookingSegmentProgress({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      child: Row(
        children: List.generate(total, (i) {
          final done = i < current;
          final active = i == current;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: active ? kPrimary : done ? kTextPrimary : kBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
