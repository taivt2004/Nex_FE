import 'package:flutter/material.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/ui/widget/custom_textfield.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    required this.controller,
    super.key,
    this.hintText,
    this.labelText,
    this.errorText,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final TextInputAction textInputAction;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CustomTextField(
      controller: widget.controller,
      hintText: widget.hintText ?? l10n.passwordLabel,
      labelText: widget.labelText ?? l10n.passwordLabel,
      errorText: widget.errorText,
      textInputAction: widget.textInputAction,
      obscureText: _isObscure,
      suffixIcon: IconButton(
        icon: Icon(
          _isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
        onPressed: () {
          setState(() {
            _isObscure = !_isObscure;
          });
        },
      ),
    );
  }
}
