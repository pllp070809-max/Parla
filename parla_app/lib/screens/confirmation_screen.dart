import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import '../app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../widgets/bottom_nav.dart';
import '../theme.dart';

class ConfirmationScreen extends StatefulWidget {
  final Booking booking;
  final String salonName;

  const ConfirmationScreen({
    super.key,
    required this.booking,
    required this.salonName,
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
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final dateStr = DateFormat('dd MMMM yyyy, HH:mm').format(widget.booking.slotAt);
    final serviceLabel = widget.booking.serviceSummary(maxNames: 4);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              
              // Animated Success Checkmark
              Center(
                child: _ParlaAnimatedBuilder(
                  animation: _ctrl,
                  builder: (_, __) => Opacity(
                    opacity: _fade.value,
                    child: Transform.scale(
                      scale: _scale.value,
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              kSuccess.withValues(alpha: 0.15),
                              kSuccess.withValues(alpha: 0.05),
                            ],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: kSuccess.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(Icons.check_rounded, size: 48, color: kSuccess),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Status text
              Text(
                'Bronyňyz kabul edildi!',
                style: tt.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: kTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Wagtyňyz we ýeriňiz tassyklanyldy.',
                style: tt.bodyMedium?.copyWith(color: kTextSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Sticker Booking Details Card
              Container(
                decoration: kStickerCardDecoration(),
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.receipt_long_rounded, color: kPrimary, size: 20),
                        const SizedBox(width: AppSpacing.s),
                        Text(
                          'Bron maglumatlary',
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: kTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.m),
                    const Divider(),
                    const SizedBox(height: AppSpacing.m),
                    _InfoRow(
                      icon: Icons.storefront_rounded,
                      label: 'Salon',
                      value: widget.salonName,
                    ),
                    _InfoRow(
                      icon: Icons.spa_rounded,
                      label: 'Hyzmat',
                      value: serviceLabel,
                    ),
                    _InfoRow(
                      icon: Icons.access_time_rounded,
                      label: 'Wagt',
                      value: dateStr,
                    ),
                    _InfoRow(
                      icon: Icons.person_rounded,
                      label: 'Müşderi',
                      value: widget.booking.guestName,
                    ),
                    _InfoRow(
                      icon: Icons.phone_iphone_rounded,
                      label: 'Telefon',
                      value: widget.booking.guestPhone,
                    ),
                    _InfoRow(
                      icon: Icons.tag_rounded,
                      label: 'Bron #',
                      value: widget.booking.id.toString(),
                      isId: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl * 1.5),

              // Actions
              Consumer(
                builder: (context, ref, _) {
                  return ElevatedButton(
                    onPressed: () {
                      ref.read(selectedTabIndexProvider.notifier).state = 0;
                      _resetToHome(context);
                    },
                    child: const Text('Baş sahypa'),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.m),
              Consumer(
                builder: (context, ref, _) {
                  return OutlinedButton(
                    onPressed: () {
                      ref.read(selectedTabIndexProvider.notifier).state = 1;
                      _resetToHome(context);
                    },
                    child: const Text('Meniň bronlarym'),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  void _resetToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const BottomNavShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
      (route) => false,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isId;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isId = false,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: kTextTertiary),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: tt.bodyMedium?.copyWith(color: kTextSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: tt.bodyLarge?.copyWith(
                fontWeight: isId ? FontWeight.w700 : FontWeight.w500,
                color: isId ? kPrimary : kTextPrimary,
              ),
            ),
          ),
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
