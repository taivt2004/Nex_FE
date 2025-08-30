import 'package:flutter/material.dart';

class RoundedArrowButton extends StatelessWidget {
  const RoundedArrowButton({this.onPressed, super.key});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.only(
            left: 12,
            top: 12,
            right: 6,
            bottom: 12,
          ),
          child: const Center(
            child: Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
