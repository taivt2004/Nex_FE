import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexpaylab/app/core/network.checker.dart';
import 'package:nexpaylab/feature/home/presentation/bloc/home_bloc.dart';
import 'package:nexpaylab/feature/home/presentation/bloc/home_event.dart';
import 'package:nexpaylab/feature/home/presentation/bloc/home_state.dart';
import 'package:nexpaylab/feature/home/presentation/page/dummy_01.page.dart';
import 'package:nexpaylab/feature/home/presentation/page/dummy_02.page.dart';
import 'package:nexpaylab/feature/home/presentation/page/dummy_03.page.dart';
import 'package:nexpaylab/feature/home/presentation/page/dummy_04.page.dart';
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

import 'package:nexpaylab/feature/home/presentation/bloc/marketplace_bloc/marketplace_bloc.dart';

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

  final bottomBarItems = [
    const BottomBarItem(
      inActiveItem: Icon(Icons.home_rounded, color: OlaColors.gray400),
      activeItem: Icon(Icons.home_rounded, color: Color(0xFF8B5CF6)),
      itemLabel: 'Home',
    ),
    const BottomBarItem(
      inActiveItem: Icon(Icons.swap_horiz_rounded, color: OlaColors.gray400),
      activeItem: Icon(Icons.swap_horiz_rounded, color: Color(0xFF8B5CF6)),
      itemLabel: 'Swap',
    ),
    const BottomBarItem(
      inActiveItem: Icon(Icons.show_chart_rounded, color: OlaColors.gray400),
      activeItem: Icon(Icons.show_chart_rounded, color: Color(0xFF8B5CF6)),
      itemLabel: 'Trending',
    ),
    const BottomBarItem(
      inActiveItem: Icon(Icons.explore_rounded, color: OlaColors.gray400),
      activeItem: Icon(Icons.explore_rounded, color: Color(0xFF8B5CF6)),
      itemLabel: 'Discover',
    ),
  ];

  @override
  void initState() {
    // appLifecycle.observeAppState();
    context.read<HomeBloc>().add(HomeStarted());
    bottomBarPages = [
      const DummyPage01(),
      const DummyPage02(),
      const DummyPage03(),
      const DummyPage04(),
    ];
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
          showErrorDialog(context, desc: state.error);
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
              StreamBuilder<bool>(
                stream: getIt<NetworkStateStream>().stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  final connected = snapshot.requireData;
                  talker.debug('home page network connected: $connected');
                  if (connected) {
                    context.read<HomeBloc>().add(
                      LoadHomeConfig(showLoading: false),
                    );
                    return const SizedBox.shrink();
                  } else {
                    return Positioned(
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
                    );
                  }
                },
              ),
            ],
          ).toContainerWidget(
            context: context,
            extendBody: true,
            safeArea: true,
            showAppBar: false,
            bottomNavigationBar: AnimatedNotchBottomBar(
              bottomBarWidth: constraints.maxWidth,
              notchBottomBarController: _controller,
              showNotch: false,
              showBorder: false,
              bottomBarHeight: 52,
              showLabel: true,
              showBlurBottomBar: true,
              blurOpacity: 0.1,
              blurFilterY: 0,
              textOverflow: TextOverflow.visible,
              showShadow: true,
              shadowElevation: 30,
              elevation: 30,
              kBottomRadius: 0,
              showTopRadius: false,
              color: const Color(0XFF111213),
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
    // appLifecycle.dispose();
    super.dispose();
  }
}
