import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/di/injector.config.dart';

final getIt = GetIt.instance;

@InjectableInit(generateForDir: ['lib', 'test'])
Future<void> configureDependencies({required String environment}) async =>
    getIt.init(
      environment: environment,
    );
