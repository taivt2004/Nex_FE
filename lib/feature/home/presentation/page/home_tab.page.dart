import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/feature/home/coinmarket/marketplace_bloc/marketplace_bloc.dart';
import 'package:nexpaylab/feature/home/coinmarket/page/coinmarket.page.dart';
import 'package:nexpaylab/feature/home/presentation/cubit/home_tab_cubit.dart';
import 'package:nexpaylab/feature/home/presentation/widget/home_tab/home_crypto_actives_header.dart';
import 'package:nexpaylab/feature/home/presentation/widget/home_tab/home_payment_section.dart';
import 'package:nexpaylab/feature/home/presentation/widget/home_tab/home_quick_actions_section.dart';
import 'package:nexpaylab/feature/home/presentation/widget/home_tab/home_top_bar.dart';
import 'package:nexpaylab/feature/home/presentation/widget/home_tab/home_total_value_section.dart';
import 'package:nexpaylab/gen/assets.gen.dart';
import 'package:nexpaylab/share/theme/app_style.dart';
import 'package:nexpaylab/share/ui/extensions/image.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  late final PageController _paymentPageController;
  late final HomeTabCubit _cubit;
  final List<HomePaymentCard> _paymentCards = const [
    HomePaymentCard(
      image:
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=200&h=200&fit=crop',
      label: 'Coffee shop',
    ),
    HomePaymentCard(
      image:
          'https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=200&h=200&fit=crop',
      label: 'Template d..',
    ),
    HomePaymentCard(
      image:
          'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=200&h=200&fit=crop',
      label: 'Shop online',
    ),
    HomePaymentCard(
      image:
          'https://images.unsplash.com/photo-1556742502-ec7c0e9f34b1?w=200&h=200&fit=crop',
      label: 'Pay bills',
    ),
    HomePaymentCard(
      image:
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=200&h=200&fit=crop',
      label: 'Coffee shop',
    ),
    HomePaymentCard(
      image:
          'https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=200&h=200&fit=crop',
      label: 'Template d..',
    ),
    HomePaymentCard(
      image:
          'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=200&h=200&fit=crop',
      label: 'Shop online',
    ),
    HomePaymentCard(
      image:
          'https://images.unsplash.com/photo-1556742502-ec7c0e9f34b1?w=200&h=200&fit=crop',
      label: 'Pay bills',
    ),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _cubit = HomeTabCubit();
    _scrollController.addListener(_onScroll);
    _paymentPageController = PageController();
  }

  @override
  void dispose() {
    _cubit.close();
    _scrollController.dispose();
    _paymentPageController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final bloc = context.read<MarketplaceBloc>();

      if (bloc.state.status != MarketplaceStatus.loading &&
          !bloc.state.hasReachedMax) {
        bloc.add(MarketplaceLoadMore());
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 100);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<MarketplaceBloc>().add(MarketplaceFetched());
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.dg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HomeTopBar(),
                        SizedBox(height: 24.h),
                        BlocBuilder<HomeTabCubit, HomeTabState>(
                          buildWhen: (prev, next) => prev.isSynced != next.isSynced,
                          builder: (context, tabState) {
                            return HomeTotalValueSection(
                              isSynced: tabState.isSynced,
                              onSyncTap: () => context
                                  .read<HomeTabCubit>()
                                  .setSynced(value: true),
                            );
                          },
                        ),
                        SizedBox(height: 14.h),
                        HomeQuickActionsSection(
                          actions: [
                            HomeQuickActionItemData(
                              icon: Assets.iconsHomeActionBtn.icActionSend.load(
                                width: 22.w,
                                height: 22.h,
                                color: OlaColors.actionBtnColor,
                              ),
                              label: 'Send',
                            ),
                            HomeQuickActionItemData(
                              icon: Assets.iconsHomeActionBtn.icActionReceive.load(
                                width: 22.w,
                                height: 22.h,
                                color: OlaColors.actionBtnColor,
                              ),
                              label: 'Receive',
                            ),
                            HomeQuickActionItemData(
                              icon: Assets.iconsHomeActionBtn.icTsxBuy.load(
                                width: 22.w,
                                height: 22.h,
                                color: OlaColors.actionBtnColor,
                              ),
                              label: 'Buy',
                            ),
                            HomeQuickActionItemData(
                              icon: Assets.iconsHomeActionBtn.icActionSell.load(
                                width: 32.w,
                                height: 32.h,
                                color: OlaColors.actionBtnColor,
                              ),
                              label: 'Sell',
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        BlocBuilder<HomeTabCubit, HomeTabState>(
                          buildWhen: (prev, next) =>
                              prev.currentPaymentPage != next.currentPaymentPage,
                          builder: (context, tabState) {
                            return HomePaymentSection(
                              cards: _paymentCards,
                              pageController: _paymentPageController,
                              currentPage: tabState.currentPaymentPage,
                              onPageChanged: (index) => context
                                  .read<HomeTabCubit>()
                                  .setCurrentPaymentPage(index),
                              onScanTap: () {},
                            );
                          },
                        ),
                        SizedBox(height: 24.h),
                        const HomeCryptoActivesHeader(),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
                const CoinMarketSliver(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
