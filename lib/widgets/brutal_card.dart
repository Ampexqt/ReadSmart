import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class BrutalCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadow;

  const BrutalCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.shadow,
  });

  @override
  State<BrutalCard> createState() => _BrutalCardState();
}

class _BrutalCardState extends State<BrutalCard> {
  bool _isHovered = false;

  List<BoxShadow> get _shadow {
    if (widget.shadow != null) return widget.shadow!;
    if (_isHovered && widget.onTap != null) {
      return DesignSystem.shadowLarge;
    }
    return DesignSystem.shadowSmall;
  }

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      padding: widget.padding ?? const EdgeInsets.all(DesignSystem.spacingMD),
      decoration: BoxDecoration(
        color: DesignSystem.primaryWhite,
        border: DesignSystem.border,
        boxShadow: _shadow,
      ),
      child: widget.child,
    );

    if (widget.onTap != null) {
      return GestureDetector(
        onTap: widget.onTap,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: card,
        ),
      );
    }

    return card;
  }
}
