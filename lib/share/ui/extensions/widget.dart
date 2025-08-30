import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/share/theme/app_style.dart';

extension ContainerWidgetExt on Widget {
  Widget toRemindView({
    required String actionText,
    required Widget icon,
    void Function()? action,
  }) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              this,
              16.verticalSpace,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon,
                  8.horizontalSpace,
                  Text(
                    actionText,
                    style: OlaTextStyles.primarytext14regular
                        .copyWith(color: OlaColors.base499EEF),
                  ),
                ],
              ).toFacyBox(
                onTab: () {
                  action?.call();
                },
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget toContainerWidget({
    required BuildContext context,
    Widget? actionWidget,
    Widget? bottomNavigationBar,
    bool safeArea = false,
    bool showAppBar = false,
    Widget? appBoarTitle,
    Widget? leading,
    Color? appBarBackGroundColor,
    bool extendBody = false,
    void Function()? onBackPressed,
  }) {
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      // backgroundColor: bgColor,
      extendBody: extendBody,
      resizeToAvoidBottomInset: true,
      appBar: showAppBar
          ? AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                systemNavigationBarColor: scaffoldBackgroundColor,
                statusBarColor: scaffoldBackgroundColor,
                statusBarIconBrightness: Brightness.light,
              ),
              elevation: 0,
              title: appBoarTitle,
              actions: [
                if (actionWidget != null) actionWidget,
              ],
              leading: leading,
              backgroundColor: appBarBackGroundColor,
            )
          : null,
      body: safeArea
          ? SafeArea(
              child: this,
            )
          : this,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Widget toFacyBox({
    void Function()? onTab,
    Color? bgColor,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return Ink(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius:
            borderRadius ?? const BorderRadius.all(Radius.circular(8)),
      ),
      child: InkWell(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        onTap: () {
          onTab?.call();
        },
        child: padding != null
            ? Padding(
                padding: padding,
                child: this,
              )
            : this,
      ),
    );
  }

  Widget toRound({
    double? height,
    double? width,
    EdgeInsets? padding,
    Color? color,
    Color? borderColors,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: Border.all(
          color: borderColors ?? (color ?? Colors.transparent),
          width: 0.5,
        ),
      ),
      child: this,
    );
  }

  Widget toCard(
    BuildContext context, {
    EdgeInsets? padding,
    double elevation = 2,
    Color backgroundColor = OlaColors.darkGrey,
    BoxBorder? border,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: OlaColors.gray300.withOpacity(0.5), // Adjust opacity as needed
        //     blurRadius: elevation, // Shadow blur radius
        //     spreadRadius: 0, // Spread radius
        //     offset: Offset(0, elevation), // Position of the shadow
        //   ),
        // ],
        border: border,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: this,
      ),
    );
  }
}
