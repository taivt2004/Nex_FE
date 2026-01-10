import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/router/app_router.dart';
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
    // 1. Chờ 2 giây để hiển thị logo
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 2. Kiểm tra trạng thái đăng nhập (giả lập là chưa login)
    // Sau này sẽ check UserSession ở đây
    // bool isLoggedIn = await getIt<UserSession>().isLoggedIn();
    const isLoggedIn = false;

    // 3. Điều hướng
    if (isLoggedIn) {
      // Nếu đã login -> Vào Home (hoặc Passcode nếu có)
      context.go(AppRouter.home);
    } else {
      // Nếu chưa login -> Vào Onboarding
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
              child: Image.asset(
                'assets/images/NEXPAY.png',
                width: 200.w,
                height: 200.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
