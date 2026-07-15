import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nexpaylab/app/di/dependency_injection.dart';
import 'package:nexpaylab/core/theme/app_colors.dart';
import 'package:nexpaylab/features/coin_detail/domain/entity/coin_chart.dart';
import 'package:nexpaylab/features/coin_detail/domain/entity/coin_detail.dart';
import 'package:nexpaylab/features/coin_detail/presentation/cubit/coin_chart_cubit.dart';
import 'package:nexpaylab/features/coin_detail/presentation/cubit/coin_chart_state.dart';
import 'package:nexpaylab/features/coin_detail/presentation/cubit/coin_detail_cubit.dart';
import 'package:nexpaylab/features/coin_detail/presentation/cubit/coin_detail_state.dart';
import 'package:nexpaylab/l10n/l10n.dart';

class CoinDetailPage extends StatelessWidget {
  const CoinDetailPage({required this.coinId, super.key});

  final String coinId;

  static final NumberFormat _priceFormat =
      NumberFormat.currency(locale: 'vi_VN', symbol: r'$ ', decimalDigits: 2);
  static final NumberFormat _compactUsd =
      NumberFormat.compactCurrency(locale: 'vi_VN', symbol: r'$ ');

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CoinDetailCubit>()..load(id: coinId)),
        BlocProvider(create: (_) => getIt<CoinChartCubit>()..load(id: coinId)),
      ],
      child: const _CoinDetailView(),
    );
  }
}

class _CoinDetailView extends StatelessWidget {
  const _CoinDetailView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>();
    final positiveColor = ext?.positive ?? scheme.tertiary;
    final negativeColor = ext?.negative ?? scheme.error;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.coinDetailTitle),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: BlocBuilder<CoinDetailCubit, CoinDetailState>(
            builder: (context, state) {
              if (state.status == CoinDetailStatus.loading ||
                  state.status == CoinDetailStatus.initial) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              if (state.status == CoinDetailStatus.failure) {
                return Center(
                  child: Text(state.errorMessage ?? 'Unknown error'),
                );
              }

              final coin = state.data!;
              final isPositive = coin.change24hPct >= 0;
              final changeColor = isPositive ? positiveColor : negativeColor;

              return ListView(
                children: [
                  _CoinHeader(
                    coinName: coin.name,
                    symbol: coin.symbol,
                    rank: coin.rank,
                    imageUrl: coin.imageUrl,
                    priceUsd: coin.priceUsd,
                    changePct: coin.change24hPct,
                    changeColor: changeColor,
                    positive: isPositive,
                  ),
                  SizedBox(height: 16.h),
                  _ChartCard(coinId: coin.id),
                  SizedBox(height: 16.h),
                  _CoinStats(coin: coin),
                  SizedBox(height: 24.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.imageUrl, required this.symbol});

  final String imageUrl;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = 44.r;

    final background = BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        colors: [
          scheme.primary.withValues(alpha: 0.9),
          scheme.primaryContainer.withValues(alpha: 0.25),
        ],
      ),
    );

    if (imageUrl.trim().isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: background,
        child: Center(
          child: Text(
            symbol.characters.take(1).toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: background,
      padding: EdgeInsets.all(2.r),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) {
            return Container(
              decoration: BoxDecoration(color: scheme.surfaceContainerHighest),
              child: Center(
                child: Text(
                  symbol.characters.take(1).toString(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CoinHeader extends StatelessWidget {
  const _CoinHeader({
    required this.coinName,
    required this.symbol,
    required this.rank,
    required this.imageUrl,
    required this.priceUsd,
    required this.changePct,
    required this.changeColor,
    required this.positive,
  });

  final String coinName;
  final String symbol;
  final int rank;
  final String imageUrl;
  final double priceUsd;
  final double changePct;
  final Color changeColor;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Avatar(imageUrl: imageUrl, symbol: symbol),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coinName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${symbol.toUpperCase()} • #$rank',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                CoinDetailPage._priceFormat.format(priceUsd),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    positive
                        ? Icons.arrow_drop_up_rounded
                        : Icons.arrow_drop_down_rounded,
                    size: 20.r,
                    color: changeColor,
                  ),
                  Text(
                    '${positive ? '+' : ''}${changePct.toStringAsFixed(2)}%',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: changeColor,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          l10n.coinDetailPriceBtcPlaceholder,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _CoinStats extends StatelessWidget {
  const _CoinStats({required this.coin});

  final CoinDetail coin;

  static final NumberFormat _compactUsd =
      NumberFormat.compactCurrency(symbol: r'$ ');
  static final NumberFormat _compactNumber = NumberFormat.compact();

  String _formatUsd(double? v) {
    if (v == null || !v.isFinite) return '—';
    return _compactUsd.format(v);
  }

  String _formatNumber(double? v) {
    if (v == null || !v.isFinite) return '—';
    return _compactNumber.format(v);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>();
    final borderColor = (ext?.border ?? scheme.outline).withValues(alpha: 0.6);

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            label: context.l10n.coinDetailMarketCap,
            value: _formatUsd(coin.marketCapUsd),
          ),
          SizedBox(height: 10.h),
          _InfoRow(
            label: 'Volume 24H',
            value: _formatUsd(coin.volume24hUsd),
          ),
          SizedBox(height: 10.h),
          _InfoRow(
            label: 'Circulating Supply',
            value: _formatNumber(coin.circulatingSupply),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}

enum _ChartMetric { price, marketCap }

enum _ChartRender { line, candle }

class _ChartCard extends StatefulWidget {
  const _ChartCard({required this.coinId});

  final String coinId;

  @override
  State<_ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<_ChartCard> {
  _ChartMetric _metric = _ChartMetric.price;
  _ChartRender _render = _ChartRender.line;

  @override
  Widget build(BuildContext context) {
    
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>();
    final positiveColor = ext?.positive ?? scheme.tertiary;
    final negativeColor = ext?.negative ?? scheme.error;
    final axisCompactUsd =
        NumberFormat.compactCurrency(symbol: r'$ ', decimalDigits: 0);

    ({double min, double max, double interval}) niceAxis({
      required double min,
      required double max,
      int tickCount = 5,
    }) {
      var tMin = min;
      var tMax = max;
      var ticks = tickCount;
      if (!tMin.isFinite || !tMax.isFinite) {
        return (min: 0, max: 1, interval: 1.0);
      }
      if (ticks < 2) ticks = 2;
      if (tMin > tMax) {
        final t = tMin;
        tMin = tMax;
        tMax = t;
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
      final niceMin = (tMin / interval).floorToDouble() * interval;
      final niceMax = (tMax / interval).ceilToDouble() * interval;
      return (min: niceMin, max: niceMax, interval: interval);
    }

    String formatRawPrice(double value) {
      if (!value.isFinite) return '';
      if (_metric == _ChartMetric.marketCap) return axisCompactUsd.format(value);
      const locale = 'vi_VN';
      final abs = value.abs();
      final decimals = abs < 0.01
          ? 9
          : abs < 1
              ? 6
              : 2;
      return NumberFormat.decimalPatternDigits(
        locale: locale,
        decimalDigits: decimals,
      ).format(value);
    }

    String formatAxisYLabel(double value) {
      if (!value.isFinite) return '';
      if (_metric == _ChartMetric.marketCap) return axisCompactUsd.format(value);
      const locale = 'vi_VN';
      final abs = value.abs();

      if (abs < 0.01) {
        return NumberFormat.decimalPatternDigits(
          locale: locale,
          decimalDigits: 9,
        ).format(value);
      }

      if (abs < 1) {
        return NumberFormat.decimalPatternDigits(
          locale: locale,
          decimalDigits: 6,
        ).format(value);
      }

      double step;
      if (abs < 100) {
        step = 0.1;
      } else {
        final magnitude = math.pow(10, (math.log(abs) / math.ln10).floor() - 1);
        step = magnitude.toDouble();
        if (!step.isFinite || step <= 0) step = 1;
      }

      final quantized = (value / step).truncateToDouble() * step;
      final safe = (quantized * 100).roundToDouble() / 100;
      return NumberFormat.decimalPatternDigits(
        locale: locale,
        decimalDigits: 2,
      ).format(safe);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _PillToggle<_ChartMetric>(
              value: _metric,
              options: [
                _PillOption(value: _ChartMetric.price, label: l10n.coinDetailPrice),
                _PillOption(
                  value: _ChartMetric.marketCap,
                  label: l10n.coinDetailMarketCap,
                ),
              ],
              onChanged: (v) => setState(() => _metric = v),
            ),
            SizedBox(width: 10.w),
            _PillIconToggle<_ChartRender>(
              value: _render,
              options: [
                _PillIconOption(
                  value: _ChartRender.line,
                  icon: Icons.show_chart_rounded,
                  semanticLabel: l10n.coinDetailLine,
                ),
                _PillIconOption(
                  value: _ChartRender.candle,
                  icon: Icons.candlestick_chart_rounded,
                  semanticLabel: l10n.coinDetailCandle,
                ),
              ],
              onChanged: (v) => setState(() => _render = v),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        BlocBuilder<CoinChartCubit, CoinChartState>(
          builder: (context, state) {
            final chart = state.chart;
            final points = chart?.points ?? const [];
            if (points.isEmpty) return const SizedBox.shrink();

            final values = points
                .map((p) => p.value)
                .where((v) => v.isFinite)
                .toList(growable: false);
            if (values.isEmpty) return const SizedBox.shrink();

            final viewportStartSec = state.viewportStartSec;
            final viewportEndSec = state.viewportEndSec;
            final startSec = viewportStartSec ??
                (points.first.time.toUtc().millisecondsSinceEpoch ~/ 1000);
            final endSec = viewportEndSec ??
                (points.last.time.toUtc().millisecondsSinceEpoch ~/ 1000);

            final visible = points.where((p) {
              final sec = p.time.toUtc().millisecondsSinceEpoch ~/ 1000;
              return sec >= startSec && sec <= endSec && p.value.isFinite;
            }).toList(growable: false);
            if (visible.isEmpty) return const SizedBox.shrink();

            final baseLine = state.baselineValue ?? visible.first.value;
            final last = visible.last.value;
            final diff = last - baseLine;
            final pct = baseLine == 0 ? 0 : (diff / baseLine) * 100;
            final isUp = diff >= 0;
            final c = isUp ? positiveColor : negativeColor;

            final formatter = _metric == _ChartMetric.marketCap
                ? CoinDetailPage._compactUsd
                : CoinDetailPage._priceFormat;

            return Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.coinDetailBase}: ${formatter.format(baseLine)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${isUp ? '+' : ''}${pct.toStringAsFixed(2)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: c,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 260.h,
          child: BlocBuilder<CoinChartCubit, CoinChartState>(
            builder: (context, state) {
              if (state.status == CoinChartStatus.loading ||
                  state.status == CoinChartStatus.initial) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (state.status == CoinChartStatus.failure) {
                return Center(
                  child: Text(state.errorMessage ?? l10n.coinDetailChartError),
                );
              }

              if (_render == _ChartRender.candle) {
                return Center(child: Text(l10n.coinDetailCandleComingSoon));
              }

              final chart = state.chart;
              final rawPoints = chart?.points ?? const [];
              if (rawPoints.length < 2) {
                return Center(child: Text(l10n.coinDetailNoChartData));
              }

              final viewportStartSec = state.viewportStartSec;
              final viewportEndSec = state.viewportEndSec;
              final startSec = viewportStartSec ??
                  (rawPoints.first.time.toUtc().millisecondsSinceEpoch ~/ 1000);
              final endSec = viewportEndSec ??
                  (rawPoints.last.time.toUtc().millisecondsSinceEpoch ~/ 1000);

              final points = List<CoinChartPoint>.from(rawPoints)
                ..removeWhere((p) => !p.value.isFinite)
                ..sort((a, b) => a.time.compareTo(b.time));
              if (points.length < 2) {
                return Center(child: Text(l10n.coinDetailNoChartData));
              }

              final visiblePoints = points
                  .where((p) {
                    final sec = p.time.toUtc().millisecondsSinceEpoch ~/ 1000;
                    return sec >= startSec && sec <= endSec;
                  })
                  .toList(growable: false);
              if (visiblePoints.length < 2) {
                return Center(child: Text(l10n.coinDetailNoChartData));
              }

              final spots = <FlSpot>[
                for (final p in visiblePoints)
                  FlSpot(p.time.millisecondsSinceEpoch / 1000.0, p.value),
              ];

              final minY =
                  spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
              final maxY =
                  spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
              final yPadding = (maxY - minY).abs() * 0.05;
              final minYChart = math.max(0, minY - yPadding).toDouble();
              final maxYChart = maxY + yPadding;
              final yAxis =
                  niceAxis(min: minYChart, max: maxYChart, tickCount: 6);

              final cmcAxisFormat = switch (state.range) {
                CoinChartRange.h24 => DateFormat('HH:mm'),
                CoinChartRange.d7 || CoinChartRange.d30 => DateFormat('MM/dd'),
                CoinChartRange.y1 => DateFormat('MM/yyyy'),
                CoinChartRange.all => DateFormat('yyyy'),
              };

              final minX = startSec.toDouble();
              final maxX = endSec.toDouble();

              final lastSpot = spots.last;

              return LayoutBuilder(
                builder: (context, constraints) {
                  final height = constraints.maxHeight;
                  final width = constraints.maxWidth;
                  final yRange = (yAxis.max - yAxis.min).abs();
                  final bottomAxisHeight = 16.h;
                  final chartHeight = math.max(0, height - bottomAxisHeight);
                  final yLabelWidth = 76.w;

                  final baseLine = state.baselineValue ?? spots.first.y;
                  final baseLineText = formatRawPrice(baseLine);
                  final baseYPct = yRange == 0
                      ? 0.5
                      : ((baseLine - yAxis.min) / yRange).clamp(0.0, 1.0);
                  final baseY = chartHeight - baseYPct * chartHeight;
                  final baseLabelTop =
                      (baseY - 12.h).clamp(6.0, chartHeight - 28.h);

                  final tickCount = switch (state.range) {
                    CoinChartRange.h24 => 7,
                    CoinChartRange.d7 || CoinChartRange.d30 => 6,
                    CoinChartRange.y1 || CoinChartRange.all => 6,
                  };
                  final spanSec = (endSec - startSec).abs();
                  final tickSecs = <int>[
                    for (var i = 0; i < tickCount; i++)
                      startSec +
                          ((spanSec * i) / (tickCount - 1)).round() *
                              (endSec >= startSec ? 1 : -1),
                  ];

                  final yTicks = <double>[];
                  if (yAxis.interval > 0 && yAxis.interval.isFinite) {
                    for (var v = yAxis.min;
                        v <= yAxis.max + (yAxis.interval * 0.5);
                        v += yAxis.interval) {
                      if (v.isFinite) yTicks.add(v);
                    }
                  }

                  double? crossX(FlSpot a, FlSpot b, double y) {
                    final dy = b.y - a.y;
                    if (dy == 0) return null;
                    final t = (y - a.y) / dy;
                    if (t < 0 || t > 1) return null;
                    return a.x + (b.x - a.x) * t;
                  }

                  final segments = <({bool above, List<FlSpot> spots})>[];
                  var above = spots.first.y >= baseLine;
                  var seg = <FlSpot>[spots.first];
                  for (var i = 1; i < spots.length; i++) {
                    final prev = spots[i - 1];
                    final next = spots[i];
                    final nextAbove = next.y >= baseLine;
                    if (nextAbove == above) {
                      seg.add(next);
                      continue;
                    }
                    final cx = crossX(prev, next, baseLine);
                    if (cx != null) {
                      final cross = FlSpot(cx, baseLine);
                      seg.add(cross);
                      segments.add((above: above, spots: seg));
                      above = nextAbove;
                      seg = <FlSpot>[cross, next];
                    } else {
                      seg.add(next);
                      segments.add((above: above, spots: seg));
                      above = nextAbove;
                      seg = <FlSpot>[next];
                    }
                  }
                  if (seg.length >= 2) segments.add((above: above, spots: seg));

                  final areaColor =
                      (lastSpot.y - baseLine) >= 0 ? positiveColor : negativeColor;
                  final areaBar = LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 0,
                    color: Colors.transparent,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          areaColor.withValues(alpha: 0.18),
                          areaColor.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  );

                  final bars = <LineChartBarData>[areaBar];
                  for (final s in segments) {
                    final segColor = s.above ? positiveColor : negativeColor;
                    bars.add(
                      LineChartBarData(
                        spots: s.spots,
                        isCurved: true,
                        barWidth: 2,
                        color: segColor,
                        belowBarData: BarAreaData(show: false),
                        dotData: const FlDotData(show: false),
                      ),
                    );
                  }

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragStart: (_) =>
                        context.read<CoinChartCubit>().beginPan(),
                    onHorizontalDragUpdate: (details) {
                      if (width <= 0) return;
                      final secPerPx = state.windowSpanSec / width;
                      final deltaSec = (-details.delta.dx * secPerPx).round();
                      if (deltaSec == 0) return;
                      context
                          .read<CoinChartCubit>()
                          .panBySeconds(id: widget.coinId, deltaSeconds: deltaSec);
                    },
                    onHorizontalDragEnd: (_) =>
                        context.read<CoinChartCubit>().endPan(),
                    onHorizontalDragCancel: () =>
                        context.read<CoinChartCubit>().endPan(),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: bottomAxisHeight),
                            child: LineChart(
                              LineChartData(
                                minX: minX,
                                maxX: maxX,
                                minY: yAxis.min,
                                maxY: yAxis.max,
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  getDrawingHorizontalLine: (value) => FlLine(
                                    color: scheme.onSurfaceVariant
                                        .withValues(alpha: 0.08),
                                    strokeWidth: 1,
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                extraLinesData: ExtraLinesData(
                                  extraLinesOnTop: true,
                                  horizontalLines: [
                                    HorizontalLine(
                                      y: baseLine,
                                      color: scheme.onSurfaceVariant
                                          .withValues(alpha: 0.5),
                                      strokeWidth: 1,
                                      dashArray: [6, 6],
                                    ),
                                  ],
                                ),
                                titlesData: const FlTitlesData(
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                lineTouchData:
                                    const LineTouchData(enabled: false),
                                lineBarsData: bars,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8.w,
                          right: 8.w,
                          bottom: 0,
                          child: Row(
                            children: [
                              for (var i = 0; i < tickSecs.length; i++)
                                Expanded(
                                  child: Align(
                                    alignment: i == 0
                                        ? Alignment.centerLeft
                                        : i == tickSecs.length - 1
                                            ? Alignment.centerRight
                                            : Alignment.center,
                                    child: Text(
                                      () {
                                        final dt = DateTime.fromMillisecondsSinceEpoch(
                                          tickSecs[i] * 1000,
                                          isUtc: true,
                                        ).toLocal();
                                        final normalized = switch (state.range) {
                                          CoinChartRange.y1 =>
                                            DateTime(dt.year, dt.month, 1),
                                          CoinChartRange.all =>
                                            DateTime(dt.year, 1, 1),
                                          _ => dt,
                                        };
                                        return cmcAxisFormat.format(normalized);
                                      }(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: scheme.onSurface
                                                .withValues(alpha: 0.55),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11,
                                          ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: bottomAxisHeight,
                                right: 6.w,
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  for (final v in yTicks)
                                    Positioned(
                                      right: 0,
                                      top: (() {
                                        if (yRange == 0) return chartHeight / 2;
                                        final pct =
                                            ((v - yAxis.min) / yRange).clamp(0.0, 1.0);
                                        final y = chartHeight - pct * chartHeight;
                                        return (y - 8.h)
                                            .clamp(0.0, chartHeight - 16.h);
                                      })(),
                                      child: SizedBox(
                                        width: yLabelWidth,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            formatAxisYLabel(v),
                                            softWrap: false,
                                            maxLines: 1,
                                            overflow: TextOverflow.visible,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: scheme.onSurface
                                                      .withValues(alpha: 0.55),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 11,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8.w,
                          top: baseLabelTop,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.surface.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: areaColor.withValues(alpha: 0.85),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              baseLineText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: areaColor.withValues(alpha: 0.95),
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                        ),
                        if (state.isFetchingOlder)
                          Positioned(
                            left: 8.w,
                            top: 8.h,
                            child: SizedBox(
                              width: 16.r,
                              height: 16.r,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  scheme.onSurfaceVariant.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        BlocBuilder<CoinChartCubit, CoinChartState>(
          builder: (context, state) {
            return _TimeframeBar(
              value: state.range,
              onChanged: (r) => context
                  .read<CoinChartCubit>()
                  .selectRange(id: widget.coinId, range: r),
            );
          },
        ),
      ],
    );
  }
}

class _PillOption<T> {
  const _PillOption({required this.value, required this.label});

  final T value;
  final String label;
}

class _PillToggle<T> extends StatelessWidget {
  const _PillToggle({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final T value;
  final List<_PillOption<T>> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>();
    final borderColor = (ext?.border ?? scheme.outline).withValues(alpha: 0.6);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((o) {
          final selected = o.value == value;
          return Padding(
            padding: EdgeInsets.only(right: o == options.last ? 0 : 4.w),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => onChanged(o.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: selected ? scheme.surface : Colors.transparent,
                ),
                child: Text(
                  o.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color:
                            selected ? scheme.onSurface : scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class _PillIconOption<T> {
  const _PillIconOption({
    required this.value,
    required this.icon,
    required this.semanticLabel,
  });

  final T value;
  final IconData icon;
  final String semanticLabel;
}

class _PillIconToggle<T> extends StatelessWidget {
  const _PillIconToggle({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final T value;
  final List<_PillIconOption<T>> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>();
    final borderColor = (ext?.border ?? scheme.outline).withValues(alpha: 0.6);

    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((o) {
          final selected = o.value == value;
          return Padding(
            padding: EdgeInsets.only(right: o == options.last ? 0 : 4.w),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => onChanged(o.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 40.r,
                height: 34.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: selected ? scheme.surface : Colors.transparent,
                ),
                child: Semantics(
                  label: o.semanticLabel,
                  button: true,
                  selected: selected,
                  child: Icon(
                    o.icon,
                    size: 18.r,
                    color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class _TimeframeBar extends StatelessWidget {
  const _TimeframeBar({required this.value, required this.onChanged});

  final CoinChartRange value;
  final ValueChanged<CoinChartRange> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColors>();
    final borderColor = (ext?.border ?? scheme.outline).withValues(alpha: 0.6);

    final labels = <CoinChartRange, String>{
      CoinChartRange.h24: l10n.coinDetailTf24h,
      CoinChartRange.d7: '7D',
      CoinChartRange.d30: '30D',
      CoinChartRange.y1: l10n.coinDetailTf1y,
      CoinChartRange.all: 'all',
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderColor),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: CoinChartRange.values.map((r) {
            final selected = r == value;
            final label = labels[r] ?? r.label;

            return Padding(
              padding: EdgeInsets.only(
                right: r == CoinChartRange.values.last ? 0 : 8.w,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => onChanged(r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: selected ? scheme.primary : Colors.transparent,
                    border: Border.all(
                      color: selected
                          ? scheme.primary
                          : scheme.onSurfaceVariant.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: selected
                              ? scheme.onPrimary
                              : scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ),
            );
          }).toList(growable: false),
        ),
      ),
    );
  }
}