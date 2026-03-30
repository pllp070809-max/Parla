import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../screens/home_screen.dart';
import '../screens/my_bookings_screen.dart';
import '../screens/profile_screen.dart';
import '../app_radius.dart';
import '../app_sizes.dart';
import '../app_spacing.dart';
import '../theme.dart';

/// Icon-only bottom bar; saýlananda M3 ýaly pill indikator we primary reňk.
class BottomNavShell extends ConsumerWidget {
  const BottomNavShell({super.key});

  static const _screens = <Widget>[
    HomeScreen(),
    MyBookingsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(selectedTabIndexProvider);

    return Scaffold(
      body: IndexedStack(index: index, children: _screens),
      bottomNavigationBar: Container(
        color: kScaffoldBg,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.s, AppSpacing.l, AppSpacing.s),
            child: Container(
              decoration: BoxDecoration(
                color: kCardBg,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: kStickerOutline),
                boxShadow: kStickerShadow,
              ),
              child: SizedBox(
                height: AppSizes.bottomNavHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                      label: 'Baş sahypa',
                      isSelected: index == 0,
                      onTap: () => ref.read(selectedTabIndexProvider.notifier).state = 0,
                    ),
                    _NavItem(
                      icon: Icons.calendar_today_outlined,
                      activeIcon: Icons.calendar_today_rounded,
                      label: 'Bronlarym',
                      isSelected: index == 1,
                      onTap: () => ref.read(selectedTabIndexProvider.notifier).state = 1,
                    ),
                    _NavItem(
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                      label: 'Profil',
                      isSelected: index == 2,
                      onTap: () => ref.read(selectedTabIndexProvider.notifier).state = 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  static const _indicatorAlpha = 0.12;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? kPrimary : kTextTertiary;
    final iconSize = isSelected ? 26.0 : 24.0;

    return Semantics(
      label: label,
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                if (isSelected)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    width: 52,
                    height: 32,
                    decoration: BoxDecoration(
                      color: kPrimary.withValues(alpha: _indicatorAlpha),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                Icon(isSelected ? activeIcon : icon, size: iconSize, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
