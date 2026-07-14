
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nexpaylab/app/data/model/coin/chart_data.dart';
import 'package:nexpaylab/app/data/model/coin/coin_detail.dart';
import 'package:nexpaylab/features/coin_detail/presentation/bloc/coin_detail_bloc.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

class CoinDetailPage extends StatelessWidget {
  const CoinDetailPage({required this.coinId, super.key});

  final String coinId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CoinDetailBloc(context.read())..add(FetchCoinDetail(coinId: coinId)),
      child: const CoinDetailView(),
    );
  }
}

class CoinDetailView extends StatelessWidget {
  const CoinDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<CoinDetailBloc, CoinDetailState>(
          builder: (context, state) {
            if (state.detailStatus == CoinDetailStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.detailStatus == CoinDetailStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.detailErrorMessage),
                    ElevatedButton(
                      onPressed: () {
                        if (state.coinId != null) {
                          context.read<CoinDetailBloc>().add(
                                FetchCoinDetail(coinId: state.coinId!),
                              );
                        }
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final detail = state.coinDetail;
            if (detail == null) {
              return const SizedBox.shrink();
            }

            final isPositive = detail.changes.h24 >= 0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, detail),
                  SizedBox(height: 24.h),
                  _buildPriceSection(detail, isPositive),
                  SizedBox(height: 24.h),
                  _buildChartSection(context, state),
                  SizedBox(height: 24.h),
                  _buildStatsSection(detail),
                  SizedBox(height: 24.h),
                  _buildInfoSection(detail),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CoinDetail detail) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        SizedBox(width: 12.w),
        CachedNetworkImage(
          imageUrl: detail.metadata.imgUrl,
          width: 40.w,
          height: 40.w,
          errorWidget: (context, url, error) => Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xFF7B61FF),
              shape: BoxShape.circle,
            ),
          ),
          imageBuilder: (context, imageProvider) => Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detail.metadata.name,
              style: PoppinsTextStyles.primary18Semibold,
            ),
            Text(
              detail.metadata.symbol,
              style: PoppinsTextStyles.primary14Regular.copyWith(
                color: OlaColors.gray400,
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          '#${detail.statistics.rank}',
          style: PoppinsTextStyles.primary16Semibold,
        ),
      ],
    );
  }

  Widget _buildPriceSection(CoinDetail detail, bool isPositive) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF2C2F38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  NumberFormat.currency(symbol: r'$', decimalDigits: 2)
                      .format(detail.statistics.price),
                  style: PoppinsTextStyles.display36Bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isPositive ? OlaColors.greenColor : OlaColors.redColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${isPositive ? '+' : ''}${detail.changes.h24.toStringAsFixed(2)}%',
                  style: PoppinsTextStyles.primary16Semibold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '24h Change',
            style: PoppinsTextStyles.primary14Regular.copyWith(
              color: OlaColors.gray400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(BuildContext context, CoinDetailState state) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF2C2F38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildRangeButton(
                context,
                ChartRange.h1,
                state.chartRange,
              ),
              SizedBox(width: 8.w),
              _buildRangeButton(
                context,
                ChartRange.h24,
                state.chartRange,
              ),
              SizedBox(width: 8.w),
              _buildRangeButton(
                context,
                ChartRange.d7,
                state.chartRange,
              ),
              SizedBox(width: 8.w),
              _buildRangeButton(
                context,
                ChartRange.d30,
                state.chartRange,
              ),
              SizedBox(width: 8.w),
              _buildRangeButton(
                context,
                ChartRange.y1,
                state.chartRange,
              ),
              SizedBox(width: 8.w),
              _buildRangeButton(
                context,
                ChartRange.all,
                state.chartRange,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          if (state.chartStatus == ChartStatus.loading)
            SizedBox(
              height: 250.h,
              child: const Center(child: CircularProgressIndicator()),
            )
          else if (state.chartStatus == ChartStatus.failure)
            SizedBox(
              height: 250.h,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.chartErrorMessage),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CoinDetailBloc>().add(const FetchChartData());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (state.chartData != null)
            _buildChart(state.chartData!)
          else
            SizedBox(height: 250.h),
        ],
      ),
    );
  }

  Widget _buildRangeButton(
    BuildContext context,
    ChartRange range,
    ChartRange selectedRange,
  ) {
    final isSelected = range == selectedRange;
    return InkWell(
      onTap: () {
        context.read<CoinDetailBloc>().add(ChangeChartRange(range: range));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? OlaColors.primarycolor : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFF2C2F38),
          ),
        ),
        child: Text(
          range.value,
          style: PoppinsTextStyles.primary14Semibold.copyWith(
            color: isSelected ? Colors.white : OlaColors.gray400,
          ),
        ),
      ),
    );
  }

  Widget _buildChart(ChartData chartData) {
    if (chartData.points.isEmpty) {
      return SizedBox(height: 250.h);
    }

    final spots = chartData.points
        .map((point) => FlSpot(
              point.time.toDouble(),
              point.value,
            ))
        .toList();

    final isPositive =
        spots.last.y >= (chartData.baseLine ?? spots.first.y);

    return SizedBox(
      height: 250.h,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: isPositive ? OlaColors.greenColor : OlaColors.redColor,
              barWidth: 2.w,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: isPositive
                    ? OlaColors.greenColor.withOpacity(0.2)
                    : OlaColors.redColor.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(CoinDetail detail) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF2C2F38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: PoppinsTextStyles.primary18Semibold,
          ),
          SizedBox(height: 16.h),
          _buildStatItem(
            'Market Cap',
            NumberFormat.compactCurrency(symbol: r'$')
                .format(detail.statistics.marketCap),
          ),
          SizedBox(height: 12.h),
          _buildStatItem(
            '24h Volume',
            NumberFormat.compactCurrency(symbol: r'$')
                .format(detail.statistics.volume24h),
          ),
          SizedBox(height: 12.h),
          _buildStatItem(
            'Circulating Supply',
            NumberFormat.compact().format(detail.statistics.circulatingSupply),
          ),
          SizedBox(height: 12.h),
          _buildStatItem(
            'Total Supply',
            NumberFormat.compact().format(detail.statistics.totalSupply),
          ),
          SizedBox(height: 12.h),
          _buildStatItem(
            'Max Supply',
            detail.statistics.maxSupply == null
                ? 'N/A'
                : NumberFormat.compact().format(detail.statistics.maxSupply),
          ),
          SizedBox(height: 12.h),
          _buildStatItem(
            'All Time High',
            NumberFormat.currency(symbol: r'$', decimalDigits: 2)
                .format(detail.statistics.ath.price),
          ),
          SizedBox(height: 12.h),
          _buildStatItem(
            'All Time Low',
            NumberFormat.currency(symbol: r'$', decimalDigits: 2)
                .format(detail.statistics.atl.price),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: PoppinsTextStyles.primary14Regular.copyWith(
              color: OlaColors.gray400,
            ),
          ),
        ),
        Text(
          value,
          style: PoppinsTextStyles.primary14Semibold,
        ),
      ],
    );
  }

  Widget _buildInfoSection(CoinDetail detail) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF2C2F38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: PoppinsTextStyles.primary18Semibold,
          ),
          SizedBox(height: 12.h),
          Text(
            detail.metadata.description,
            style: PoppinsTextStyles.primary14Regular.copyWith(
              color: OlaColors.gray400,
            ),
          ),
        ],
      ),
    );
  }
}
