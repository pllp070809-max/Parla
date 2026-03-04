import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/providers.dart';
import '../models/salon.dart';
import '../services/api_service.dart';
import '../theme.dart';
import 'confirmation_screen.dart';

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
  late int _selectedServiceId;
  late DateTime _selectedDate;
  String? _selectedSlot;
  List<String>? _slots;
  bool _loadingSlots = false;
  String? _slotsError;

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _submitting = false;
  bool _autoValidate = false;

  late List<DateTime> _days;

  @override
  void initState() {
    super.initState();
    _selectedServiceId = widget.preselectedServiceId ?? widget.services.first.id;
    _selectedDate = DateTime.now();
    _days = List.generate(7, (i) => DateTime.now().add(Duration(days: i)));
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
    setState(() { _loadingSlots = true; _slotsError = null; _selectedSlot = null; });
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final slots = await ref.read(apiServiceProvider).getSlots(
        salonId: widget.salonId, date: dateStr, serviceId: _selectedServiceId,
      );
      if (!mounted) return;
      setState(() { _slots = slots; _loadingSlots = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _slotsError = e.toString(); _loadingSlots = false; });
    }
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Adyňyzy ýazyň';
    if (v.trim().length < 2) return 'Iň az 2 harp bolmaly';
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Telefon nomeriňizi ýazyň';
    final digits = v.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length < 8) return 'Nädogry telefon nomeri';
    return null;
  }

  Future<void> _submit() async {
    setState(() => _autoValidate = true);
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Wagty saýlaň'),
          backgroundColor: kError,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusMd)),
        ),
      );
      return;
    }

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
        _showConflictDialog();
      } else {
        _showErrorSnackBar(e.message);
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('$e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showConflictDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusLg)),
        icon: Container(
          width: 56, height: 56,
          decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.12), shape: BoxShape.circle),
          child: const Icon(Icons.event_busy_rounded, color: Colors.orange, size: 28),
        ),
        title: const Text('Wagt eýýäm bronlandy'),
        content: const Text('Bu wagt eýýäm başga müşderi tarapyndan saýlandy. Başga wagt synap görüň.'),
        actions: [
          FilledButton(
            onPressed: () { Navigator.pop(ctx); _loadSlots(); },
            child: const Text('Wagtlary täzelemek'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: kError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusMd)),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final selectedSvc = widget.services.firstWhere((s) => s.id == _selectedServiceId);

    return Scaffold(
      appBar: AppBar(title: Text(widget.salonName)),
      body: Form(
        key: _formKey,
        autovalidateMode: _autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: kSpaceXl, vertical: kSpaceLg),
          children: [
            Text('Hyzmat saýlaň', style: tt.titleMedium),
            const SizedBox(height: kSpaceSm + 2),
            Wrap(
              spacing: kSpaceSm,
              runSpacing: kSpaceSm,
              children: widget.services.map((svc) {
                final selected = svc.id == _selectedServiceId;
                return ChoiceChip(
                  label: Text(svc.name),
                  selected: selected,
                  selectedColor: kPrimary.withValues(alpha: 0.15),
                  onSelected: (_) {
                    setState(() => _selectedServiceId = svc.id);
                    _loadSlots();
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: kSpaceSm),
            Text(
              '${selectedSvc.durationMinutes} min'
              '${selectedSvc.price != null ? '  •  ${selectedSvc.price!.toStringAsFixed(0)} TMT' : ''}',
              style: tt.bodyMedium,
            ),

            const SizedBox(height: kSpace2xl),
            Text('Gün saýlaň', style: tt.titleMedium),
            const SizedBox(height: kSpaceSm + 2),
            SizedBox(
              height: 76,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _days.length,
                separatorBuilder: (_, __) => const SizedBox(width: kSpaceSm + 2),
                itemBuilder: (_, i) {
                  final d = _days[i];
                  final selected = DateFormat('yyyy-MM-dd').format(d) ==
                      DateFormat('yyyy-MM-dd').format(_selectedDate);
                  final dayLabel = i == 0 ? 'Şu gün' : i == 1 ? 'Ertir' : DateFormat('dd MMM').format(d);
                  final weekday = DateFormat('EEE').format(d);
                  return GestureDetector(
                    onTap: () { setState(() => _selectedDate = d); _loadSlots(); },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      width: 64,
                      decoration: BoxDecoration(
                        color: selected ? kPrimary : kPrimary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(kRadiusMd + 2),
                        boxShadow: selected ? kShadowMd : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(weekday, style: tt.bodyMedium?.copyWith(
                            color: selected ? Colors.white70 : null, fontSize: 12)),
                          const SizedBox(height: kSpaceXs),
                          Text(dayLabel, textAlign: TextAlign.center,
                            style: tt.labelLarge?.copyWith(
                              color: selected ? Colors.white : kPrimary, fontSize: 13)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: kSpace2xl),
            Text('Wagt saýlaň', style: tt.titleMedium),
            const SizedBox(height: kSpaceSm + 2),
            if (_loadingSlots)
              const Padding(padding: EdgeInsets.all(kSpaceXl), child: Center(child: CircularProgressIndicator(color: kPrimary)))
            else if (_slotsError != null)
              Text('Ýalňyşlyk: $_slotsError', style: tt.bodyMedium?.copyWith(color: kError))
            else if (_slots != null && _slots!.isEmpty)
              Padding(
                padding: const EdgeInsets.all(kSpaceLg),
                child: Text('Bu gün üçin boş wagt ýok', style: tt.bodyMedium, textAlign: TextAlign.center),
              )
            else if (_slots != null)
              Wrap(
                spacing: kSpaceSm,
                runSpacing: kSpaceSm,
                children: _slots!.map((slot) {
                  final t = DateTime.parse(slot);
                  final label = DateFormat('HH:mm').format(t);
                  final selected = slot == _selectedSlot;
                  return ChoiceChip(
                    label: Text(label),
                    selected: selected,
                    selectedColor: kPrimary.withValues(alpha: 0.15),
                    onSelected: (_) => setState(() => _selectedSlot = slot),
                  );
                }).toList(),
              ),

            const SizedBox(height: kSpace2xl),
            Text('Siziň maglumatlaryňyz', style: tt.titleMedium),
            const SizedBox(height: kSpaceSm + 2),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Adyňyz', prefixIcon: Icon(Icons.person_outline)),
              textCapitalization: TextCapitalization.words,
              validator: _validateName,
            ),
            const SizedBox(height: kSpaceMd),
            TextFormField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(labelText: 'Telefon', prefixIcon: Icon(Icons.phone_outlined), hintText: '+993...'),
              keyboardType: TextInputType.phone,
              validator: _validatePhone,
            ),

            const SizedBox(height: kSpace3xl - 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 52,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Tassyklamak'),
              ),
            ),
            const SizedBox(height: kSpace2xl),
          ],
        ),
      ),
    );
  }
}
