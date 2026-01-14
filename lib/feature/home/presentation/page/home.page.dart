import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/app/core/network.checker.dart';
import 'package:nexpaylab/feature/home/coinmarket/marketplace_bloc/marketplace_bloc.dart';
import 'package:nexpaylab/feature/home/presentation/bloc/home_bloc.dart';
import 'package:nexpaylab/feature/home/presentation/bloc/home_event.dart';
import 'package:nexpaylab/feature/home/presentation/bloc/home_state.dart';
import 'package:nexpaylab/feature/home/presentation/page/discover.page.dart';
import 'package:nexpaylab/feature/home/presentation/page/home_tab.page.dart';
import 'package:nexpaylab/feature/home/presentation/page/swap.page.dart';
import 'package:nexpaylab/feature/home/presentation/page/trending.page.dart';
import 'package:nexpaylab/gen/assets.gen.dart';
import 'package:nexpaylab/injector.dart';
import 'package:nexpaylab/share/logger.dart';
import 'package:nexpaylab/share/theme/app_style.dart';
import 'package:nexpaylab/share/ui/dialogs.dart';
import 'package:nexpaylab/share/ui/extensions/image.dart';
import 'package:nexpaylab/share/ui/extensions/widget.dart';
import 'package:nexpaylab/share/ui/loading/loading_screen.dart';
import 'package:nexpaylab/share/ui/widget/navigation/models/bottom_bar_item_model.dart';
import 'package:nexpaylab/share/ui/widget/navigation/notch_bottom_bar.dart';
import 'package:nexpaylab/share/ui/widget/navigation/notch_bottom_bar_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<HomeBloc>()),
        BlocProvider(
          create: (_) => getIt<MarketplaceBloc>()..add(MarketplaceFetched()),
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

  final bottomBarItems = [
    const BottomBarItem(
      inActiveItem: Icon(Icons.home_rounded, color: OlaColors.gray400),
      activeItem: Icon(Icons.home_rounded, color: OlaColors.primarycolor),
      itemLabel: 'Home',
    ),
    BottomBarItem(
      inActiveItem: Assets.iconsHomeBottomMenu.icMenuSwap.load(color: OlaColors.gray400),
      activeItem: Assets.iconsHomeBottomMenu.icMenuSwap.load(
        color: OlaColors.primarycolor,
      ),
      itemLabel: 'Swap',
    ),
    BottomBarItem(
      inActiveItem: Assets.iconsHomeBottomMenu.icMenuTrending.load(
        color: OlaColors.gray400,
      ),
      activeItem: Assets.iconsHomeBottomMenu.icMenuTrending.load(
        color: OlaColors.primarycolor,
      ),
      itemLabel: 'Trending',
    ),
    BottomBarItem(
      inActiveItem: Assets.iconsHomeBottomMenu.icMenuDiscover.load(
        color: OlaColors.gray400,
      ),
      activeItem: Assets.iconsHomeBottomMenu.icMenuDiscover.load(
        color: OlaColors.primarycolor,
      ),
      itemLabel: 'Discover',
    ),
  ];

  @override
  void initState() {
    // appLifecycle.observeAppState();
    context.read<HomeBloc>().add(HomeStarted());
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
                          'Vui lòng kiểm tra kết nối mạng',
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
              color: OlaColors.appbackground,
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
