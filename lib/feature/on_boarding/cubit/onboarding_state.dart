part of 'onboarding_cubit.dart';

abstract class OnboardingState extends Equatable {
  final int currentPage;
  const OnboardingState({required this.currentPage});

  @override
  List<Object> get props => [currentPage];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial() : super(currentPage: 0);
}

class OnboardingPageChanged extends OnboardingState {
  const OnboardingPageChanged(int currentPage) : super(currentPage: currentPage);
}
