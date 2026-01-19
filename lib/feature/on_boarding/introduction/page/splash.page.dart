import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/core/data/localstore/app.config.local.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/gen/assets.gen.dart';
import 'package:nexpaylab/injector.dart';
import 'package:nexpaylab/share/theme/app_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    // Check if user has a wallet (passphrase exists)
    final configStore = getIt<AppConfigLocalStore>();
    final passphraseConfig = await configStore
        .getConfigByKey('local_passphrase')
        .getSingleOrNull();

    if (!mounted) return;

    if (passphraseConfig != null && passphraseConfig.value.isNotEmpty) {
      // Wallet exists -> Go to Lock Screen
      context.go(AppRouter.lockScreen);
    } else {
      // No wallet -> Go to Onboarding
      context.go(AppRouter.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OlaColors.splashcreen, // Nền tối chuẩn Crypto
      body: Stack(
        children: [
          // Indicator ở chính giữa màn hình
          Center(
            child: SizedBox(
              width: 24.w,
              height: 24.h,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                color: OlaColors.primarycolor,
              ),
            ),
          ),
          // Logo đặt phía trên trung tâm một chút
          Align(
            alignment: const Alignment(0, -0.35),
            child: Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: SvgPicture.asset(Assets.images.nexpay.path),
            ),
          ),
        ],
      ),
    );
  }
}
