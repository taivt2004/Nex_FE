import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/data/repository/alert_repos.dart';
import 'package:nexpaylab/app/di/dependency_injection.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/features/home/presentation/bloc/marketplace_bloc/marketplace_bloc.dart';
import 'package:nexpaylab/features/home/presentation/widget/home_tab/home_crypto_actives_header.dart';
import 'package:nexpaylab/features/home/presentation/widget/home_tab/home_market_place_section.dart';
import 'package:nexpaylab/features/home/presentation/widget/home_tab/home_top_bar.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';
import 'package:nexpaylab/shared/ui/dialogs.dart';
import 'package:nexpaylab/shared/utils/result.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage>
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

  Future<void> _onProfileTap() async {
    final alertRepository = getIt<AlertRepository>();
    final identityRes = await alertRepository.getStoredIdentity();
    final userIdRes = await alertRepository.getStoredUserId();
    final identity = identityRes.maybeWhen(
      success: (value) => value ?? '',
      orElse: () => '',
    );
    final userId = userIdRes.maybeWhen(
      success: (value) => value,
      orElse: () => null,
    );

    if (!mounted) return;

    if (userId != null && identity.isNotEmpty) {
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => _AlertUserSheet(
          identity: identity,
          onLogout: () async {
            Navigator.of(context).pop();
            final repo = getIt<AlertRepository>();
            final result = await repo.logoutUser();
            if (!mounted) return;
            result.when(
              success: (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã đăng xuất')),
                );
              },
              failure: (e) {
                showErrorDialog(context, desc: e.toString());
              },
            );
          },
        ),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (_) => _AlertLoginDialog(
        onSubmit: (String value) async {
          final repo = getIt<AlertRepository>();
          final result = await repo.loginUser(value);
          if (!mounted) return;
          result.when(
            success: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đăng nhập thành công')),
              );
            },
            failure: (e) {
              showErrorDialog(context, desc: e.toString());
            },
          );
        },
      ),
    );
  }

  void _onScroll() {
    if (_isBottom) {
      final bloc = context.read<MarketplaceBloc>();
      
      if (bloc.state.status != MarketplaceStatus.loading &&
          !bloc.state.hasReachedMax) {
        bloc.add(const LoadMoreMarketplace());
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
      backgroundColor: const Color(0xFF090B10),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.dg)
                  .copyWith(top: 16.dg),
              child: HomeTopBar(
                onProfileTap: _onProfileTap,
                onNotificationTap: () {
                  context.push(AppRouter.alertEvents);
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<MarketplaceBloc>().add(const FetchMarketplace());
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
                            const _HomeCategoryTabs(),
                            SizedBox(height: 24.h),
                            const _HomeOverviewCards(),
                            SizedBox(height: 24.h),
                            const HomeCryptoActivesHeader(),
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
    );
  }
}

class _HomeCategoryTabs extends StatelessWidget {
  const _HomeCategoryTabs();

  @override
  Widget build(BuildContext context) {
    const tabs = [
      'Tiền mã hóa',
      'Danh mục',
      'NFT',
      'Sàn giao dịch',
    ];

    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => SizedBox(width: 28.w),
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tabs[index],
                style: PoppinsTextStyles.primary18Regular.copyWith(
                  color: isSelected ? Colors.white : OlaColors.gray400,
                ),
              ),
              SizedBox(height: 8.h),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 46.w : 0,
                height: 3.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HomeOverviewCards extends StatelessWidget {
  const _HomeOverviewCards();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 142.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const _OverviewCard(
            title: 'Thị trường',
            value: '▼ 4.7%',
            valueColor: OlaColors.redColor,
            lineColor: OlaColors.redColor,
            points: [0.7, 0.55, 0.58, 0.45, 0.38, 0.22, 0.3, 0.1],
          ),
          SizedBox(width: 14.w),
          const _OverviewCard(
            title: 'Khối lượng trong 24h',
            value: r'397.73B US$',
            valueColor: Colors.white,
            lineColor: Color(0xFF22C55E),
            points: [0.25, 0.2, 0.24, 0.22, 0.32, 0.38, 0.34, 0.4],
          ),
        ],
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.title,
    required this.value,
    required this.valueColor,
    required this.lineColor,
    required this.points,
  });

  final String title;
  final String value;
  final Color valueColor;
  final Color lineColor;
  final List<double> points;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF12151B),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFF1E222B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: PoppinsTextStyles.primary16Regular.copyWith(
              color: OlaColors.gray400,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            value,
            style: PoppinsTextStyles.primary18Bold.copyWith(
              color: valueColor,
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: CustomPaint(
              size: Size(double.infinity, 60.h),
              painter: _SparklinePainter(
                points: points,
                color: lineColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({
    required this.points,
    required this.color,
  });

  final List<double> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final path = Path();
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.25),
          color.withValues(alpha: 0),
        ],
      ).createShader(Offset.zero & size);

    for (var i = 0; i < points.length; i++) {
      final dx = size.width * i / (points.length - 1);
      final dy = size.height * (1 - points[i]);
      if (i == 0) {
        path.moveTo(dx, dy);
      } else {
        path.lineTo(dx, dy);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas
      ..drawPath(fillPath, fillPaint)
      ..drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}

class _AlertUserSheet extends StatelessWidget {
  const _AlertUserSheet({
    required this.identity,
    required this.onLogout,
  });

  final String identity;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: const Color(0xFF12151B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        border: Border.all(color: const Color(0xFF1E222B)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tài khoản',
              style: PoppinsTextStyles.primary18Bold.copyWith(color: Colors.white),
            ),
            SizedBox(height: 10.h),
            Text(
              identity,
              style: PoppinsTextStyles.primary14Regular.copyWith(color: OlaColors.gray400),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onLogout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: OlaColors.redColor,
                  side: const BorderSide(color: OlaColors.redColor),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: const Text('Đăng xuất'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertLoginDialog extends StatefulWidget {
  const _AlertLoginDialog({
    required this.onSubmit,
  });

  final ValueChanged<String> onSubmit;

  @override
  State<_AlertLoginDialog> createState() => _AlertLoginDialogState();
}

class _AlertLoginDialogState extends State<_AlertLoginDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Đăng nhập'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Nhập email (vd: user1@test.com)',
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Huỷ'),
        ),
        TextButton(
          onPressed: () {
            final value = _controller.text.trim();
            if (value.isEmpty) return;
            Navigator.of(context).pop();
            widget.onSubmit(value);
          },
          child: const Text('Xác nhận'),
        ),
      ],
    );
  }
}
