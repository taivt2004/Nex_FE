
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_tab_state.dart';

class HomeTabCubit extends Cubit<HomeTabState> {
  HomeTabCubit() : super(const HomeTabState());

  void setSynced({required bool value}) {
    if (state.isSynced == value) return;
    emit(state.copyWith(isSynced: value));
  }

  void setCurrentPaymentPage(int value) {
    if (state.currentPaymentPage == value) return;
    emit(state.copyWith(currentPaymentPage: value));
  }
}
