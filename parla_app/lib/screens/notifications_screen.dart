import 'package:flutter/material.dart';
import '../theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static final _mockNotifications = [
    _NotifItem('Täze arzanladyş', 'Siziň sewenen salonlaryňyzdan biri täze çekiliş çykardy.', 'Bugün, 10:30', Icons.local_offer_rounded, false),
    _NotifItem('Bron tassyklandy', 'Bronlaryňyz tassyklandy. 15 Mart, 14:00.', 'Düýn', Icons.check_circle_rounded, true),
    _NotifItem('Salon täzelikleri', 'Siziň saýlanan salonlaryňyza täze hyzmatlar goşuldy.', '2 gün öň', Icons.storefront_rounded, true),
  ];

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirişler'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Hemmesini okalan et', style: TextStyle(fontSize: 13, color: kPrimary)),
          ),
        ],
      ),
      body: _mockNotifications.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_none_rounded, size: 72, color: kTextTertiary),
                  const SizedBox(height: 16),
                  Text('Bildiriş ýok', style: tt.titleMedium),
                  Text('Täze bildirişler bu ýerde görkeziler', style: tt.bodyMedium?.copyWith(color: kTextSecondary)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _mockNotifications.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final n = _mockNotifications[i];
                return ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: (n.read ? kTextTertiary : kPrimary).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(n.icon, color: n.read ? kTextSecondary : kPrimary, size: 22),
                  ),
                  title: Text(n.title, style: tt.titleSmall?.copyWith(fontWeight: n.read ? FontWeight.w500 : FontWeight.w600)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(n.body, style: tt.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(n.time, style: tt.bodySmall?.copyWith(color: kTextTertiary, fontSize: 12)),
                    ],
                  ),
                  isThreeLine: true,
                );
              },
            ),
    );
  }
}

class _NotifItem {
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final bool read;
  _NotifItem(this.title, this.body, this.time, this.icon, this.read);
}
