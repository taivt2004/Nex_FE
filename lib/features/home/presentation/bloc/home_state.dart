abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {
  HomeLoading({required this.message});

  final String message;
}

class HomeSuccess extends HomeState {}

class HomeError extends HomeState {
  HomeError({required this.error});
  final String error;
}

class HomeNetworkError extends HomeState {
  HomeNetworkError({required this.error});
  final String error;
}
