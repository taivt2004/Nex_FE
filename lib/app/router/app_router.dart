import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/core/user.session.dart';
import 'package:nexpaylab/app/database/database.dart';
import 'package:nexpaylab/feature/home/presentation/page/home.page.dart';
import 'package:nexpaylab/feature/login.register/page/login.page.dart';
import 'package:nexpaylab/feature/login.register/page/register.page.dart';
import 'package:nexpaylab/injector.dart';
import 'package:nexpaylab/share/logger.dart';

class AppRouter extends Equatable {
  static const home = '/';
  static const login = '/login';
  static const register = '/register';
  static const databaseViwer = '/db_viewer';

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
          path: AppRouter.home,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRouter.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRouter.register,
          builder: (context, state) => const RegisterPage(),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) async {
        // Define a list of whitelisted paths
        final whitelistPaths = [
          '',
        ];

        // Check if the current path is in the whitelist
        final isPathWhitelisted = whitelistPaths.any((whitelistedPath) =>
            state.fullPath?.startsWith(whitelistedPath) ?? false);

        // If the path is not in the whitelist, check if the user is logged in
        if (isPathWhitelisted) {
          final isLoggedIn = await getIt<UserSession>().isLoggedIn();
          talker.debug('go router: redirect to ${state.fullPath}');

          // If not logged in and the path requires authentication, redirect to login
          if (!isLoggedIn) {
            return AppRouter.login;
          }
        }

        // If the user is logged in or the path is whitelisted, no redirect occurs
        return null;
      },
    );
