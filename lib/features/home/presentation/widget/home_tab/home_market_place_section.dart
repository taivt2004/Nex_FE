
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/features/home/presentation/bloc/marketplace_bloc/marketplace_bloc.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

class HomeMarketPlaceSection extends StatelessWidget {
  const HomeMarketPlaceSection({super.key});

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
                    context.read<MarketplaceBloc>().add(const FetchMarketplace()),
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
            return InkWell(
              onTap: () {
                context.push(
                  AppRouter.coinDetail,
                  extra: coin.id,
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFF1A1D24)),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20.w,
                        child: Text(
                          '${coin.rank}',
                          style: PoppinsTextStyles.primary12Regular.copyWith(
                            color: OlaColors.gray400,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: coin.imgUrl,
                              width: 30.w,
                              height: 30.w,
                              errorWidget: (context, url, error) => Container(
                                width: 30.w,
                                height: 30.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF7B61FF),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    coin.symbol[0].toUpperCase(),
                                    style: PoppinsTextStyles.primary14Semibold,
                                  ),
                                ),
                              ),
                              imageBuilder: (context, imageProvider) => Container(
                                width: 30.w,
                                height: 30.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                coin.symbol,
                                style: PoppinsTextStyles.primary14Semibold.copyWith(
                                  color: Colors.white,
                                  fontSize: 13.5.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${_formatPrice(coin.price)} US\$',
                              maxLines: 1,
                              softWrap: false,
                              textAlign: TextAlign.right,
                              style: PoppinsTextStyles.primary14Semibold.copyWith(
                                color: Colors.white,
                                fontSize: 12.5.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          '${isPositive ? '▲' : '▼'} ${_formatPercent(coin.change24h)}%',
                          textAlign: TextAlign.right,
                          style: PoppinsTextStyles.primary14Semibold.copyWith(
                            color: isPositive
                                ? OlaColors.greenColor
                                : OlaColors.redColor,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          '${_formatCompactMarketCap(coin.marketCap)} US\$',
                          textAlign: TextAlign.right,
                          style: PoppinsTextStyles.primary14Regular.copyWith(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }, childCount: state.coins.length + (state.loadingMore ? 1 : 0)),
        );
      },
    );
  }
}

String _formatPrice(double price) {
  final formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '',
    decimalDigits: _priceDecimals(price),
  );
  return formatter.format(price).trim();
}

String _formatCompactMarketCap(double marketCap) {
  if (marketCap >= 1000000000000) {
    return '${_formatShortNumber(marketCap / 1000000000000)}T';
  }
  if (marketCap >= 1000000000) {
    return '${_formatShortNumber(marketCap / 1000000000)}B';
  }
  if (marketCap >= 1000000) {
    return '${_formatShortNumber(marketCap / 1000000)}M';
  }
  return _formatShortNumber(marketCap);
}

String _formatShortNumber(double value) {
  final formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '',
    decimalDigits: value >= 100 ? 0 : 2,
  );
  return formatter.format(value).trim();
}

String _formatPercent(double value) {
  final formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '',
    decimalDigits: value.abs() >= 10 ? 1 : 2,
  );
  return formatter.format(value.abs()).trim();
}

int _priceDecimals(double price) {
  if (price >= 100) return 2;
  if (price >= 1) return 2;
  return 6;
}
