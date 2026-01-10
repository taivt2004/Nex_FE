import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/feature/home/coinmarket/marketplace_bloc/marketplace_bloc.dart';
import 'package:nexpaylab/feature/home/coinmarket/page/coinmarket.page.dart';
import 'package:nexpaylab/feature/home/presentation/widget/home_crypto_actives_header.dart';
import 'package:nexpaylab/feature/home/presentation/widget/home_payment_section.dart';
import 'package:nexpaylab/feature/home/presentation/widget/home_quick_actions_section.dart';
import 'package:nexpaylab/feature/home/presentation/widget/home_top_bar.dart';
import 'package:nexpaylab/feature/home/presentation/widget/home_total_value_section.dart';
import 'package:nexpaylab/gen/assets.gen.dart';
import 'package:nexpaylab/share/theme/app_style.dart';
import 'package:nexpaylab/share/theme/theme.mode.dart';
import 'package:nexpaylab/share/ui/extensions/image.dart';
import 'package:provider/provider.dart';

class DummyPage01 extends StatefulWidget {
  const DummyPage01({super.key});

  @override
  State<DummyPage01> createState() => _DummyPage01State();
}

class _DummyPage01State extends State<DummyPage01>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  late final PageController _paymentPageController;
  int _currentPaymentPage = 0;
  bool _isSynced = false;
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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<MarketplaceBloc, MarketplaceState>(
        builder: (context, state) {
          return SafeArea(
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
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeTopBar(
                            onNotificationTap: () => Provider.of<ThemeModel>(
                              context,
                              listen: false,
                            ).toggleTheme(),
                          ),
                          const SizedBox(height: 24),
                          HomeTotalValueSection(
                            isSynced: _isSynced,
                            onSyncTap: () {
                              setState(() {
                                _isSynced = true;
                              });
                            },
                          ),
                          const SizedBox(height: 14),
                          HomeQuickActionsSection(
                            actions: [
                              HomeQuickActionItemData(
                                icon: Assets.icons.home.icActionSend.load(
                                  width: 22.w,
                                  height: 22.h,
                                  color: OlaColors.actionBtnColor,
                                ),
                                label: 'Send',
                              ),
                              HomeQuickActionItemData(
                                icon: Assets.icons.home.icActionReceive.load(
                                  width: 22,
                                  height: 22,
                                  color: OlaColors.actionBtnColor,
                                ),
                                label: 'Receive',
                              ),
                              HomeQuickActionItemData(
                                icon: Assets.icons.home.icTsxBuy.load(
                                  width: 22,
                                  height: 22,
                                  color: OlaColors.actionBtnColor,
                                ),
                                label: 'Buy',
                              ),
                              HomeQuickActionItemData(
                                icon: Assets.icons.home.icActionSell.load(
                                  width: 32.w,
                                  height: 32.h,
                                  color: OlaColors.actionBtnColor,
                                ),
                                label: 'Sell',
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          HomePaymentSection(
                            cards: _paymentCards,
                            pageController: _paymentPageController,
                            currentPage: _currentPaymentPage,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPaymentPage = index;
                              });
                            },
                            onScanTap: () {},
                          ),
                          const SizedBox(height: 24),
                          const HomeCryptoActivesHeader(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  const CoinMarketSliver(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
