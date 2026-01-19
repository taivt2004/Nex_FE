import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/share/theme/app_style.dart';

class LockPinInput extends StatefulWidget {
  const LockPinInput({
    required this.controller,
    required this.onChanged,
    this.focusNode,
    this.hasError = false,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;
  final bool hasError;

  @override
  State<LockPinInput> createState() => _LockPinInputState();
}

class _LockPinInputState extends State<LockPinInput> {
  late FocusNode _internalFocusNode;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode();
    widget.controller.addListener(_updateState);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateState);
    _internalFocusNode.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final length = widget.controller.text.length;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).requestFocus(_effectiveFocusNode),
      child: Container(
        height: 44.h,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                final filled = index < length;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Container(
                    width: 16.h, // Slightly larger for lock screen
                    height: 16.h,
                    decoration: widget.hasError
                        ? BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFFF3B30),
                              width: 1.5,
                            ),
                          )
                        : BoxDecoration(
                            color: filled
                                ? OlaColors.primarycolor
                                : Colors.white12,
                            shape: BoxShape.circle,
                          ),
                  ),
                );
              }),
            ),
            Positioned.fill(
              child: IgnorePointer(
                ignoring: false,
                child: Opacity(
                  opacity: 0,
                  child: TextField(
                    focusNode: _effectiveFocusNode,
                    controller: widget.controller,
                    onChanged: widget.onChanged,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    autofocus: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
