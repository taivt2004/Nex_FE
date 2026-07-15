import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nexpaylab/app/data/model/coin/chart_data.dart';
import 'package:nexpaylab/app/data/model/coin/coin_detail.dart';
import 'package:nexpaylab/app/di/dependency_injection.dart';
import 'package:nexpaylab/features/coin_detail/presentation/bloc/coin_detail_bloc.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

class CoinDetailPage extends StatelessWidget {
  const CoinDetailPage({required this.coinId, super.key});

  final String coinId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<CoinDetailBloc>()..add(FetchCoinDetail(coinId: coinId)),
      child: const CoinDetailView(),
    );
  }
}

class CoinDetailView extends StatelessWidget {
  const CoinDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090B10),
      body: SafeArea(
        child: BlocBuilder<CoinDetailBloc, CoinDetailState>(
          builder: (context, state) {
            if (state.detailStatus == CoinDetailStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.detailStatus == CoinDetailStatus.failure) {
              return _CoinDetailErrorView(
                message: state.detailErrorMessage,
                onRetry: () {
                  if (state.coinId == null) return;
                  context.read<CoinDetailBloc>().add(
                        FetchCoinDetail(coinId: state.coinId!),
                      );
                },
              );
            }

            final detail = state.coinDetail;
            if (detail == null) {
              return const SizedBox.shrink();
            }

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _CoinDetailTopBar(detail: detail),
                        SizedBox(height: 20.h),
                        _CoinHeroCard(detail: detail),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                    child: _ChartSection(state: state),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _SectionCard(
                          title: 'Tổng quan',
                          child: _OverviewGrid(detail: detail),
                        ),
                        SizedBox(height: 16.h),
                        _SectionCard(
                          title: 'Nguồn cung',
                          child: _SupplySection(detail: detail),
                        ),
                        SizedBox(height: 16.h),
                        _SectionCard(
                          title: 'Liên kết',
                          child: _LinkSection(detail: detail),
                        ),
                        SizedBox(height: 16.h),
                        _SectionCard(
                          title: 'Giới thiệu',
                          child: Text(
                            _displayOrDash(detail.metadata.description),
                            style: PoppinsTextStyles.primary14Regular.copyWith(
                              color: OlaColors.gray300,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CoinDetailTopBar extends StatelessWidget {
  const _CoinDetailTopBar({required this.detail});

  final CoinDetail detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: context.pop,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Row(
            children: [
              _CoinAvatar(
                imageUrl: detail.metadata.imgUrl,
                symbol: detail.metadata.symbol,
                size: 38.w,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  detail.metadata.symbol,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: PoppinsTextStyles.primary18Semibold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        _CircleButton(icon: Icons.notifications_none_rounded, onTap: () {}),
        SizedBox(width: 10.w),
        _CircleButton(icon: Icons.share_outlined, onTap: () {}),
      ],
    );
  }
}

class _CoinHeroCard extends StatelessWidget {
  const _CoinHeroCard({required this.detail});

  final CoinDetail detail;

  @override
  Widget build(BuildContext context) {
    final isPositive = detail.changes.h24 >= 0;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: const Color(0xFF10131A),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFF272C36)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.metadata.name,
                      style: OlaTextStyles.title20bold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      detail.metadata.symbol,
                      style: PoppinsTextStyles.primary14Regular.copyWith(
                        color: OlaColors.gray400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF171A21),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text(
                  '#${detail.statistics.rank}',
                  style: PoppinsTextStyles.primary14Semibold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  '${_formatPrice(detail.statistics.price)} US\$',
                  style: PoppinsTextStyles.display36Bold.copyWith(
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: (isPositive
                          ? OlaColors.greenColor
                          : OlaColors.redColor)
                      .withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  '${isPositive ? '▲' : '▼'} ${_formatPercent(detail.changes.h24)}%',
                  style: PoppinsTextStyles.primary14Semibold.copyWith(
                    color: isPositive
                        ? OlaColors.greenColor
                        : OlaColors.redColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            'Biến động 24h',
            style: PoppinsTextStyles.primary14Regular.copyWith(
              color: OlaColors.gray400,
            ),
          ),
          SizedBox(height: 18.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: [
              _ChangeChip(
                label: '1H',
                value: detail.changes.h1,
              ),
              _ChangeChip(
                label: '24H',
                value: detail.changes.h24,
              ),
              _ChangeChip(
                label: '7D',
                value: detail.changes.d7,
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: _MiniMetric(
                  label: 'Vốn hoá',
                  value: '${_formatCompactValue(detail.statistics.marketCap)} US\$',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _MiniMetric(
                  label: 'Khối lượng 24h',
                  value: '${_formatCompactValue(detail.statistics.volume24h)} US\$',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  const _ChartSection({required this.state});

  final CoinDetailState state;

  @override
  Widget build(BuildContext context) {
    final chartData = state.chartData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.chartStatus == ChartStatus.loading && chartData == null)
          SizedBox(
            height: 320.h,
            child: const Center(child: CircularProgressIndicator()),
          )
        else if (state.chartStatus == ChartStatus.failure && chartData == null)
          SizedBox(
            height: 320.h,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Text(
                      state.chartErrorMessage,
                      textAlign: TextAlign.center,
                      style: PoppinsTextStyles.primary14Regular.copyWith(
                        color: OlaColors.gray300,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
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
        else if (chartData != null)
          _InteractivePriceChart(
            chartData: chartData,
            range: state.chartRange,
            isRefreshing: state.chartStatus == ChartStatus.loading,
          )
        else
          SizedBox(
            height: 320.h,
            child: Center(
              child: Text(
                'Chưa có dữ liệu chart',
                style: PoppinsTextStyles.primary14Regular.copyWith(
                  color: OlaColors.gray400,
                ),
              ),
            ),
          ),
        SizedBox(height: 14.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final range in ChartRange.values) ...[
                  _ChartRangeChip(
                    label: range.value.toUpperCase(),
                    isSelected: range == state.chartRange,
                    onTap: () {
                      context.read<CoinDetailBloc>().add(
                            ChangeChartRange(range: range),
                          );
                    },
                  ),
                  SizedBox(width: 8.w),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InteractivePriceChart extends StatefulWidget {
  const _InteractivePriceChart({
    required this.chartData,
    required this.range,
    required this.isRefreshing,
  });

  final ChartData chartData;
  final ChartRange range;
  final bool isRefreshing;
  @override
  State<_InteractivePriceChart> createState() => _InteractivePriceChartState();
}

class _InteractivePriceChartState extends State<_InteractivePriceChart> {
  List<ChartPoint> get _sortedPoints {
    final points = List<ChartPoint>.from(widget.chartData.points)
      ..sort((a, b) => a.time.compareTo(b.time));
    return points;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _InteractivePriceChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldPoints = oldWidget.chartData.points;
    final newPoints = widget.chartData.points;
    if (newPoints.isEmpty) return;

    final rangeChanged = oldWidget.range != widget.range;
    final coinChanged = oldWidget.chartData.coinId != widget.chartData.coinId;
    if (rangeChanged || coinChanged || oldPoints.isEmpty) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final points = _sortedPoints;
    if (points.isEmpty) {
      return SizedBox(
        height: 320.h,
        child: Center(
          child: Text(
            'Chưa có dữ liệu chart',
            style: PoppinsTextStyles.primary14Regular.copyWith(
              color: OlaColors.gray400,
            ),
          ),
        ),
      );
    }

    final startTime = points.first.time.toDouble();
    final endTime = points.last.time.toDouble();
    final minPrice = points.map((point) => point.value).reduce(math.min);
    final maxPrice = points.map((point) => point.value).reduce(math.max);
    final pricePadding =
        math.max((maxPrice - minPrice) * 0.12, maxPrice.abs() * 0.002);
    final baseline = widget.chartData.baseLine;
    final rawMinY = math.min(minPrice - pricePadding, baseline);
    final rawMaxY = math.max(maxPrice + pricePadding, baseline);

    ({double min, double max, double interval}) niceAxis({
      required double min,
      required double max,
      int tickCount = 4,
    }) {
      var tMin = min;
      var tMax = max;
      var ticks = tickCount;
      if (!tMin.isFinite || !tMax.isFinite) {
        return (min: 0, max: 1, interval: 1.0);
      }
      if (ticks < 2) ticks = 2;
      if (tMin > tMax) {
        final temp = tMin;
        tMin = tMax;
        tMax = temp;
      }
      if (tMin == tMax) {
        final pad = tMin == 0 ? 1.0 : tMin.abs() * 0.1;
        tMin -= pad;
        tMax += pad;
      }
      final range = (tMax - tMin).abs();
      if (range == 0 || !range.isFinite) {
        return (min: tMin, max: tMax, interval: 1.0);
      }

      final rawInterval = range / (ticks - 1);
      final magnitude =
          math.pow(10, (math.log(rawInterval) / math.ln10).floor()).toDouble();
      final residual = rawInterval / magnitude;
      final niceResidual = residual <= 1
          ? 1
          : residual <= 2
              ? 2
              : residual <= 5
                  ? 5
                  : 10;
      final interval = niceResidual * magnitude;
      var niceMin = (tMin / interval).floorToDouble() * interval;
      final niceMax = (tMax / interval).ceilToDouble() * interval;
      if (minPrice >= 0 && baseline >= 0) {
        niceMin = math.max(0, niceMin);
      }
      return (min: niceMin, max: niceMax, interval: interval);
    }

    final yAxis = niceAxis(
      min: rawMinY,
      max: rawMaxY,
      tickCount: 4,
    );
    final minY = yAxis.min;
    final maxY = yAxis.max <= yAxis.min
        ? yAxis.min + math.max(maxPrice.abs() * 0.1, 1)
        : yAxis.max;
    const greenLineColors = [Color(0xFF31E7B8), Color(0xFF19D6A5)];
    const redLineColors = [Color(0xFFFF708E), Color(0xFFFF4E78)];
    const greenFillColors = [Color(0x5531E7B8), Color(0x0531E7B8)];
    const redFillColors = [Color(0x55FF5A7C), Color(0x05FF5A7C)];
    final yInterval = yAxis.interval > 0 ? yAxis.interval : 1.0;
    final xAxisMarks = _buildTimestampMarks(
      startTime.toInt(),
      endTime.toInt(),
      labelCount: 6,
    );
    ({List<FlSpot> green, List<FlSpot> red}) splitSpots() {
      final green = <FlSpot>[];
      final red = <FlSpot>[];

      void addUnique(List<FlSpot> list, FlSpot spot) {
        if (list.isEmpty) {
          list.add(spot);
          return;
        }
        final last = list.last;
        if (last.x == spot.x && last.y == spot.y) return;
        list.add(spot);
      }

      for (var i = 0; i < points.length - 1; i++) {
        final x1 = points[i].time.toDouble();
        final y1 = points[i].value;
        final x2 = points[i + 1].time.toDouble();
        final y2 = points[i + 1].value;

        final aAbove = y1 >= baseline;
        final bAbove = y2 >= baseline;

        if (i == 0) {
          addUnique(aAbove ? green : red, FlSpot(x1, y1));
        }

        if (aAbove == bAbove) {
          addUnique(aAbove ? green : red, FlSpot(x2, y2));
          continue;
        }

        final dy = y2 - y1;
        final t = dy == 0 ? 0.0 : (baseline - y1) / dy;
        final crossX = x1 + (x2 - x1) * t.clamp(0.0, 1.0);
        final cross = FlSpot(crossX, baseline);

        addUnique(green, cross);
        addUnique(red, cross);
        addUnique(bAbove ? green : red, FlSpot(x2, y2));
      }

      return (green: green, red: red);
    }

    final colored = splitSpots();

    final fillBar = LineChartBarData(
      spots: [
        for (final point in points) FlSpot(point.time.toDouble(), point.value),
      ],
      isCurved: points.length > 2,
      preventCurveOverShooting: true,
      isStrokeCapRound: true,
      barWidth: 0,
      color: Colors.transparent,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        applyCutOffY: true,
        cutOffY: baseline,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: redFillColors,
        ),
      ),
      aboveBarData: BarAreaData(
        show: true,
        applyCutOffY: true,
        cutOffY: baseline,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: greenFillColors,
        ),
      ),
    );

    final greenBar = LineChartBarData(
      spots: colored.green,
      isCurved: colored.green.length > 2,
      preventCurveOverShooting: true,
      isStrokeCapRound: true,
      barWidth: 3.2,
      gradient: const LinearGradient(colors: greenLineColors),
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      aboveBarData: BarAreaData(show: false),
    );

    final redBar = LineChartBarData(
      spots: colored.red,
      isCurved: colored.red.length > 2,
      preventCurveOverShooting: true,
      isStrokeCapRound: true,
      barWidth: 3.2,
      gradient: const LinearGradient(colors: redLineColors),
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      aboveBarData: BarAreaData(show: false),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        const yLabelCount = 4;
        final yLabels = List<String>.generate(yLabelCount, (index) {
          final value = maxY - ((maxY - minY) * index / (yLabelCount - 1));
          return _formatAxisPrice(value);
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 320.h,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.w),
                          child: LineChart(
                            duration: Duration.zero,
                            LineChartData(
                              minX: startTime,
                              maxX: endTime,
                              minY: minY,
                              maxY: maxY,
                              backgroundColor: Colors.transparent,
                              clipData: const FlClipData.all(),
                              borderData: FlBorderData(show: false),
                              extraLinesData: ExtraLinesData(
                                horizontalLines: [
                                  HorizontalLine(
                                    y: baseline,
                                    color: const Color(0xFF6F7682),
                                    strokeWidth: 1,
                                    dashArray: const [6, 6],
                                  ),
                                ],
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: yInterval,
                                getDrawingHorizontalLine: (_) => const FlLine(
                                  color: Color(0xFF1C212A),
                                  strokeWidth: 1,
                                  dashArray: [4, 4],
                                ),
                              ),
                              titlesData: const FlTitlesData(
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              lineTouchData: const LineTouchData(enabled: false),
                              lineBarsData: [fillBar, greenBar, redBar],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          bottom: 0,
                          child: IgnorePointer(
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  for (final label in yLabels)
                                    Text(
                                      label,
                                      style: PoppinsTextStyles.primary12Regular
                                          .copyWith(
                                        color: OlaColors.gray400,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (final mark in xAxisMarks)
                          Text(
                            _formatChartTimeLabel(mark, widget.range),
                            style: PoppinsTextStyles.primary12Regular.copyWith(
                              color: OlaColors.gray400,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isRefreshing) ...[
              SizedBox(height: 8.h),
              const LinearProgressIndicator(minHeight: 2),
            ],
          ],
        );
      },
    );
  }
}

class _ChartRangeChip extends StatelessWidget {
  const _ChartRangeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? OlaColors.primarycolor : const Color(0xFF151922),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Text(
          label,
          style: PoppinsTextStyles.primary14Semibold.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

List<int> _buildTimestampMarks(int start, int end, {required int labelCount}) {
  if (labelCount <= 1) {
    return [start];
  }

  final marks = <int>[];
  final span = end - start;
  for (var i = 0; i < labelCount; i++) {
    final ratio = i / (labelCount - 1);
    marks.add(start + (span * ratio).round());
  }
  return marks;
}

String _formatAxisPrice(double value) {
  return NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '',
    decimalDigits: value >= 1000 ? 0 : 2,
  ).format(value).trim();
}

String _formatChartTimeLabel(int timestamp, ChartRange range) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  switch (range) {
    case ChartRange.h1:
    case ChartRange.h24:
      return DateFormat('HH:mm').format(date);
    case ChartRange.d7:
    case ChartRange.d30:
      return DateFormat('dd/MM').format(date);
    case ChartRange.y1:
      return DateFormat('MM/yy').format(date);
    case ChartRange.all:
      return DateFormat('yyyy').format(date);
  }
}

class _OverviewGrid extends StatelessWidget {
  const _OverviewGrid({required this.detail});

  final CoinDetail detail;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Giá hiện tại', '${_formatPrice(detail.statistics.price)} US\$'),
      ('Xếp hạng', '#${detail.statistics.rank}'),
      ('FDV', '${_formatCompactValue(detail.statistics.fdv)} US\$'),
      (
        'Dominance',
        '${detail.statistics.dominance.toStringAsFixed(2)}%',
      ),
      (
        'ATH',
        '${_formatPrice(detail.statistics.ath.price)} US\$',
      ),
      (
        'ATL',
        '${_formatPrice(detail.statistics.atl.price)} US\$',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1.7,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: const Color(0xFF12161D),
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.$1,
                style: PoppinsTextStyles.primary12Regular.copyWith(
                  color: OlaColors.gray400,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                item.$2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: PoppinsTextStyles.primary14Semibold.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SupplySection extends StatelessWidget {
  const _SupplySection({required this.detail});

  final CoinDetail detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoRow(
          label: 'Circulating supply',
          value: _formatSupply(detail.statistics.circulatingSupply),
        ),
        const _InfoDivider(),
        _InfoRow(
          label: 'Total supply',
          value: _formatSupply(detail.statistics.totalSupply),
        ),
        const _InfoDivider(),
        _InfoRow(
          label: 'Max supply',
          value: _formatSupply(detail.statistics.maxSupply),
        ),
        const _InfoDivider(),
        _InfoRow(
          label: 'ATH date',
          value: detail.statistics.ath.date,
        ),
        const _InfoDivider(),
        _InfoRow(
          label: 'ATL date',
          value: detail.statistics.atl.date,
        ),
      ],
    );
  }
}

class _LinkSection extends StatelessWidget {
  const _LinkSection({required this.detail});

  final CoinDetail detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoRow(
          label: 'Website',
          value: _displayOrDash(detail.metadata.links.website),
        ),
        const _InfoDivider(),
        _InfoRow(
          label: 'Twitter',
          value: _displayOrDash(detail.metadata.links.twitter),
        ),
        const _InfoDivider(),
        _InfoRow(
          label: 'Reddit',
          value: _displayOrDash(detail.metadata.links.reddit),
        ),
        const _InfoDivider(),
        _InfoRow(
          label: 'Contract',
          value: _displayOrDash(detail.metadata.contract),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: const Color(0xFF10131A),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFF272C36)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: PoppinsTextStyles.primary18Semibold.copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

class _CoinDetailErrorView extends StatelessWidget {
  const _CoinDetailErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: PoppinsTextStyles.primary14Regular.copyWith(
                color: OlaColors.gray300,
              ),
            ),
            SizedBox(height: 14.h),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22.r),
      child: Container(
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          color: const Color(0xFF141821),
          borderRadius: BorderRadius.circular(21.r),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20.sp,
        ),
      ),
    );
  }
}

class _CoinAvatar extends StatelessWidget {
  const _CoinAvatar({
    required this.imageUrl,
    required this.symbol,
    required this.size,
  });

  final String imageUrl;
  final String symbol;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      errorWidget: (context, url, error) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xFF7B61FF),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          symbol.isEmpty ? '?' : symbol[0].toUpperCase(),
          style: PoppinsTextStyles.primary14Semibold.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      imageBuilder: (context, imageProvider) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _ChangeChip extends StatelessWidget {
  const _ChangeChip({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF151922),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: PoppinsTextStyles.primary12Regular.copyWith(
              color: OlaColors.gray400,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '${isPositive ? '+' : '-'}${_formatPercent(value)}%',
            style: PoppinsTextStyles.primary12Semibold.copyWith(
              color: isPositive ? OlaColors.greenColor : OlaColors.redColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF151922),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: PoppinsTextStyles.primary12Regular.copyWith(
              color: OlaColors.gray400,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: PoppinsTextStyles.primary14Semibold.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: PoppinsTextStyles.primary14Regular.copyWith(
              color: OlaColors.gray400,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: PoppinsTextStyles.primary14Semibold.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: const Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFF1A1F29),
      ),
    );
  }
}

String _formatPrice(double value) {
  final formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '',
    decimalDigits: _priceDecimals(value),
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

String _formatCompactValue(double value) {
  if (value >= 1000000000000) {
    return '${_formatShort(value / 1000000000000)}T';
  }
  if (value >= 1000000000) {
    return '${_formatShort(value / 1000000000)}B';
  }
  if (value >= 1000000) {
    return '${_formatShort(value / 1000000)}M';
  }
  return _formatShort(value);
}

String _formatSupply(double value) {
  if (value <= 0) return 'N/A';
  return NumberFormat.compact(locale: 'en_US').format(value);
}

String _formatShort(double value) {
  final formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '',
    decimalDigits: value >= 100 ? 0 : 2,
  );
  return formatter.format(value).trim();
}

String _displayOrDash(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'N/A';
  }
  return value.trim();
}

int _priceDecimals(double value) {
  if (value >= 1) return 2;
  return 6;
}
