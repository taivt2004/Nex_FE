part of 'app_config_bloc.dart';

enum AppConfigStatus { initial, loading, updateRequired, success, failure }

class AppConfigState extends Equatable {
  const AppConfigState({
    this.status = AppConfigStatus.initial,
    this.storeUrl,
    this.isForceUpdate = false,
  });

  final AppConfigStatus status;
  final String? storeUrl;
  final bool isForceUpdate;

  AppConfigState copyWith({
    AppConfigStatus? status,
    String? storeUrl,
    bool? isForceUpdate,
  }) {
    return AppConfigState(
      status: status ?? this.status,
      storeUrl: storeUrl ?? this.storeUrl,
      isForceUpdate: isForceUpdate ?? this.isForceUpdate,
    );
  }

  @override
  List<Object?> get props => [status, storeUrl, isForceUpdate];
}
