import 'package:nexpaylab/app/data/model/base/base_res.dart';
import 'package:nexpaylab/app/data/model/common/config_res.dart';

enum HomeStatus { idle, loading, success, failure }

class HomeState {
  const HomeState({
    this.status = HomeStatus.idle,
    this.config,
    this.errorMessage,
  });

  final HomeStatus status;
  final BaseRes<ConfigRes>? config;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    BaseRes<ConfigRes>? config,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      config: config ?? this.config,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
