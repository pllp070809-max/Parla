import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/salon.dart';
import '../providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'salon_detail_screen.dart';
import '../widgets/shared_widgets.dart';

final _dealsSalonsProvider = FutureProvider<List<Salon>>((ref) {
  return ref.read(apiServiceProvider).getSalons();
});

class DealsScreen extends ConsumerWidget {
  const DealsScreen({super.key});

  static const _mockDeals = [
    _DealInfo(title: 'Ilkinji zyýaretde 20% arzanladyş', subtitle: 'Saç kesmek we stil', discount: '20%'),
    _DealInfo(title: 'Massage paketi', subtitle: '3 gezek – 15% arzan', discount: '15%'),
    _DealInfo(title: 'Dyrnak + kirpik', subtitle: 'Birlikde 10% arzan', discount: '10%'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final salonsAsync = ref.watch(_dealsSalonsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arzanladyşlar'),
        centerTitle: true,
      ),
      body: salonsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: kPrimary)),
        error: (e, _) => ErrorRetryWidget(
          message: 'Arzanladyşlar ýüklenmedi',
          onRetry: () => ref.invalidate(_dealsSalonsProvider),
        ),
        data: (salons) {
          if (salons.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_offer_outlined, size: 72, color: kTextTertiary),
                  const SizedBox(height: 16),
                  Text('Häzir arzanladyş ýok', style: tt.titleMedium),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _mockDeals.length > salons.length ? salons.length : _mockDeals.length,
            itemBuilder: (_, i) {
              final deal = _mockDeals[i];
              final salon = salons[i % salons.length];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _DealCard(
                  deal: deal,
                  salonName: salon.name,
                  onTap: () => Navigator.push(
                    context,
                    fadeSlideRoute(SalonDetailScreen(salonId: salon.id)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _DealInfo {
  final String title;
  final String subtitle;
  final String discount;
  const _DealInfo({required this.title, required this.subtitle, required this.discount});
}

class _DealCard extends StatelessWidget {
  final _DealInfo deal;
  final String salonName;
  final VoidCallback onTap;

  const _DealCard({required this.deal, required this.salonName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kPrimary.withValues(alpha: 0.15),
                kPrimary.withValues(alpha: 0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kPrimary.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: kPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    deal.discount,
                    style: tt.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: kPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(deal.title, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(deal.subtitle, style: tt.bodySmall?.copyWith(color: kTextSecondary)),
                    const SizedBox(height: 4),
                    Text(salonName, style: tt.bodySmall?.copyWith(color: kPrimary, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: kPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
