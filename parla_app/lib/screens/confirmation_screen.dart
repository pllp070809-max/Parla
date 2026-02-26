import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import '../theme.dart';

class ConfirmationScreen extends StatelessWidget {
  final Booking booking;
  final String salonName;
  final String serviceName;

  const ConfirmationScreen({
    super.key,
    required this.booking,
    required this.salonName,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final dateStr = DateFormat('dd MMMM yyyy, HH:mm').format(booking.slotAt);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: kPrimary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, size: 48, color: kPrimary),
              ),
              const SizedBox(height: 24),
              Text('Bron edildi!', style: tt.headlineMedium?.copyWith(color: kPrimary)),
              const SizedBox(height: 32),

              _InfoRow(label: 'Salon', value: salonName),
              _InfoRow(label: 'Hyzmat', value: serviceName),
              _InfoRow(label: 'Wagt', value: dateStr),
              _InfoRow(label: 'Müşderi', value: booking.guestName),
              _InfoRow(label: 'Telefon', value: booking.guestPhone),
              _InfoRow(label: 'Bron #', value: booking.id.toString()),

              const Spacer(flex: 3),

              ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                child: const Text('Sahypa'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                child: const Text('Meniň bronlarym'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(label, style: tt.bodyMedium)),
          Expanded(child: Text(value, style: tt.bodyLarge)),
        ],
      ),
    );
  }
}
