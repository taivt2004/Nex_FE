import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:nexpaylab/share/logger.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class NetworkStateStream {
  // BehaviorSubject to hold the latest network state (connected or disconnected)
  final _networkStateSubject = BehaviorSubject<bool>();

  // Duration for the debounce. Adjust as necessary.
  final Duration debounceDuration = const Duration(milliseconds: 100);

  // Broadcast the network state to the sink
  void broadcastNetworkState({required bool connected}) {
    _networkStateSubject.sink.add(connected);
  }

  // Apply debounceTime to the stream to limit how often values are emitted.
  Stream<bool> get stream => _networkStateSubject
      .debounceTime(debounceDuration) // Add debounce time
      .distinct(); // Prevent emitting the same value multiple times in a row

  // Dispose the BehaviorSubject to avoid memory leaks
  void dispose() {
    _networkStateSubject.close();
  }
}

@singleton
class NetworkChecker {
  NetworkChecker(
    this.networkStateStream,
  );

  final NetworkStateStream networkStateStream;
  StreamSubscription<InternetStatus>? _connectivitySubscription;

  void observeNetworkStatus() {
    _connectivitySubscription ??=
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      talker.debug('on network state changed $status');
      switch (status) {
        case InternetStatus.connected:
          networkStateStream.broadcastNetworkState(connected: true);
        case InternetStatus.disconnected:
          networkStateStream.broadcastNetworkState(connected: false);
      }
    });
  }

  Future<bool> checkConnectivity() async {
    final connected = await isOnline();
    talker.debug('checkConnectivity : $connected');
    networkStateStream.broadcastNetworkState(connected: connected);
    return connected;
  }

  Future<bool> isOnline() async {
    final result = await InternetConnection().hasInternetAccess;
    return result;
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
