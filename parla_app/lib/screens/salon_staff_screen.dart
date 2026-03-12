import 'package:flutter/material.dart';
import '../theme.dart';

class SalonStaffScreen extends StatelessWidget {
  final String salonName;
  const SalonStaffScreen({super.key, required this.salonName});

  static final _mockStaff = [
    _StaffItem('Aýgözel', 'Saç ussasy', Icons.person_rounded),
    _StaffItem('Mähri', 'Dyrnak ussasy', Icons.person_rounded),
    _StaffItem('Gulya', 'Gözellik ussasy', Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topar'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _mockStaff.length,
        itemBuilder: (_, i) {
          final s = _mockStaff[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: kSurfaceBg,
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: kPrimary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(s.icon, color: kPrimary, size: 26),
              ),
              title: Text(s.name, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              subtitle: Text(s.role, style: tt.bodySmall?.copyWith(color: kTextSecondary)),
              trailing: const Icon(Icons.chevron_right_rounded, color: kTextTertiary),
            ),
          );
        },
      ),
    );
  }
}

class _StaffItem {
  final String name;
  final String role;
  final IconData icon;
  _StaffItem(this.name, this.role, this.icon);
}
