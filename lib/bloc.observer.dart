// ignore_for_file: strict_raw_type, avoid_dynamic_calls

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexpaylab/share/logger.dart';

class OlaBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    talker.debug('e:${event.runtimeType} bloc: ${bloc.runtimeType}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    talker.debug('${transition.currentState} -> ${transition.nextState} '
        'bloc: ${bloc.runtimeType}, '
        'e:${transition.event.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    talker.warning('error bloc: ${bloc.runtimeType}', error, stackTrace);
  }
}
