import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/salon.dart';
import '../theme.dart';
import 'booking_screen.dart';

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
    _future = ref.read(apiServiceProvider).getSalonDetail(widget.salonId);
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: FutureBuilder<Salon>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Ýalňyşlyk: ${snap.error}'));
          }
          final salon = snap.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(salon.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  background: Container(
                    color: kPrimary.withValues(alpha: 0.12),
                    child: const Center(child: Icon(Icons.storefront, size: 72, color: kPrimary)),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (salon.address != null) ...[
                        Row(children: [
                          const Icon(Icons.location_on_outlined, size: 20, color: kPrimary),
                          const SizedBox(width: 8),
                          Expanded(child: Text(salon.address!, style: tt.bodyLarge)),
                        ]),
                        const SizedBox(height: 20),
                      ],
                      Text('Hyzmatlar', style: tt.titleLarge),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList.separated(
                  itemCount: salon.services.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final svc = salon.services[i];
                    return _ServiceTile(
                      service: svc,
                      onBook: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingScreen(
                            salonId: salon.id,
                            salonName: salon.name,
                            services: salon.services,
                            preselectedServiceId: svc.id,
                          ),
                        ),
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
}

class _ServiceTile extends StatelessWidget {
  final Service service;
  final VoidCallback onBook;
  const _ServiceTile({required this.service, required this.onBook});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: tt.titleMedium),
                const SizedBox(height: 4),
                Text(
                  '${service.durationMinutes} min'
                  '${service.price != null ? '  •  ${service.price!.toStringAsFixed(0)} TMT' : ''}',
                  style: tt.bodyMedium,
                ),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: onBook,
            child: const Text('Bron et'),
          ),
        ],
      ),
    );
  }
}
