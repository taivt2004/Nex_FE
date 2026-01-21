import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nexpaylab/features/home/coinmarket/marketplace_bloc/marketplace_bloc.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

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
                    context.read<MarketplaceBloc>().add(FetchMarketplace()),
                child: Text(AppLocalizations.of(context).retry),
              ),
            ),
          );
        }
        
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index >= state.coins.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Center(
                  child: SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: CircularProgressIndicator(strokeWidth: 2.w),
                  ),
                ),
              );
            }
            final coin = state.coins[index];
            final isPositive = coin.change24h >= 0;
            return Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFF2C2F38)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: _getCoinColor(coin.base),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _getCoinSymbol(coin.base),
                          style: PoppinsTextStyles.primary18Regular
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coin.base,
                            style: PoppinsTextStyles.primary14Semibold
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getFullName(coin.base),
                            style: PoppinsTextStyles.primary12Regular
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _formatPlain(coin.price),
                            textAlign: TextAlign.center,
                            style: PoppinsTextStyles.primary14Semibold
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatCurrency(coin.price),
                            textAlign: TextAlign.center,
                            style: PoppinsTextStyles.primary12Regular
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container( 
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? OlaColors.greenColor
                            : OlaColors.redColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '${isPositive ? '+' : ''}${coin.change24h.toStringAsFixed(2)}%',
                        style: PoppinsTextStyles.primary12Regular
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

String _formatPlain(double price) {
  if (price < 1) {
    return price.toStringAsFixed(6);
  } else if (price < 100) {
    return price.toStringAsFixed(5);
  } else {
    return price.toStringAsFixed(2);
  }
}

String _formatCurrency(double price) {
  final f = NumberFormat.currency(symbol: r'$', decimalDigits: price < 1 ? 6 : price < 100 ? 2 : 2);
  return f.format(price);
}

String _getFullName(String base) {
  switch (base.toUpperCase()) {
    case 'BTC':
      return 'Bitcoin';
    case 'ETH':
      return 'Ethereum';
    case 'ADA':
      return 'Cardano';
    case 'SOL':
      return 'Solana';
    case 'BNB':
      return 'BNB';
    case 'XRP':
      return 'XRP';
    default:
      return base;
  }
}
