import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/design_system.dart';
import '../providers/theme_provider.dart';

enum BrutalButtonVariant { primary, secondary, outline }

enum BrutalButtonSize { sm, md, lg }

class BrutalButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final BrutalButtonVariant variant;
  final BrutalButtonSize size;
  final Widget? icon;
  final bool fullWidth;

  const BrutalButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = BrutalButtonVariant.primary,
    this.size = BrutalButtonSize.md,
    this.icon,
    this.fullWidth = false,
  });

  @override
  State<BrutalButton> createState() => _BrutalButtonState();
}

class _BrutalButtonState extends State<BrutalButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _backgroundColor(bool isDark) {
    if (widget.variant == BrutalButtonVariant.primary) {
      return DesignSystem.textColor(isDark);
    } else if (widget.variant == BrutalButtonVariant.secondary) {
      return DesignSystem.cardColor(isDark);
    } else {
      return Colors.transparent;
    }
  }

  Color _textColor(bool isDark) {
    if (widget.variant == BrutalButtonVariant.primary) {
      return DesignSystem.backgroundColor(isDark);
    } else {
      return DesignSystem.textColor(isDark);
    }
  }

  EdgeInsets get _padding {
    switch (widget.size) {
      case BrutalButtonSize.sm:
        return const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingMD,
          vertical: DesignSystem.spacingSM,
        );
      case BrutalButtonSize.md:
        return const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingLG,
          vertical: 12.0,
        );
      case BrutalButtonSize.lg:
        return const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingXL,
          vertical: DesignSystem.spacingMD,
        );
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case BrutalButtonSize.sm:
        return 14;
      case BrutalButtonSize.md:
        return 16;
      case BrutalButtonSize.lg:
        return 18;
    }
  }

  List<BoxShadow> _shadow(bool isDark) {
    if (_isPressed) {
      return [];
    }
    return DesignSystem.themeShadowSmall(isDark);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    final button = GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final offset = _isPressed ? const Offset(1, 1) : Offset.zero;
          return Transform.translate(
            offset: offset,
            child: Container(
              width: widget.fullWidth ? double.infinity : null,
              padding: _padding,
              decoration: BoxDecoration(
                color: _backgroundColor(isDark),
                border: DesignSystem.themeBorder(isDark),
                boxShadow: _shadow(isDark),
              ),
              child: Row(
                mainAxisSize: widget.fullWidth
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.text.toUpperCase(),
                    style: DesignSystem.buttonStyle.copyWith(
                      fontSize: _fontSize,
                      color: _textColor(isDark),
                    ),
                  ),
                  if (widget.icon != null) ...[
                    const SizedBox(width: DesignSystem.spacingSM),
                    widget.icon!,
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );

    return button;
  }
}
