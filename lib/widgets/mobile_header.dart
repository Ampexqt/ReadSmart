import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/design_system.dart';
import '../providers/theme_provider.dart';

class MobileHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? rightAction;

  const MobileHeader({
    super.key,
    required this.title,
    this.onBack,
    this.rightAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: DesignSystem.cardColor(isDark),
        border: Border(bottom: DesignSystem.themeBorderSide(isDark)),
      ),
      padding: const EdgeInsets.all(DesignSystem.spacingMD),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (onBack != null)
              GestureDetector(
                onTap: onBack,
                child: Icon(
                  Icons.arrow_back,
                  size: DesignSystem.iconSizeLG,
                  color: DesignSystem.textColor(isDark),
                ),
              ),
            if (onBack != null) const SizedBox(width: DesignSystem.spacingMD),
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: DesignSystem.textXL.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.02,
                  color: DesignSystem.textColor(isDark),
                ),
              ),
            ),
            if (rightAction != null) rightAction!,
          ],
        ),
      ),
    );
  }
}
