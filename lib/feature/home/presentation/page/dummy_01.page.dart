import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexpaylab/feature/home/presentation/bloc/marketplace_bloc/marketplace_bloc.dart';

class DummyPage01 extends StatefulWidget {
  const DummyPage01({super.key});

  @override
  State<DummyPage01> createState() => _DummyPage01State();
}

class _DummyPage01State extends State<DummyPage01>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
    super.build(context); // KeepAlive requirement

    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      body: BlocBuilder<MarketplaceBloc, MarketplaceState>(
        builder: (context, state) {
          // Loading lần đầu
          if (state.status == MarketplaceStatus.loading &&
              state.coins.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Lỗi lần đầu
          if (state.status == MarketplaceStatus.failure &&
              state.coins.isEmpty) {
            return Center(
              child: ElevatedButton(
                onPressed: () =>
                    context.read<MarketplaceBloc>().add(MarketplaceFetched()),
                child: const Text('Thử lại'),
              ),
            );
          }

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<MarketplaceBloc>().add(MarketplaceFetched());
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Top Bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF262A34),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.grid_view_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const Row(
                                children: [
                                  Text(
                                    'Main Wallet',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF262A34),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF262A34),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Balance
                          const Text(
                            '1.500.000',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'USD',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                                size: 16,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Today',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.trending_up,
                                color: Color(0xFF00C566),
                                size: 14,
                              ),
                              SizedBox(width: 2),
                              Text(
                                r'350$ (2.70%)',
                                style: TextStyle(
                                  color: Color(0xFF00C566),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildActionButton(
                                icon: Icons.send_rounded,
                                label: 'Send',
                              ),
                              _buildActionButton(
                                icon: Icons.call_received_rounded,
                                label: 'Receive',
                              ),
                              _buildActionButton(
                                icon: Icons.credit_card_rounded,
                                label: 'Buy',
                              ),
                              _buildActionButton(
                                icon: Icons.attach_money_rounded,
                                label: 'Sell',
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Crypto actives header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Crypto actives',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF262A34),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.tune_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF262A34),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.history_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  // Coin List
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index >= state.coins.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }

                      final coin = state.coins[index];
                      final isPositive = coin.change24h >= 0;

                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 12,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF262A34),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              // Icon
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _getCoinColor(coin.base),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    _getCoinSymbol(coin.base),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Name & Symbol
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      coin.base,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      coin.symbol,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Percentage Change
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: isPositive
                                          ? const Color(
                                              0xFF00C566,
                                            ).withOpacity(0.1)
                                          : const Color(
                                              0xFFFF3D00,
                                            ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${isPositive ? '+' : ''}${coin.change24h}%',
                                      style: TextStyle(
                                        color: isPositive
                                            ? const Color(0xFF00C566)
                                            : const Color(0xFFFF3D00),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Price & Volume
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$${coin.price < 1 ? coin.price.toStringAsFixed(6) : coin.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Vol: ${coin.volume24h?.toStringAsFixed(2) ?? "0.00"}',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: state.coins.length + (state.loadingMore ? 1 : 0)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label}) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF262A34),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
      ],
    );
  }

  Color _getCoinColor(String base) {
    switch (base.toUpperCase()) {
      case 'BTC':
        return const Color(0xFFF7931A);
      case 'ETH':
        return const Color(0xFF627EEA);
      case 'TRX':
        return const Color(0xFFFF0013);
      case 'ADA':
        return const Color(0xFF0033AD);
      case 'SOL':
        return const Color(0xFF9945FF);
      default:
        return const Color(0xFF7B61FF);
    }
  }

  String _getCoinSymbol(String base) {
    final symbols = {'BTC': '₿', 'ETH': 'Ξ', 'ADA': '₳', 'SOL': '◎'};
    return symbols[base.toUpperCase()] ?? base[0].toUpperCase();
  }

  String _formatPrice(double price) {
    if (price < 1) {
      return price.toStringAsFixed(8);
    } else if (price < 100) {
      return price.toStringAsFixed(4);
    } else {
      return price.toStringAsFixed(2);
    }
  }

  String _formatBalance(double balance) {
    if (balance >= 1000) {
      return '${(balance / 1000).toStringAsFixed(2)}K';
    }
    return balance.toStringAsFixed(2);
  }
}
