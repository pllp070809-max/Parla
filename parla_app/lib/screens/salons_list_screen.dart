import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../models/salon.dart';
import '../theme.dart';
import '../widgets/shared_widgets.dart';
import 'salon_detail_screen.dart';

class SalonsListScreen extends ConsumerStatefulWidget {
  final String? category;
  final String? searchQuery;
  const SalonsListScreen({super.key, this.category, this.searchQuery});

  @override
  ConsumerState<SalonsListScreen> createState() => _SalonsListScreenState();
}

class _SalonsListScreenState extends ConsumerState<SalonsListScreen> {
  late Future<List<Salon>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = ref.read(apiServiceProvider).getSalons(category: widget.category);
    setState(() {});
  }

  String get _title {
    if (widget.searchQuery != null) return '"${widget.searchQuery}"';
    if (widget.category != null) {
      return widget.category![0].toUpperCase() + widget.category!.substring(1);
    }
    return 'Salonlar';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: FutureBuilder<List<Salon>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return ListView.separated(
              padding: const EdgeInsets.all(kSpaceXl),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(height: kSpaceMd),
              itemBuilder: (_, __) => const SalonTileSkeleton(),
            );
          }
          if (snap.hasError) {
            return ErrorRetryWidget(message: 'Salonlary ýükläp bolmady', onRetry: _load);
          }
          var salons = snap.data ?? [];
          if (widget.searchQuery != null) {
            final q = widget.searchQuery!.toLowerCase();
            salons = salons.where((s) =>
              s.name.toLowerCase().contains(q) ||
              (s.address ?? '').toLowerCase().contains(q)
            ).toList();
          }
          if (salons.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.search_off_rounded,
              title: 'Salon tapylmady',
              subtitle: 'Axtarışyňyzy üýtgedip synap görüň',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(kSpaceXl),
            itemCount: salons.length,
            separatorBuilder: (_, __) => const SizedBox(height: kSpaceMd),
            itemBuilder: (_, i) {
              final s = salons[i];
              return _SalonTile(
                salon: s,
                onTap: () => Navigator.push(context, fadeSlideRoute(SalonDetailScreen(salonId: s.id))),
              );
            },
          );
        },
      ),
    );
  }
}

class _SalonTile extends StatelessWidget {
  final Salon salon;
  final VoidCallback onTap;
  const _SalonTile({required this.salon, required this.onTap});

  static const _imageMap = {
    'salon1': 'images/salon1.png',
    'salon2': 'images/salon2.png',
    'salon3': 'images/salon3.png',
  };

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: kPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(kRadiusMd),
                ),
                clipBehavior: Clip.antiAlias,
                child: _imageMap.containsKey(salon.imageKey)
                  ? Image.asset(_imageMap[salon.imageKey]!, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.storefront, color: kPrimary, size: 32))
                  : const Icon(Icons.storefront, color: kPrimary, size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(salon.name, style: tt.titleMedium),
                    if (salon.address != null) ...[
                      const SizedBox(height: kSpaceXs),
                      Text(salon.address!, style: tt.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: kTextSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
