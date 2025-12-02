import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class BrutalInput extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;

  const BrutalInput({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.onChanged,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  State<BrutalInput> createState() => _BrutalInputState();
}

class _BrutalInputState extends State<BrutalInput> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!.toUpperCase(), style: DesignSystem.labelStyle),
          const SizedBox(height: DesignSystem.spacingSM),
        ],
        Focus(
          onFocusChange: (hasFocus) {
            setState(() => _isFocused = hasFocus);
          },
          child: Container(
            decoration: BoxDecoration(
              color: DesignSystem.primaryWhite,
              border: DesignSystem.border,
              boxShadow: _isFocused
                  ? DesignSystem.shadowMedium
                  : DesignSystem.shadowSmall,
            ),
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              style: DesignSystem.textBase.copyWith(
                fontWeight: FontWeight.w500,
                color: DesignSystem.primaryBlack,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: DesignSystem.textBase.copyWith(
                  color: DesignSystem.grey400,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: const EdgeInsets.all(DesignSystem.spacingMD),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                suffixIcon: widget.suffixIcon != null
                    ? Padding(
                        padding: const EdgeInsets.all(DesignSystem.spacingMD),
                        child: widget.suffixIcon,
                      )
                    : null,
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
