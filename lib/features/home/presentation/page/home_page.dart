import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/app/di/injector.dart';
import 'package:nexpaylab/app/network/network_checker.dart';
import 'package:nexpaylab/features/home/coinmarket/marketplace_bloc/marketplace_bloc.dart';
import 'package:nexpaylab/features/home/presentation/bloc/home_bloc.dart';
import 'package:nexpaylab/features/home/presentation/bloc/home_event.dart';
import 'package:nexpaylab/features/home/presentation/bloc/home_state.dart';
import 'package:nexpaylab/features/home/presentation/page/discover_page.dart';
import 'package:nexpaylab/features/home/presentation/page/home_tab_page.dart';
import 'package:nexpaylab/features/home/presentation/page/swap_page.dart';
import 'package:nexpaylab/features/home/presentation/page/trending_page.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/logger.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';
import 'package:nexpaylab/shared/ui/dialogs.dart';
import 'package:nexpaylab/shared/ui/extensions/image.dart';
import 'package:nexpaylab/shared/ui/extensions/widget.dart';
import 'package:nexpaylab/shared/ui/loading/loading_screen.dart';
import 'package:nexpaylab/shared/ui/widget/navigation/models/bottom_bar_item_model.dart';
import 'package:nexpaylab/shared/ui/widget/navigation/notch_bottom_bar.dart';
import 'package:nexpaylab/shared/ui/widget/navigation/notch_bottom_bar_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<HomeBloc>()),
        BlocProvider(
          create: (_) => getIt<MarketplaceBloc>()..add(FetchMarketplace()),
        ),
      ],
      child: const HomeForm(),
    );
  }
}

class HomeForm extends StatefulWidget {
  const HomeForm({super.key});

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  // final appLifecycle = getIt<AppLifecycle>();

  final _pageController = PageController(initialPage: 0);

  final _controller = NotchBottomBarController(index: 0);

  late List<Widget> bottomBarPages;

  late StreamSubscription<bool> _networkSub;
  bool _connected = true;



  @override
  void initState() {
    // appLifecycle.observeAppState();
    context.read<HomeBloc>().add(InitializeHome());
    bottomBarPages = [
      const HomeTabPage(),
      const SwapPage(),
      const TrendingPage(),
      const DiscoverPage(),
    ];
    _networkSub = getIt<NetworkStateStream>().stream.distinct().listen((c) {
      _connected = c;
      if (mounted) {
        if (c) {
          context.read<HomeBloc>().add(LoadHomeConfig(showLoading: false));
        }
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    talker.debug('HomePage rebuild');
    final l10n = AppLocalizations.of(context);
    final bottomBarItems = [
      BottomBarItem(
        inActiveItem: const Icon(Icons.home_rounded, color: OlaColors.gray400),
        activeItem: const Icon(Icons.home_rounded, color: OlaColors.primarycolor),
        itemLabel: l10n.home,
      ),
      BottomBarItem(
        inActiveItem: AppAssets.homeBottomMenu.icMenuSwap.load(
          color: OlaColors.gray400,
        ),
        activeItem: AppAssets.homeBottomMenu.icMenuSwap.load(
          color: OlaColors.primarycolor,
        ),
        itemLabel: l10n.swap,
      ),
      BottomBarItem(
        inActiveItem: AppAssets.homeBottomMenu.icMenuTrending.load(
          color: OlaColors.gray400,
        ),
        activeItem: AppAssets.homeBottomMenu.icMenuTrending.load(
          color: OlaColors.primarycolor,
        ),
        itemLabel: l10n.trending,
      ),
      BottomBarItem(
        inActiveItem: AppAssets.homeBottomMenu.icMenuDiscover.load(
          color: OlaColors.gray400,
        ),
        activeItem: AppAssets.homeBottomMenu.icMenuDiscover.load(
          color: OlaColors.primarycolor,
        ),
        itemLabel: l10n.discover,
      ),
    ];
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoading) {
          LoadingScreen.instance().show(context: context, text: state.message);
        } else if (state is HomeError) {
          LoadingScreen.instance().hide();
          showErrorDialog(context, desc: state.error);
        } else if (state is HomeNetworkError) {
          LoadingScreen.instance().hide();
        } else {
          LoadingScreen.instance().hide();
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  bottomBarPages.length,
                  (index) => bottomBarPages[index],
                ),
              ),
              if (!_connected)
                Positioned(
                  left: 0,
                  right: 0,
                  child: ColoredBox(
                    color: const Color.fromRGBO(255, 0, 0, 0.6),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          AppLocalizations.of(context).checkNetworkConnection,
                          style: OlaTextStyles.subtext12regular.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ).toContainerWidget(
            context: context,
            extendBody: false,
            safeArea: true,
            showAppBar: false,
            bottomNavigationBar: AnimatedNotchBottomBar(
              bottomBarWidth: constraints.maxWidth,
              notchBottomBarController: _controller,
              showNotch: false,
              showBorder: true,
              topBorderOnly: true,
              bottomBarHeight: 70.h,
              showLabel: true,
              showBlurBottomBar: false,
              textOverflow: TextOverflow.visible,
              showShadow: false,
              shadowElevation: 0,
              elevation: 0,
              kBottomRadius: 0,
              showTopRadius: false,
              color: Theme.of(context).scaffoldBackgroundColor,
              // notchColor: OlaColors.gray700,
              notchGradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [OlaColors.gray50, OlaColors.gray100],
              ),
              removeMargins: true,
              durationInMilliSeconds: 200,
              itemLabelStyle: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontSize: 10),
              activeItemLabelStyle: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(fontSize: 10, color: OlaColors.primarycolor),
              bottomBarItems: bottomBarItems,
              onTap: _pageController.jumpToPage,
              kIconSize: 22,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _networkSub.cancel();
    // appLifecycle.dispose();
    super.dispose();
  }
}
