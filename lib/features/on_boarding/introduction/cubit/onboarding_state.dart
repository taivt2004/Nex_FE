part of 'onboarding_cubit.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState({required this.currentPage});
  final int currentPage;

  @override
  List<Object> get props => [currentPage];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial() : super(currentPage: 0);
}

class OnboardingPageChanged extends OnboardingState {
  const OnboardingPageChanged(int currentPage) : super(currentPage: currentPage);
}
