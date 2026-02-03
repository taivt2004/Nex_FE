import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

Future<void> showConfirmDialog(
  BuildContext context, {
  required String content,
  String? title,
  String? desc,
  void Function()? ok,
}) {
  final l10n = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: StringUtils.isNotNullOrEmpty(title)
            ? Text(
                title!,
              )
            : null,
        content: Text(
          content,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(
              l10n.dialogBack,
              style: OlaTextStyles.primarytext14semibold
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(
              l10n.dialogConfirm,
              style: OlaTextStyles.primarytext14semibold
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              ok?.call();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showInfoDialog(
  BuildContext context, {
  required String desc,
  void Function()? ok,
}) {
  final l10n = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(
          desc,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(
              l10n.dialogClose,
              style: OlaTextStyles.primarytext14semibold
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              ok?.call();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showErrorDialog(
  BuildContext context, {
  required String desc,
  void Function()? ok,
}) {
  final l10n = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(
          desc,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(
              l10n.dialogClose,
              style: OlaTextStyles.primarytext14semibold
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              ok?.call();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
