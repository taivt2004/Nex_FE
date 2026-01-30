part of 'splash_bloc.dart';

abstract class SplashEvent {}

class SplashStarted extends SplashEvent {}

class SplashSkippedUpdate extends SplashEvent {}
