part of 'home_config_cubit.dart';

class HomeConfigState {
  const HomeConfigState({
    this.disabledIndices = const {},
  });

  final Set<int> disabledIndices;

  HomeConfigState copyWith({
    Set<int>? disabledIndices,
  }) {
    return HomeConfigState(
      disabledIndices: disabledIndices ?? this.disabledIndices,
    );
  }
}
