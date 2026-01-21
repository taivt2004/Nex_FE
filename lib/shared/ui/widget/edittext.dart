import 'package:flutter/material.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

typedef OnEditComplete = void Function(String);
typedef OnValidator = String? Function(String?)?;

class EditText extends StatelessWidget {
  const EditText({
    super.key,
    this.autofocus = false,
    this.hideOnTouchOutside = false,
    this.onEditComplete,
    this.validator,
    this.textEditingController,
    this.textInputAction = TextInputAction.done,
    this.hintText = '',
    this.hintStyle,
    this.maxLines = 3,
    this.textInputType = TextInputType.text,
    this.icon,
    this.suffixIcon,
    this.showCursor = true,
    this.cursorColor,
    this.contentPadding = 4,
  });
  final TextEditingController? textEditingController;
  final bool autofocus;
  final bool hideOnTouchOutside;
  final OnEditComplete? onEditComplete;
  final TextInputAction textInputAction;
  final OnValidator validator;
  final String hintText;
  final TextStyle? hintStyle;
  final int maxLines;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final Widget? icon;
  final bool showCursor;
  final Color? cursorColor;
  final double contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      showCursor: showCursor,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ??
            Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: OlaColors.gray400,
                ),
        icon: icon,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.all(contentPadding),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        // Error border
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        errorStyle: const TextStyle(
          color: OlaColors.red400,
          fontSize: 12,
          height: 0,
        ),
      ),
      validator: validator,
      autofocus: autofocus,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      cursorColor: cursorColor ?? Colors.lightBlue,
      cursorRadius: const Radius.circular(8),
      cursorWidth: 2,
      controller: textEditingController,
      onEditingComplete: () {
        onEditComplete?.call(textEditingController?.text ?? '');
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onTapOutside: (event) {
        if (hideOnTouchOutside) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
    );
  }
}
