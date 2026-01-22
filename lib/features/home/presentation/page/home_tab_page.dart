import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/features/home/presentation/bloc/marketplace_bloc/marketplace_bloc.dart';
import 'package:nexpaylab/features/home/presentation/cubit/home_tab_cubit.dart';
import 'package:nexpaylab/features/home/presentation/widget/home_tab/home_crypto_actives_header.dart';
import 'package:nexpaylab/features/home/presentation/widget/home_tab/home_market_place_section.dart';
import 'package:nexpaylab/features/home/presentation/widget/home_tab/home_payment_section.dart';
import 'package:nexpaylab/features/home/presentation/widget/home_tab/home_quick_actions_section.dart';
import 'package:nexpaylab/features/home/presentation/widget/home_tab/home_top_bar.dart';
import 'package:nexpaylab/features/home/presentation/widget/home_tab/home_total_value_section.dart';
import 'package:nexpaylab/features/settings/presentation/page/settings_page.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/ui/extensions/image.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  late final PageController _paymentPageController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _paymentPageController = PageController();
  }


  @override
  void dispose() {
    _scrollController.dispose();
    _paymentPageController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final bloc = context.read<MarketplaceBloc>();

      if (bloc.state.status != MarketplaceStatus.loading &&
          !bloc.state.hasReachedMax) {
        bloc.add(LoadMoreMarketplace());
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 100);
  }

  List<HomePaymentCard> _getPaymentCards(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      HomePaymentCard(
        image:
            'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=200&h=200&fit=crop',
        label: l10n.paymentCoffeeShop,
      ),
      HomePaymentCard(
        image:
            'https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=200&h=200&fit=crop',
        label: l10n.paymentTemplate,
      ),
      HomePaymentCard(
        image:
            'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=200&h=200&fit=crop',
        label: l10n.paymentShopOnline,
      ),
      HomePaymentCard(
        image:
            'https://images.unsplash.com/photo-1556742502-ec7c0e9f34b1?w=200&h=200&fit=crop',
        label: l10n.paymentPayBills,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context);

    return BlocProvider(
      create: (_) => HomeTabCubit(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.dg)
                    .copyWith(top: 16.dg),
                child: HomeTopBar(
                  onMenuTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<MarketplaceBloc>().add(FetchMarketplace());
                  },
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.dg)
                              .copyWith(bottom: 16.dg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 24.h),
                              BlocBuilder<HomeTabCubit, HomeTabState>(
                          buildWhen: (prev, next) => prev.isSynced != next.isSynced,
                          builder: (context, tabState) {
                            return HomeTotalValueSection(
                              isSynced: tabState.isSynced,
                              totalLabel: l10n.totalValue,
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
                              icon: AppAssets.homeActionBtn.icActionSend.load(
                                width: 22.w,
                                height: 22.h,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              label: l10n.actionSend,
                            ),
                            HomeQuickActionItemData(
                              icon: AppAssets.homeActionBtn.icActionReceive.load(
                                width: 22.w,
                                height: 22.h,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              label: l10n.actionReceive,
                            ),
                            HomeQuickActionItemData(
                              icon: AppAssets.homeActionBtn.icActionSwap.load(
                                width: 22.w,
                                height: 22.h,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              label: l10n.actionSwap,
                            ),
                          
                          ],
                        ),
                        SizedBox(height: 24.h),
                        BlocBuilder<HomeTabCubit, HomeTabState>(
                          buildWhen: (prev, next) =>
                              prev.currentPaymentPage != next.currentPaymentPage,
                          builder: (context, tabState) {
                            return HomePaymentSection(
                              cards: _getPaymentCards(context),
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
                const HomeMarketPlaceSection(),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
),
    );
    
  }
}
