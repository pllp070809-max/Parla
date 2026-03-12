import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme.dart';

final selectedLocationProvider = StateProvider<String>((ref) => 'Aşgabat');

class LocationPickerScreen extends ConsumerWidget {
  const LocationPickerScreen({super.key});

  static const _locations = [
    'Aşgabat',
    'Türkmenabat',
    'Mary',
    'Balkanabat',
    'Daşoguz',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final current = ref.watch(selectedLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ýerleşiş saýla'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _locations.length,
        itemBuilder: (_, i) {
          final loc = _locations[i];
          final isSelected = loc == current;
          return ListTile(
            leading: Icon(
              Icons.location_on_outlined,
              color: isSelected ? kPrimary : kTextSecondary,
            ),
            title: Text(
              loc,
              style: tt.titleMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? kPrimary : kTextPrimary,
              ),
            ),
            trailing: isSelected ? const Icon(Icons.check_rounded, color: kPrimary) : null,
            onTap: () {
              ref.read(selectedLocationProvider.notifier).state = loc;
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
