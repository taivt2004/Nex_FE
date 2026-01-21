import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/di/injector.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/constants/app_constants.dart';
import 'package:nexpaylab/shared/language/language_model.dart';
import 'package:nexpaylab/shared/theme/theme_mode.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = router(AppRouter.splash);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeModel>(create: (_) => getIt<ThemeModel>()),
          ChangeNotifierProvider<LanguageModel>(
            create: (_) => getIt<LanguageModel>(),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(ScreenUtilSize.width, ScreenUtilSize.height),
          builder: (context, child) {
            final themeProvider = Provider.of<ThemeModel>(context);
            final languageProvider = Provider.of<LanguageModel>(context);
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              scaffoldMessengerKey: rootScaffoldMessengerKey,
              theme: themeProvider.currentTheme,
              darkTheme: themeProvider.darkTheme,
              themeMode: themeProvider.themeMode,
              locale: languageProvider.currentLocale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: _router,
              builder: (context, widget) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.noScaling),
                  child: widget!,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
