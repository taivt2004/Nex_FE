import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/database/app_config_local.dart';
import 'package:nexpaylab/app/database/database.dart';

part 'home_config_state.dart';

@injectable
class HomeConfigCubit extends Cubit<HomeConfigState> {
  HomeConfigCubit(this.appConfigLocalStore) : super(const HomeConfigState()) {
    _init();
  }

  final AppConfigLocalStore appConfigLocalStore;
  StreamSubscription<List<AppConfig>>? _configSubscription;

  void _init() {
    _configSubscription = appConfigLocalStore
        .watchConfigs(['f_swap', 'f_product']).listen((configs) {
      final disabledIndices = <int>{};

      // Check f_swap (Index 1)
      final swapConfig = configs.firstWhere(
        (c) => c.key == 'f_swap',
        orElse: () => const AppConfig(key: 'f_swap', value: 'on'),
      );
      if (swapConfig.value != 'on') {
        disabledIndices.add(1);
      }

      final productConfig = configs.firstWhere(
        (c) => c.key == 'f_product',
        orElse: () => const AppConfig(key: 'f_product', value: 'on'),
      );
      if (productConfig.value != 'on') {
        disabledIndices..add(2)..add(3);
      }


      emit(state.copyWith(disabledIndices: disabledIndices));
    });
  }

  @override
  Future<void> close() {
    _configSubscription?.cancel();
    return super.close();
  }
}
