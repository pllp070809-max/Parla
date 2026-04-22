import 'package:flutter/material.dart';

import '../app_text_styles.dart';
import '../app_spacing.dart';
import '../theme.dart';

const Color _kBottomActionDivider = Color(0xFFF0F1F5);
const Color _kBottomActionButtonBg = Color(0xFF151517);
const Color _kBottomActionMeta = Color(0xFF8D8D98);

class BottomActionBar extends StatelessWidget {
  final String? topInfoLabel;
  final String infoLabel;
  final String buttonLabel;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData icon;
  final Key? infoKey;
  final bool showIcon;

  const BottomActionBar({
    super.key,
    this.topInfoLabel,
    required this.infoLabel,
    required this.buttonLabel,
    required this.onPressed,
    this.loading = false,
    this.icon = Icons.calendar_month_rounded,
    this.infoKey,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final compactTitleStyle = tt.bodySmall?.copyWith(
      color: _kBottomActionMeta,
      letterSpacing: -0.2,
      height: tt.bodySmall?.height,
    );
    final premiumPriceStyle = AppTextStyles.sectionTitle.copyWith(
      fontSize: tt.titleLarge?.fontSize,
      fontWeight: FontWeight.w700,
      color: kTextPrimary,
      letterSpacing: -0.1,
      height: 1.2,
    );

    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        border: const Border(top: BorderSide(color: _kBottomActionDivider)),
        boxShadow: kShadowUpMd,
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.m,
        AppSpacing.xl,
        MediaQuery.of(context).padding.bottom + AppSpacing.m,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (topInfoLabel != null) ...[
                  Text(
                    topInfoLabel!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: premiumPriceStyle,
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  infoLabel,
                  key: infoKey,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: compactTitleStyle,
                ),
              ],
            ),
          ),
          showIcon
              ? FilledButton.icon(
                  onPressed: loading ? null : onPressed,
                  icon: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.2,
                          ),
                        )
                      : Icon(icon, size: 20),
                  label: Text(buttonLabel),
                  style: _buttonStyle(),
                )
              : FilledButton(
                  onPressed: loading ? null : onPressed,
                  style: _buttonStyle(),
                  child: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.2,
                          ),
                        )
                      : Text(buttonLabel),
                ),
        ],
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return FilledButton.styleFrom(
      backgroundColor: _kBottomActionButtonBg,
      disabledBackgroundColor: _kBottomActionButtonBg,
      disabledForegroundColor: Colors.white,
      foregroundColor: Colors.white,
      shape: const StadiumBorder(),
      minimumSize: const Size(45, 52),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: AppSpacing.xl,
      ),
    );
  }
}
