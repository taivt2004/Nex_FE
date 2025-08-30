import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:nexpaylab/bloc.observer.dart';
import 'package:nexpaylab/injector.dart';
import 'package:nexpaylab/share/logger.dart';

Future<void> bootstrap(
  FutureOr<Widget> Function() builder,
  String environment,
) async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Pass all uncaught asynchronous errors that aren't handled
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kReleaseMode) {
      talker.error(error, stack);
      return true;
    } else {
      return false;
    }
  };

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await configureDependencies(environment: environment);

  CachedNetworkImage.logLevel =
      kReleaseMode ? CacheManagerLogLevel.none : CacheManagerLogLevel.debug;

  Bloc.observer = OlaBlocObserver();

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ],
  );

  // Lock the app orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    runApp(await builder());
  });

  FlutterNativeSplash.remove();
}
