import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import '../theme.dart';

class ConfirmationScreen extends StatefulWidget {
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
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scale = Tween(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _fade = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final dateStr = DateFormat('dd MMMM yyyy, HH:mm').format(widget.booking.slotAt);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kSpace3xl - 4),
          child: Column(
            children: [
              const Spacer(flex: 2),
              _ParlaAnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) => Opacity(
                  opacity: _fade.value,
                  child: Transform.scale(
                    scale: _scale.value,
                    child: Container(
                      width: 96, height: 96,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [kSuccess.withValues(alpha: 0.2), kSuccess.withValues(alpha: 0.08)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded, size: 52, color: kSuccess),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kSpace2xl),
              Text('Bron edildi!', style: tt.headlineMedium?.copyWith(color: kSuccess)),
              const SizedBox(height: kSpace3xl),

              _InfoRow(label: 'Salon', value: widget.salonName),
              _InfoRow(label: 'Hyzmat', value: widget.serviceName),
              _InfoRow(label: 'Wagt', value: dateStr),
              _InfoRow(label: 'Müşderi', value: widget.booking.guestName),
              _InfoRow(label: 'Telefon', value: widget.booking.guestPhone),
              _InfoRow(label: 'Bron #', value: widget.booking.id.toString()),

              const Spacer(flex: 3),

              ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                child: const Text('Sahypa'),
              ),
              const SizedBox(height: kSpaceMd),
              TextButton(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                child: const Text('Meniň bronlarym'),
              ),
              const SizedBox(height: kSpace3xl),
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
      padding: const EdgeInsets.symmetric(vertical: kSpaceSm - 2),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(label, style: tt.bodyMedium)),
          Expanded(child: Text(value, style: tt.bodyLarge)),
        ],
      ),
    );
  }
}

class _ParlaAnimatedBuilder extends StatelessWidget {
  final Listenable animation;
  final Widget Function(BuildContext, Widget?) builder;
  const _ParlaAnimatedBuilder({required this.animation, required this.builder});

  @override
  Widget build(BuildContext context) => _Inner(listenable: animation, builder: builder);
}

class _Inner extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  const _Inner({required super.listenable, required this.builder});

  @override
  Widget build(BuildContext context) => builder(context, null);
}
