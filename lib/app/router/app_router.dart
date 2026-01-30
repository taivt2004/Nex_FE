import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/database/database.dart';
import 'package:nexpaylab/features/auth/presentation/page/login_page.dart';
import 'package:nexpaylab/features/auth/presentation/page/register_page.dart';
import 'package:nexpaylab/features/home/presentation/page/home_page.dart';
import 'package:nexpaylab/features/lock_screen/presentation/page/lock_screen_page.dart';
import 'package:nexpaylab/features/on_boarding/already_have_wallet/page/already_have_wallet_01.dart';
import 'package:nexpaylab/features/on_boarding/create_new_wallet/page/create_new_wallet_01.dart';
import 'package:nexpaylab/features/on_boarding/introduction/page/onboarding_page.dart';
import 'package:nexpaylab/features/settings/presentation/page/settings_page.dart';
import 'package:nexpaylab/features/splash/presentation/page/splash_page.dart';

class AppRouter extends Equatable {
  static const home = '/';
  static const login = '/login';
  static const register = '/register';
  static const onboarding = '/onboarding';
  static const splash = '/splash';
  static const databaseViwer = '/db_viewer';
  static const createNewWallet01 = '/create_new_wallet_01';
  static const alreadyHaveWallet01 = '/already_have_wallet_01';
  static const lockScreen = '/lock_screen';
  static const settings = '/settings';
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
      path: AppRouter.settings,
      builder: (context, state) => const SettingsPage(),
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
    GoRoute(
      path: AppRouter.lockScreen,
      builder: (context, state) => const LockScreenPage(),
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
