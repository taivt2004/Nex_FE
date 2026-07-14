import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _CoinDetailTopBar(detail: detail),
                        SizedBox(height: 20.h),
                        _CoinHeroCard(detail: detail),
                        SizedBox(height: 16.h),
                        const _ChartPlaceholderCard(),
                        SizedBox(height: 16.h),
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

class _ChartPlaceholderCard extends StatelessWidget {
  const _ChartPlaceholderCard();

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
            'Biểu đồ giá',
            style: PoppinsTextStyles.primary18Semibold.copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Mình để sẵn vị trí này để hoàn thiện chart ở bước sau. Trước mắt ưu tiên phần thông tin và bố cục chi tiết coin.',
            style: PoppinsTextStyles.primary14Regular.copyWith(
              color: OlaColors.gray400,
              height: 1.5,
            ),
          ),
          SizedBox(height: 16.h),
          const Row(
            children: [
              _DisabledRangeChip(label: '1H'),
              _DisabledRangeChip(label: '24H'),
              _DisabledRangeChip(label: '7D'),
              _DisabledRangeChip(label: '30D'),
              _DisabledRangeChip(label: '1Y'),
              _DisabledRangeChip(label: 'ALL'),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            height: 180.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0D1015),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: const Color(0xFF1E232D)),
            ),
            alignment: Alignment.center,
            child: Text(
              'Chart coming next',
              style: PoppinsTextStyles.primary14Regular.copyWith(
                color: OlaColors.gray500,
              ),
            ),
          ),
        ],
      ),
    );
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

class _DisabledRangeChip extends StatelessWidget {
  const _DisabledRangeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF151922),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Text(
        label,
        style: PoppinsTextStyles.primary12Regular.copyWith(
          color: OlaColors.gray400,
        ),
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
