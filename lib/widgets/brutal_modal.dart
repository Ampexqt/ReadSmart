import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/design_system.dart';
import '../providers/theme_provider.dart';

class BrutalModal extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final VoidCallback? onClose;

  const BrutalModal({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(0.6),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: DesignSystem.maxWidth,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            margin: const EdgeInsets.all(DesignSystem.spacingMD),
            decoration: BoxDecoration(
              color: DesignSystem.cardColor(isDark),
              border: DesignSystem.themeBorder(isDark),
              boxShadow: DesignSystem.themeShadowSmall(isDark),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(DesignSystem.spacingLG),
                  decoration: BoxDecoration(
                    color: DesignSystem.backgroundColor(isDark),
                    border: Border(
                      bottom: DesignSystem.themeBorderSide(isDark),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title.toUpperCase(),
                          style: DesignSystem.text2XL.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.02,
                            color: DesignSystem.textColor(isDark),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onClose ?? () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: DesignSystem.cardColor(isDark),
                            border: DesignSystem.themeBorder(isDark),
                          ),
                          child: Icon(
                            Icons.close,
                            size: DesignSystem.iconSizeMD,
                            color: DesignSystem.textColor(isDark),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(DesignSystem.spacingLG),
                    child: child,
                  ),
                ),
                // Actions
                if (actions != null && actions!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(DesignSystem.spacingLG),
                    decoration: BoxDecoration(
                      border: Border(top: DesignSystem.themeBorderSide(isDark)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions!,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
