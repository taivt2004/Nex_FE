import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/di/dependency_injection.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/features/splash/presentation/bloc/app_config/app_config_bloc.dart';
import 'package:nexpaylab/features/splash/presentation/bloc/auth_check/auth_check_bloc.dart';
import 'package:nexpaylab/gen/assets.gen.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AppConfigBloc>()..add(AppConfigStarted()),
        ),
        BlocProvider(
          create: (_) => getIt<AuthCheckBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AppConfigBloc, AppConfigState>(
            listener: (context, state) {
              if (state.status == AppConfigStatus.updateRequired) {
                showDialog<void>(
                  context: context,
                  barrierDismissible: !state.isForceUpdate,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.updateApp),
                    content: Text(l10n.updateAppContent),
                    actions: [
                      if (!state.isForceUpdate)
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            context
                                .read<AuthCheckBloc>()
                                .add(AuthCheckStarted());
                          },
                          child: Text(l10n.skip),
                        ),
                      TextButton(
                        onPressed: () {
                          if (state.storeUrl != null) {
                            launchUrl(
                              Uri.parse(state.storeUrl!),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: Text(l10n.updateNow),
                      ),
                    ],
                  ),
                );
              } else if (state.status == AppConfigStatus.success) {
                context.read<AuthCheckBloc>().add(AuthCheckStarted());
              }
            },
          ),
          BlocListener<AuthCheckBloc, AuthCheckState>(
            listener: (context, state) {
              if (state.status == AuthCheckStatus.authenticated) {
                context.go(AppRouter.lockScreen);
              } else if (state.status == AuthCheckStatus.unauthenticated) {
                context.go(AppRouter.onboarding);
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: OlaColors.splashcreen,
          body: Stack(
            children: [
              Align(
                alignment: const Alignment(0, -0.35),
                child: Container(
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: SvgPicture.asset(Assets.images.nexpay.path),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
