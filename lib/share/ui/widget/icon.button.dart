import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.icon,
    required this.onTap,
    this.activeColor,
    super.key,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius,
  });

  final Widget icon;
  final VoidCallback onTap;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final Color? activeColor; // Optional active color

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        padding: padding,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: IconTheme(
            data: IconThemeData(
              color: activeColor ?? Colors.black, // Default color if activeColor is not provided
            ),
            child: icon,
          ),
        ),
      ),
    );
  }
}
