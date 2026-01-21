import 'package:flutter/material.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

typedef Validator = String? Function(String?);

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    required this.controller,
    required this.hintText,
    required this.labelText,
    super.key,
    this.errorText,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.maxLength,
    this.maxLines,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final String? errorText;
  final bool obscureText;
  final int? maxLength;
  final int? maxLines;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final IconButton? suffixIcon;
  final Validator? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        fillColor: OlaColors.background,
        hintText: hintText,
        hintStyle: OlaTextStyles.primarytext14regular
            .copyWith(color: OlaColors.gray400),
        labelText: labelText,
        labelStyle: OlaTextStyles.primarytext14regular
            .copyWith(color: OlaColors.gray400),
        errorText: errorText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          height: 0,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }
}
