import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

class AppbarCpn extends StatelessWidget implements PreferredSizeWidget {
  const AppbarCpn({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    this.onLeadingTap,
  }) : assert(
          title == null || titleWidget == null,
          'Cannot provide both title and titleWidget',
        );

  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final VoidCallback? onLeadingTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: leading ??
          (context.canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onLeadingTap ?? () => context.pop(),
                )
              : null),
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: PoppinsTextStyles.primary18Regular,
                )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
