import 'package:nexpaylab/l10n/arb/app_localizations.dart';

class OnboardingModel {
  
  const OnboardingModel({
    required this.title,
    required this.desc,
  });
  final String title;
  final String desc;
  
  static const int pageCount = 4;

  static List<OnboardingModel> getList(AppLocalizations l10n) => [
    OnboardingModel(
      title: l10n.onboardingTitle1,
      desc: l10n.onboardingDesc1,
    ),
    OnboardingModel(
      title: l10n.onboardingTitle2,
      desc: l10n.onboardingDesc2,
    ),
    OnboardingModel(
      title: l10n.onboardingTitle3,
      desc: l10n.onboardingDesc3,
    ),
    OnboardingModel(
      title: l10n.onboardingTitle4,
      desc: l10n.onboardingDesc4,
    ),
  ];
}
