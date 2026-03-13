import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/providers.dart';
import '../theme.dart';
import 'privacy_policy_screen.dart';
import 'help_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Sazlamalar')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(kSpaceXl, kSpaceLg, kSpaceXl, kSpace3xl),
        children: [
          _SectionLabel('Esasy', tt),
          const SizedBox(height: kSpaceSm),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.language_rounded,
                label: 'Dil',
                trailing: Text('Türkmençe', style: tt.bodyMedium),
                onTap: () => _showComingSoon(context),
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.dark_mode_rounded,
                label: 'Garaňky rejim',
                trailing: Text('Ýakynda', style: tt.bodyMedium),
                onTap: () => _showComingSoon(context),
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.notifications_rounded,
                label: 'Bildirişler',
                trailing: Text('Ýakynda', style: tt.bodyMedium),
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),

          const SizedBox(height: kSpace2xl),
          _SectionLabel('Maglumat', tt),
          const SizedBox(height: kSpaceSm),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.info_rounded,
                label: 'Wersiýa',
                trailing: Text('1.0.0', style: tt.bodyMedium),
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.shield_rounded,
                label: 'Gizlinlik syýasaty',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.help_rounded,
                label: 'Kömek / Habarlaşmak',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen())),
              ),
            ],
          ),

          const SizedBox(height: kSpace2xl),
          _SectionLabel('Howply zona', tt, isDestructive: true),
          const SizedBox(height: kSpaceSm),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.delete_rounded,
                label: 'Maglumatlary pozmak',
                isDestructive: true,
                onTap: () => _clearData(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.schedule_rounded, color: Colors.white, size: 20),
          SizedBox(width: kSpaceSm),
          Text('Ýakyn wagtda goşular!'),
        ]),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusMd)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _clearData(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusLg)),
        icon: Container(
          width: 56, height: 56,
          decoration: BoxDecoration(color: kError.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: const Icon(Icons.delete_forever_rounded, color: kError, size: 28),
        ),
        title: const Text('Maglumatlary pozmak'),
        content: const Text('Ähli profil maglumatlaryňyz pozular. Dowam etmek isleýärsiňizmi?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Ýok')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: kError),
            child: const Text('Pozmak'),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_name');
    await prefs.remove('profile_phone');
    await prefs.remove('profile_gender');
    if (!context.mounted) return;
    ref.read(userPhoneProvider.notifier).setPhone(null);
    ref.invalidate(myBookingsProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Maglumatlar pozuldy. Profili täzeden dolduryň.'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusMd)),
      ),
    );
    Navigator.pop(context, true);
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final TextTheme tt;
  final bool isDestructive;
  const _SectionLabel(this.text, this.tt, {this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: kSpaceXs),
      child: Text(
        text,
        style: tt.labelLarge?.copyWith(
          color: isDestructive ? kError.withValues(alpha: 0.8) : kTextSecondary,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(kRadiusLg),
        boxShadow: kShadowSm,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;
  const _SettingsTile({required this.icon, required this.label, this.trailing, this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final color = isDestructive ? kError : kTextPrimary;
    final iconColor = isDestructive ? kError : kPrimary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpaceLg, vertical: kSpaceMd + 4),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: (isDestructive ? kError : kPrimary).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(kRadiusSm),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: kSpaceMd),
            Expanded(child: Text(label, style: tt.bodyLarge?.copyWith(color: color))),
            if (trailing != null) trailing!
            else if (onTap != null) Icon(Icons.chevron_right_rounded, size: 18, color: kTextSecondary.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}
