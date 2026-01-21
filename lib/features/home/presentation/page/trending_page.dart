import 'package:flutter/widgets.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';

class TrendingPage extends StatelessWidget {
  const TrendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(AppLocalizations.of(context).trendingTitle));
  }
} 
