import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/features/on_boarding/introduction/cubit/onboarding_cubit.dart';
import 'package:nexpaylab/features/on_boarding/introduction/data/onboarding_data.dart';
import 'package:nexpaylab/features/on_boarding/introduction/widget/already_have_wallet_sheet.dart';
import 'package:nexpaylab/features/on_boarding/introduction/widget/onboarding_button.dart';
import 'package:nexpaylab/features/on_boarding/introduction/widget/onboarding_content.dart';
import 'package:nexpaylab/features/on_boarding/introduction/widget/onboarding_footer.dart';
import 'package:nexpaylab/features/on_boarding/introduction/widget/onboarding_illustration.dart';
import 'package:nexpaylab/features/on_boarding/introduction/widget/onboarding_indicator.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/utils/colors.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (!mounted) return;
      final cubit = context.read<OnboardingCubit>();
      if (cubit.state.currentPage < 2) {
        cubit.setPage(cubit.state.currentPage + 1);
        _pageController.animateToPage(
          cubit.state.currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      } else {
        _timer?.cancel();
      }
    });
  }

  void _onUserInteraction() {
    _timer?.cancel();
    _startAutoSlide();
  }

  void _showAlreadyHaveWalletSheet() {
    showAlreadyHaveWalletSheet(
      context,
      onContinue: () async {
        await context.push(AppRouter.alreadyHaveWallet01);
      },
    );

  }

  Future<void> _onCreateNewWalletTap() async {
    await context.push(AppRouter.createNewWallet01);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onboardingList = OnboardingModel.getList(l10n);

    return Scaffold(
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
              SizedBox(height: 20.h),

              const Expanded(flex: 6, child: OnboardingIllustration()),

              SizedBox(height: 20.h),

              Expanded(
                flex: 3,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    context.read<OnboardingCubit>().setPage(value);
                    _onUserInteraction();
                  },
                  itemCount: onboardingList.length,
                  itemBuilder: (context, index) {
                    final item = onboardingList[index];
                    return OnboardingContent(
                      title: item.title,
                      desc: item.desc,
                    );
                  },
                ),
              ),

              BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingList.length,
                      (index) => OnboardingIndicator(
                        index: index,
                        currentPage: state.currentPage,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 32.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
           OnboardingPrimaryButton(
                      text: l10n.createNewWallet,
                      onTap: _onCreateNewWalletTap,
                    ),
                    SizedBox(height: 16.h),
                    OnboardingSecondaryButton(
                      text: l10n.alreadyHaveWallet,
                      onTap: _showAlreadyHaveWalletSheet,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              const OnboardingFooter(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
