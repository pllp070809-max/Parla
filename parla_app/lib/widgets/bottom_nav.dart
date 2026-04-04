import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../screens/home_screen.dart';
import '../screens/my_bookings_screen.dart';
import '../screens/profile_screen.dart';
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
  static const _navHeight = 56.0;
  static const _indicatorWidth = 52.0;
  static const _indicatorHeight = 36.0;
  static const _animDuration = Duration(milliseconds: 260);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(selectedTabIndexProvider);
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    final featherHeight = _navHeight + bottomInset + 50;

    return Scaffold(
      body: Stack(
        children: [
          // 1-nji gatlak: sahypalar (doly ekran)
          IndexedStack(index: index, children: _screens),
          // 2-nji gatlak: sistem nav area üçin statik feather.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                height: featherHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.42),
                      Colors.black.withValues(alpha: 0.18),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),
          // 2-nji gatlak: frosted glass bottom nav (üstünde ýüzýär)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, AppSpacing.s, 32, 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: kStickerOutline),
                        boxShadow: kStickerShadow,
                      ),
                      child: SizedBox(
                        height: _navHeight,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final slotWidth = constraints.maxWidth / _screens.length;
                            final indicatorLeft =
                                (slotWidth * index) + ((slotWidth - _indicatorWidth) / 2);
                            return Stack(
                              children: [
                                AnimatedPositioned(
                                  duration: _animDuration,
                                  curve: Curves.easeOutCubic,
                                  left: indicatorLeft,
                                  top: (_navHeight - _indicatorHeight) / 2,
                                  child: IgnorePointer(
                                    child: Container(
                                      width: _indicatorWidth,
                                      height: _indicatorHeight,
                                      decoration: BoxDecoration(
                                        color: kPrimary.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _NavItem(
                                        icon: Icons.home_rounded,
                                        label: 'Baş sahypa',
                                        isSelected: index == 0,
                                        onTap: () => ref.read(selectedTabIndexProvider.notifier).state = 0,
                                      ),
                                    ),
                                    Expanded(
                                      child: _NavItem(
                                        icon: Icons.calendar_today_rounded,
                                        label: 'Bronlarym',
                                        isSelected: index == 1,
                                        onTap: () => ref.read(selectedTabIndexProvider.notifier).state = 1,
                                      ),
                                    ),
                                    Expanded(
                                      child: _NavItem(
                                        icon: Icons.person_rounded,
                                        label: 'Profil',
                                        isSelected: index == 2,
                                        onTap: () => ref.read(selectedTabIndexProvider.notifier).state = 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  static const _animDuration = Duration(milliseconds: 260);

  @override
  Widget build(BuildContext context) {
    final iconSize = isSelected ? 28.0 : 24.0;
    final color = isSelected ? kPrimary : kTextTertiary;

    final iconWidget = Icon(icon, size: iconSize, color: color);

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
            child: TweenAnimationBuilder<double>(
              duration: _animDuration,
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: isSelected ? 0.94 : 1.0, end: isSelected ? 1.0 : 0.92),
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: AnimatedOpacity(
                duration: _animDuration,
                curve: Curves.easeOutCubic,
                opacity: isSelected ? 1.0 : 0.88,
                child: iconWidget,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
