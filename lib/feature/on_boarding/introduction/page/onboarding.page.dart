import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/feature/on_boarding/introduction/cubit/onboarding_cubit.dart';
import 'package:nexpaylab/feature/on_boarding/introduction/data/onboarding_data.dart';
import 'package:nexpaylab/feature/on_boarding/introduction/widget/onboarding_button.dart';
import 'package:nexpaylab/feature/on_boarding/introduction/widget/onboarding_content.dart';
import 'package:nexpaylab/feature/on_boarding/introduction/widget/onboarding_footer.dart';
import 'package:nexpaylab/feature/on_boarding/introduction/widget/onboarding_illustration.dart';
import 'package:nexpaylab/feature/on_boarding/introduction/widget/onboarding_indicator.dart';
import 'package:nexpaylab/share/theme/app_style.dart';
import 'package:nexpaylab/feature/on_boarding/introduction/widget/already_have_wallet_sheet.dart';
import 'package:nexpaylab/share/utils/colors.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  late final OnboardingCubit _cubit;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _cubit = OnboardingCubit();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _cubit.close();
    super.dispose();
  }

  // Hàm tự động chuyển slide sau mỗi 5s
  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      var currentPage = _cubit.state.currentPage;
      if (currentPage < OnboardingModel.list.length - 1) {
        currentPage++;
      } else {
        currentPage = 0; // Quay lại trang đầu
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  // Khi người dùng chạm vào, reset timer để tránh bị giật
  void _onUserInteraction() {
    _timer?.cancel();
    _startAutoSlide();
  }

  void _showAlreadyHaveWalletSheet() {
    showAlreadyHaveWalletSheet(
      context,
      onContinue: () => context.push(AppRouter.alreadyHaveWallet01),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColor.onboardingGradientStart,
                AppColor.onboardingGradientEnd,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20.h), // Spacing trên
                // --- Phần Ảnh (3D Coin) - TO HƠN ---
                const Expanded(
                  flex: 6, // Tăng từ 5 lên 6 để ảnh có nhiều không gian hơn
                  child: OnboardingIllustration(),
                ),

                SizedBox(height: 20.h), // Khoảng cách giữa ảnh và text
                // --- Phần Slide Text - KÉO XUỐNG ---
                Expanded(
                  flex: 3, // Giảm từ 4 xuống 3
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (value) {
                      _cubit.setPage(value);
                      _onUserInteraction();
                    },
                    itemCount: OnboardingModel.list.length,
                    itemBuilder: (context, index) {
                      final item = OnboardingModel.list[index];
                      return OnboardingContent(
                        title: item.title,
                        desc: item.desc,
                      );
                    },
                  ),
                ),
                // --- Indicator (Dấu chấm) ---
                BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        OnboardingModel.list.length,
                        (index) => OnboardingIndicator(
                          index: index,
                          currentPage: state.currentPage,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 32.h),

                // --- Các nút bấm ---
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      OnboardingPrimaryButton(
                        text: 'Create new wallet',
                        onTap: () {
                          // Todo: Navigate to Create Wallet
                          context.push(AppRouter.createNewWallet01);
                        },
                      ),
                      SizedBox(height: 16.h),
                      OnboardingSecondaryButton(
                        text: 'I already have a wallet',
                        onTap: _showAlreadyHaveWalletSheet,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // --- Footer Text ---
                const OnboardingFooter(),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
