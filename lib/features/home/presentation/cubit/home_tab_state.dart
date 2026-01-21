part of 'home_tab_cubit.dart';

class HomeTabState extends Equatable {
  const HomeTabState({
    this.currentPaymentPage = 0,
    this.isSynced = false,
  });

  final int currentPaymentPage;
  final bool isSynced;

  HomeTabState copyWith({
    int? currentPaymentPage,
    bool? isSynced,
  }) {
    return HomeTabState(
      currentPaymentPage: currentPaymentPage ?? this.currentPaymentPage,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  List<Object?> get props => [currentPaymentPage, isSynced];

}
