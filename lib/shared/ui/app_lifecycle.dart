import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/shared/logger.dart';

@singleton
class AppLifecycle {
  AppLifecycleListener? _listener;

  void observeAppState() {
    _listener ??= AppLifecycleListener(
      onStateChange: _onStateChanged,
    );
  }

  // Listen to the app lifecycle state changes
  void _onStateChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        _onDetached();
      case AppLifecycleState.resumed:
        _onResumed();
      case AppLifecycleState.inactive:
        _onInactive();
      case AppLifecycleState.hidden:
        _onHidden();
      case AppLifecycleState.paused:
        _onPaused();
    }
  }

  void _onDetached() => talker.debug('AppLifecycle:detached');

  void _onResumed() => talker.debug('AppLifecycle:resumed');

  void _onInactive() => talker.debug('AppLifecycle:inactive');

  void _onHidden() => talker.debug('AppLifecycle:hidden');

  void _onPaused() => talker.debug('AppLifecycle:paused');

  void dispose() {
    _listener?.dispose();
  }
}
