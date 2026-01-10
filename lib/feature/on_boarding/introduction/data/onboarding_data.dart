class OnboardingModel {
  final String title;
  final String desc;

  const OnboardingModel({
    required this.title,
    required this.desc,
  });

  static const List<OnboardingModel> list = [
    OnboardingModel(
      title: 'Private First,\nSecure and Effortless',
      desc: 'Manage your crypto with absolute privacy and ease.',
    ),
    OnboardingModel(
      title: 'Privacy First',
      desc:
          'With Open Source and Self Custody Key Management — audited for privacy, built for your full control.',
    ),
    OnboardingModel(
      title: 'Strong Security',
      desc:
          'Trusted Execution Environment (TEE) secures encrypted data with hardware-level protection.',
    ),
    OnboardingModel(
      title: 'Simple & Fast',
      desc:
          "NexPay's clean, intuitive interface makes money management effortless.",
    ),
  ];
}
