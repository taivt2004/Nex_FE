import 'package:flutter/widgets.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(AppLocalizations.of(context).discoverTitle));
  }
} 
