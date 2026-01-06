import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/injector.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/share/theme/theme.mode.dart';
import 'package:nexpaylab/share/utils/constants.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ChangeNotifierProvider<ThemeModel>(
        create: (BuildContext context) => getIt<ThemeModel>(),
        child: ScreenUtilInit(
          designSize: const Size(ScreenUtilSize.width, ScreenUtilSize.height),
          builder: (context, child) {
            final themeProvider = Provider.of<ThemeModel>(context);
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              scaffoldMessengerKey: rootScaffoldMessengerKey,
              theme: themeProvider.currentTheme,
              darkTheme: themeProvider.darkTheme,
              themeMode: themeProvider.themeMode,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: router(AppRouter.splash),
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
