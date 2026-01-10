import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexpaylab/feature/home/coinmarket/marketplace_bloc/marketplace_bloc.dart';

class CoinMarketSliver extends StatelessWidget {
  const CoinMarketSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketplaceBloc, MarketplaceState>(
      builder: (context, state) {
        if (state.status == MarketplaceStatus.loading && state.coins.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state.status == MarketplaceStatus.failure &&
            state.coins.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: ElevatedButton(
                onPressed: () =>
                    context.read<MarketplaceBloc>().add(MarketplaceFetched()),
                child: const Text('Thử lại'),
              ),
            ),
          );
        }
        
        return SliverList(
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
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF262A34),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${_formatPrice(coin.price)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Vol: ${coin.volume24h?.toStringAsFixed(2) ?? "0.00"}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? const Color(0xFF00C566).withOpacity(0.1)
                            : const Color(0xFFFF3D00).withOpacity(0.1),
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
                  ],
                ),
              ),
            );
          }, childCount: state.coins.length + (state.loadingMore ? 1 : 0)),
        );
      },
    );
  }
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
    return price.toStringAsFixed(6);
  } else if (price < 100) {
    return price.toStringAsFixed(4);
  } else {
    return price.toStringAsFixed(2);
  }
}
