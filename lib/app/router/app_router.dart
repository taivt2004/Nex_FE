import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/core/user.session.dart';
import 'package:nexpaylab/app/database/database.dart';
import 'package:nexpaylab/feature/create_new_wallet/page/create_new_wallet_01.dart';
import 'package:nexpaylab/feature/home/presentation/page/home.page.dart';
import 'package:nexpaylab/feature/login.register/page/login.page.dart';
import 'package:nexpaylab/feature/login.register/page/register.page.dart';
import 'package:nexpaylab/feature/on_boarding/page/onboarding.page.dart';
import 'package:nexpaylab/feature/on_boarding/page/splash.page.dart';
import 'package:nexpaylab/feature/already_have_wallet/page/already_have_wallet_01.dart';
import 'package:nexpaylab/injector.dart';
import 'package:nexpaylab/share/logger.dart';

class AppRouter extends Equatable {
  static const home = '/';
  static const login = '/login';
  static const register = '/register';
  static const onboarding = '/onboarding';
  static const splash = '/splash';
  static const databaseViwer = '/db_viewer';
  static const createNewWallet01 = '/create_new_wallet_01';
  static const alreadyHaveWallet01 = '/already_have_wallet_01';

  @override
  List<Object?> get props => [home];
}

GoRouter router([String? initialLocation]) => GoRouter(
  debugLogDiagnostics: kDebugMode || kProfileMode,
  initialLocation: initialLocation ?? '/',
  routes: [
    GoRoute(
      path: AppRouter.databaseViwer,
      builder: (context, state) => DriftDbViewer(Database()),
    ),
    GoRoute(
      path: AppRouter.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRouter.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRouter.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRouter.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRouter.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRouter.createNewWallet01,
      builder: (context, state) => const CreateNewWallet01Page(),
    ),
    GoRoute(
      path: AppRouter.alreadyHaveWallet01,
      builder: (context, state) => const AlreadyHaveWallet01Page(),
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) async {
    // Define a list of whitelisted paths
    // final whitelistPaths = [AppRouter.login, AppRouter.register];

    // // Check if the current path is in the whitelist
    // final isPathWhitelisted = whitelistPaths.any(
    //   (whitelistedPath) => state.fullPath?.startsWith(whitelistedPath) ?? false,
    // );

    // // If the path is not in the whitelist, check if the user is logged in
    // if (!isPathWhitelisted) {
    //   final isLoggedIn = await getIt<UserSession>().isLoggedIn();
    //   talker.debug('go router: redirect to ${state.fullPath}');

    //   // If not logged in and the path requires authentication, redirect to login
    //   if (!isLoggedIn) {
    //     return AppRouter.login;
    //   } else {
    //     return AppRouter.home;
    //   }
    // }

    // If the user is logged in or the path is whitelisted, no redirect occurs
    return null;
  },
);
