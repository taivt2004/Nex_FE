import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SimpleTextView extends StatelessWidget {
  const SimpleTextView(
    this.text, {
    this.style,
    this.textAlign,
    this.maxLines = 3,
    this.wrap = false,
    super.key,
  });

  final String? text;
  final int maxLines;
  final bool wrap;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    if (wrap == false) {
      return AutoSizeText(
        text ?? '',
        maxLines: maxLines,
        style: style,
        textAlign: textAlign,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      return Expanded(
        child: AutoSizeText(
          text ?? '',
          maxLines: maxLines,
          style: style,
          textAlign: textAlign,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }
}
