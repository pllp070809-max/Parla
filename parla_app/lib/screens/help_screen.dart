import 'package:flutter/material.dart';
import '../theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Kömek / Habarlaşmak')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(kSpaceXl, kSpaceMd, kSpaceXl, kSpace3xl),
        children: [
          Text(
            'Kömek gerekmi? Bize ýazyň – size çalt kömek ederis.',
            style: tt.bodyLarge,
          ),
          const SizedBox(height: kSpace2xl),
          _ContactCard(
            tt: tt,
            icon: Icons.email_rounded,
            label: 'E-poçta',
            value: 'support@parla.tm',
          ),
          const SizedBox(height: kSpaceMd),
          _ContactCard(
            tt: tt,
            icon: Icons.phone_rounded,
            label: 'Telefon',
            value: '+993 12 34 56 78',
          ),
          const SizedBox(height: kSpace2xl),
          Text('Köp berilýän soraglar', style: tt.titleSmall?.copyWith(color: kPrimary)),
          const SizedBox(height: kSpaceSm),
          _FaqItem(tt: tt, q: 'Brony nädip edip bilerin?', a: 'Salon saýlaň, hyzmat we wagt saýlaň, atyňyzy we telefonuňyzy ýazyň we "Bron et" basyň.'),
          _FaqItem(tt: tt, q: 'Brony nädip ýatyryp bilerin?', a: 'Meniň bronlarym sahypasynda geljekki bronyňyzyň aşagyndaky "Ýatyrmak" düwmäsine basyň.'),
          _FaqItem(tt: tt, q: 'Salon tapylmady – näme etmeli?', a: 'Gözleg sahypasyndan at boýunça gözläň ýa-da karta bölüminden ýerleşişe serediň. Sorag bar bolsa bize ýazyň.'),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final TextTheme tt;
  final IconData icon;
  final String label;
  final String value;

  const _ContactCard({required this.tt, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kSpaceLg),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(kRadiusLg),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: kPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(kRadiusMd),
            ),
            child: Icon(icon, color: kPrimary),
          ),
          const SizedBox(width: kSpaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: tt.labelMedium?.copyWith(color: kTextSecondary)),
                const SizedBox(height: 2),
                Text(value, style: tt.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final TextTheme tt;
  final String q;
  final String a;

  const _FaqItem({required this.tt, required this.q, required this.a});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kSpaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(q, style: tt.titleSmall),
          const SizedBox(height: kSpaceXs),
          Text(a, style: tt.bodyMedium?.copyWith(color: kTextSecondary)),
        ],
      ),
    );
  }
}
