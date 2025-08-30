import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {}

class LoadHomeConfig extends HomeEvent {
  LoadHomeConfig({required this.showLoading});

  final bool showLoading;
}
