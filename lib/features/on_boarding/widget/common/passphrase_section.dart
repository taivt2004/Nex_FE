import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

class PassphraseSection extends StatefulWidget {
  const PassphraseSection({
    required this.isSecure,
    required this.onChanged,
    required this.onPassphraseChanged,
    required this.onConfirmPassphraseChanged,
    this.errorText,
    this.title,
    this.enableConfirm = true,
    this.infoText,
    this.showInfo = true,
    super.key,
  });

  final bool isSecure;
  final ValueChanged<bool> onChanged;
  final ValueChanged<String> onPassphraseChanged;
  final ValueChanged<String> onConfirmPassphraseChanged;
  final String? errorText;
  final String? title;
  final bool enableConfirm;
  final String? infoText;
  final bool showInfo;

  @override
  State<PassphraseSection> createState() => _PassphraseSectionState();
}

class _PassphraseSectionState extends State<PassphraseSection> {
  // Controllers for the two input fields
  late final TextEditingController _passphraseController;
  late final TextEditingController _confirmController;
  late final FocusNode _passphraseFocusNode;
  late final FocusNode _confirmFocusNode;
  int _lastPassLen = 0;

  @override
  void initState() {
    super.initState();
    _passphraseController = TextEditingController();
    _confirmController = TextEditingController();
    _passphraseFocusNode = FocusNode();
    _confirmFocusNode = FocusNode();

    _passphraseController.addListener(() {
      final len = _passphraseController.text.length;
      if (_lastPassLen < 6 && len == 6) {
        _confirmController.clear();
        widget.onConfirmPassphraseChanged('');
        // Auto focus to confirm field when passphrase is full
        if (widget.enableConfirm) {
          _confirmFocusNode.requestFocus();
        }
      }
      _lastPassLen = len;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _passphraseController.dispose();
    _confirmController.dispose();
    _passphraseFocusNode.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final titleText = widget.title ?? l10n.secureYourWallet;
    final infoText = widget.infoText ?? l10n.passphraseInfo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: widget.isSecure
                ? Border.all(color: OlaColors.primarycolor, width: 1.5)
                : Border.all(color: Colors.white24, width: 1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox Row
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  widget.onChanged(!widget.isSecure);
                  if (!widget.isSecure) {
                    // When turning on security, focus on passphrase
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _passphraseFocusNode.requestFocus();
                    });
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: widget.isSecure
                            ? OlaColors.primarycolor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: widget.isSecure
                              ? OlaColors.primarycolor
                              : Colors.white54,
                          width: 2,
                        ),
                      ),
                      child: widget.isSecure
                          ? Icon(Icons.check, size: 16.sp, color: Colors.white)
                          : null,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        titleText,
                        style: PoppinsTextStyles.primary14Regular.copyWith(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Inputs Section
              if (widget.isSecure) ...[
                SizedBox(height: 24.h),
                _PinInput(
                  controller: _passphraseController,
                  focusNode: _passphraseFocusNode,
                  onChanged: widget.onPassphraseChanged,
                ),
                if (widget.enableConfirm &&
                    _passphraseController.text.length == 6) ...[
                  SizedBox(height: 24.h),
                  Center(
                    child: Text(
                      l10n.confirmPassphrase,
                      style: PoppinsTextStyles.primary14Regular.copyWith(
                        color: hasError
                            ? const Color(0xFFFF3B30)
                            : Colors.white54,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _PinInput(
                    controller: _confirmController,
                    focusNode: _confirmFocusNode,
                    onChanged: widget.onConfirmPassphraseChanged,
                    hasError: hasError,
                  ),
                  if (hasError) ...[
                    SizedBox(height: 12.h),
                    Center(
                      child: Text(
                        widget.errorText!,
                        style: PoppinsTextStyles.primary12Regular.copyWith(
                          color: const Color(0xFFFF3B30),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 8.h),
                ],
              ],
            ],
          ),
        ),
        if (widget.isSecure && widget.showInfo) ...[
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 18.sp, color: Colors.white38),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  infoText,
                  style: PoppinsTextStyles.primary12Regular.copyWith(
                    color: Colors.white54,
                    fontSize: 12.sp,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _PinInput extends StatefulWidget {
  const _PinInput({
    required this.controller,
    required this.onChanged,
    this.focusNode,
    this.hasError = false,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;
  final bool hasError;

  @override
  State<_PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<_PinInput> {
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
        height: 44.h, // Tăng chiều cao vùng bấm
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
                    width: 12.h,
                    height: 12.h,
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
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    cursorColor: Colors.transparent,
                    style: TextStyle(color: Colors.transparent, fontSize: 1.sp),
                    onChanged: widget.onChanged,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
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
