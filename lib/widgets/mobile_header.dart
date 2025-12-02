import 'package:flutter/material.dart';
import '../theme/design_system.dart';

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
    return Container(
      decoration: const BoxDecoration(
        color: DesignSystem.primaryWhite,
        border: Border(bottom: DesignSystem.borderSide),
      ),
      padding: const EdgeInsets.all(DesignSystem.spacingMD),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (onBack != null)
              GestureDetector(
                onTap: onBack,
                child: const Icon(
                  Icons.arrow_back,
                  size: DesignSystem.iconSizeLG,
                  color: DesignSystem.primaryBlack,
                ),
              ),
            if (onBack != null) const SizedBox(width: DesignSystem.spacingMD),
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: DesignSystem.textXL.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.02,
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
