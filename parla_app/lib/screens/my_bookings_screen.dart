import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/providers.dart';
import '../models/booking.dart';
import '../theme.dart';
import '../widgets/shared_widgets.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phone = ref.watch(userPhoneProvider);
    final hasPhone = phone != null && phone.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meniň bronlarym'),
        actions: [
          if (hasPhone)
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Täzelemek',
              onPressed: () => ref.invalidate(myBookingsProvider),
            ),
        ],
      ),
      body: !hasPhone
          ? _NoPhoneView(ref: ref)
          : _BookingsBody(ref: ref),
    );
  }
}

class _NoPhoneView extends StatelessWidget {
  final WidgetRef ref;
  const _NoPhoneView({required this.ref});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpace3xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96, height: 96,
              decoration: BoxDecoration(
                color: kPrimary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_outline_rounded, size: 48, color: kPrimary.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: kSpace2xl),
            Text('Profiliňizi dolduryň', style: tt.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: kSpaceSm),
            Text(
              'Bronlaryňyzy görmek üçin ilki Profil sahypasynda telefon nomeriňizi ýazyň.',
              style: tt.bodyMedium, textAlign: TextAlign.center,
            ),
            const SizedBox(height: kSpace2xl),
            FilledButton.icon(
              onPressed: () => ref.read(selectedTabIndexProvider.notifier).state = 2,
              icon: const Icon(Icons.person_rounded, size: 20),
              label: const Text('Profile geçmek'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingsBody extends StatelessWidget {
  final WidgetRef ref;
  const _BookingsBody({required this.ref});

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(myBookingsProvider);
    final now = DateTime.now();

    return bookingsAsync.when(
      loading: () => ListView.separated(
        padding: const EdgeInsets.all(kSpaceXl),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: kSpaceSm + 2),
        itemBuilder: (_, __) => const _BookingTileSkeleton(),
      ),
      error: (e, _) => ErrorRetryWidget(
        message: 'Bronlary ýükläp bolmady',
        onRetry: () => ref.invalidate(myBookingsProvider),
      ),
      data: (bookings) {
        if (bookings.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.calendar_today_outlined,
            title: 'Siziň entäk bronyňyz ýok',
            subtitle: 'Salon tapyp bron ediň – bronlaryňyz bu ýerde awtomatiki görüner',
            actionLabel: 'Salonlara geçmek',
            onAction: () => ref.read(selectedTabIndexProvider.notifier).state = 0,
          );
        }

        final upcoming = <Booking>[];
        final past = <Booking>[];
        for (final b in bookings) {
          (b.slotAt.isAfter(now) ? upcoming : past).add(b);
        }

        return RefreshIndicator(
          color: kPrimary,
          onRefresh: () async => ref.invalidate(myBookingsProvider),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: kSpaceXl, vertical: kSpaceSm),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (upcoming.isNotEmpty) ...[
                _SectionHeader(title: 'Geljekki', count: upcoming.length),
                const SizedBox(height: kSpaceSm),
                ...upcoming.map((b) => _BookingTile(
                      booking: b,
                      isPast: false,
                      onCancel: b.status == 'confirmed'
                          ? () async {
                              final phone = ref.read(userPhoneProvider);
                              if (phone == null) return;
                              await ref.read(apiServiceProvider).cancelBooking(b.id, phone);
                              ref.invalidate(myBookingsProvider);
                            }
                          : null,
                    )),
              ],
              if (past.isNotEmpty) ...[
                SizedBox(height: upcoming.isNotEmpty ? kSpaceXl : 0),
                _SectionHeader(title: 'Tamamlandy', count: past.length, muted: true),
                const SizedBox(height: kSpaceSm),
                ...past.map((b) => _BookingTile(booking: b, isPast: true, onCancel: null)),
              ],
              const SizedBox(height: kSpaceXl),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final bool muted;
  const _SectionHeader({required this.title, required this.count, this.muted = false});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(title, style: tt.titleMedium?.copyWith(color: muted ? kTextSecondary : null)),
        const SizedBox(width: kSpaceSm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: kSpaceSm, vertical: 2),
          decoration: BoxDecoration(
            color: (muted ? kTextSecondary : kPrimary).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(kRadiusSm),
          ),
          child: Text(
            '$count',
            style: tt.labelLarge?.copyWith(fontSize: 12, color: muted ? kTextSecondary : kPrimary),
          ),
        ),
      ],
    );
  }
}

class _BookingTile extends StatelessWidget {
  final Booking booking;
  final bool isPast;
  final Future<void> Function()? onCancel;
  const _BookingTile({required this.booking, required this.isPast, this.onCancel});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final dateStr = DateFormat('dd MMM yyyy, HH:mm').format(booking.slotAt);
    final salonLabel = booking.salonName ?? 'Salon #${booking.salonId}';
    final serviceLabel = booking.serviceName ?? 'Hyzmat #${booking.serviceId}';
    final canCancel = !isPast && booking.status == 'confirmed' && onCancel != null;

    return Opacity(
      opacity: isPast ? 0.55 : 1.0,
      child: Card(
        margin: const EdgeInsets.only(bottom: kSpaceSm + 2),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: (isPast ? Colors.grey : kPrimary).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(kRadiusMd),
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
                        const SizedBox(height: kSpaceXs),
                        Text(salonLabel, style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                        if (serviceLabel.isNotEmpty)
                          Text(serviceLabel, style: tt.bodySmall?.copyWith(color: kTextSecondary)),
                        const SizedBox(height: kSpaceXs),
                        Text(dateStr, style: tt.bodyMedium),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: kSpaceXs),
                    decoration: BoxDecoration(
                      color: isPast ? Colors.grey.withValues(alpha: 0.15) : kPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(kRadiusSm),
                    ),
                    child: Text(
                      isPast ? 'Tamamlandy' : (booking.status == 'cancelled' ? 'Ýatyryldy' : booking.status),
                      style: tt.labelLarge?.copyWith(color: isPast ? Colors.grey : kPrimary, fontSize: 12),
                    ),
                  ),
                ],
              ),
              if (canCancel) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () async {
                      await onCancel?.call();
                    },
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: const Text('Ýatyrmak'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingTileSkeleton extends StatelessWidget {
  const _BookingTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: const [
            SkeletonBox(width: 48, height: 48, radius: kRadiusMd),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: 100, height: 16),
                  SizedBox(height: kSpaceSm),
                  SkeletonBox(width: 160, height: 14),
                ],
              ),
            ),
            SkeletonBox(width: 72, height: 24, radius: kRadiusSm),
          ],
        ),
      ),
    );
  }
}
