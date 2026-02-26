import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/providers.dart';
import '../models/booking.dart';
import '../theme.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  final _phoneCtrl = TextEditingController();
  List<Booking>? _bookings;
  bool _loading = false;
  String? _error;
  bool _searched = false;

  @override
  void initState() {
    super.initState();
    _loadSavedPhone();
  }

  Future<void> _loadSavedPhone() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('profile_phone') ?? '';
    if (phone.isNotEmpty) {
      _phoneCtrl.text = phone;
      _search();
    }
  }

  Future<void> _search() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) return;
    setState(() { _loading = true; _error = null; _searched = true; });
    try {
      final bookings = await ref.read(apiServiceProvider).getBookings(phone);
      if (!mounted) return;
      setState(() { _bookings = bookings; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Meniň bronlarym')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(
                      hintText: '+993...',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(onPressed: _loading ? null : _search, child: const Text('Görmek')),
              ],
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text('Ýalňyşlyk: $_error', style: tt.bodyMedium))
                    : !_searched
                        ? _emptyPlaceholder(context, ref, tt, 'Telefon nomeriňizi giriziň we "Görmek" basyň', showSalonButton: false)
                        : (_bookings == null || _bookings!.isEmpty)
                            ? _emptyPlaceholder(context, ref, tt, 'Siziň entäk bronyňyz ýok', showSalonButton: true)
                            : _buildList(tt, now),
          ),
        ],
      ),
    );
  }

  Widget _emptyPlaceholder(BuildContext context, WidgetRef ref, TextTheme tt, String msg, {required bool showSalonButton}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_outlined, size: 72, color: kPrimary.withValues(alpha: 0.25)),
            const SizedBox(height: 24),
            Text(msg, style: tt.bodyLarge?.copyWith(height: 1.4), textAlign: TextAlign.center),
            if (showSalonButton) ...[
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: () => ref.read(selectedTabIndexProvider.notifier).state = 0,
                icon: const Icon(Icons.storefront_rounded, size: 20),
                label: const Text('Salonlara geçmek'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildList(TextTheme tt, DateTime now) {
    final upcoming = <Booking>[];
    final past = <Booking>[];
    for (final b in _bookings!) {
      if (b.slotAt.isAfter(now)) {
        upcoming.add(b);
      } else {
        past.add(b);
      }
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        if (upcoming.isNotEmpty) ...[
          Text('Geljekki', style: tt.titleMedium),
          const SizedBox(height: 8),
          ...upcoming.map((b) => _BookingTile(booking: b, isPast: false)),
        ],
        if (past.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('Tamamlandy', style: tt.titleMedium?.copyWith(color: Colors.grey)),
          const SizedBox(height: 8),
          ...past.map((b) => _BookingTile(booking: b, isPast: true)),
        ],
      ],
    );
  }
}

class _BookingTile extends StatelessWidget {
  final Booking booking;
  final bool isPast;
  const _BookingTile({required this.booking, required this.isPast});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final dateStr = DateFormat('dd MMM yyyy, HH:mm').format(booking.slotAt);

    return Opacity(
      opacity: isPast ? 0.55 : 1.0,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (isPast ? Colors.grey : kPrimary).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isPast ? Icons.check_circle_outline : Icons.calendar_today,
                  color: isPast ? Colors.grey : kPrimary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bron #${booking.id}', style: tt.titleMedium),
                    const SizedBox(height: 4),
                    Text(dateStr, style: tt.bodyMedium),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPast
                      ? Colors.grey.withValues(alpha: 0.15)
                      : kPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isPast ? 'Tamamlandy' : booking.status,
                  style: tt.labelLarge?.copyWith(
                    color: isPast ? Colors.grey : kPrimary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
