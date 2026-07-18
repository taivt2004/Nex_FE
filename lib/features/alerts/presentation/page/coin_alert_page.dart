import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/data/model/alert/alert_subscription.dart';
import 'package:nexpaylab/app/di/dependency_injection.dart';
import 'package:nexpaylab/features/alerts/presentation/bloc/coin_alert_bloc.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';
import 'package:nexpaylab/shared/ui/dialogs.dart';

class CoinAlertPage extends StatelessWidget {
  const CoinAlertPage({
    required this.coinId,
    required this.coinName,
    required this.coinSymbol,
    required this.imageUrl,
    super.key,
  });

  final String coinId;
  final String coinName;
  final String coinSymbol;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CoinAlertBloc>()
        ..add(
          LoadCoinAlerts(
            coinId: coinId,
            coinName: coinName,
            coinSymbol: coinSymbol,
            imageUrl: imageUrl,
          ),
        ),
      child: const _CoinAlertView(),
    );
  }
}

class _CoinAlertView extends StatelessWidget {
  const _CoinAlertView();

  static const _pageBackground = Color(0xFFF7F8FC);
  static const _surfaceColor = Colors.white;
  static const _borderColor = Color(0xFFE6E8F0);
  static const _primaryColor = Color(0xFF4F7CFF);
  static const _textPrimary = Color(0xFF121826);
  static const _textSecondary = Color(0xFF667085);
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoinAlertBloc, CoinAlertState>(
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          context.read<CoinAlertBloc>().add(const ClearCoinAlertMessage());
        }
        if (state.errorMessage.isNotEmpty) {
          showErrorDialog(context, desc: state.errorMessage);
          context.read<CoinAlertBloc>().add(const ClearCoinAlertMessage());
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: _pageBackground,
          appBar: AppBar(
            backgroundColor: _pageBackground,
            elevation: 0,
            title: Text(
              'Cảnh báo giá',
              style: OlaTextStyles.title20bold.copyWith(color: _textPrimary),
            ),
            leading: IconButton(
              onPressed: context.pop,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _textPrimary),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: _borderColor),
                  ),
                  child: IconButton(
                    onPressed: state.requiresIdentity
                        ? null
                        : () => _showCreateAlertSheet(context, state),
                    icon: const Icon(Icons.add_rounded),
                    color: _textPrimary,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                _CoinHeaderCard(state: state),
                SizedBox(height: 16.h),
                if (state.status == CoinAlertStatus.loading ||
                    state.status == CoinAlertStatus.submitting)
                  const Center(child: CircularProgressIndicator()),
                if (state.requiresIdentity)
                  _AlertIdentityCard(
                    initialValue: state.userIdentity,
                    onSubmit: (value) {
                      context.read<CoinAlertBloc>().add(SaveAlertIdentity(value));
                    },
                  )
                else ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _showCreateAlertSheet(context, state),
                      style: TextButton.styleFrom(
                        foregroundColor: _primaryColor,
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text('Thêm'),
                    ),
                  ),
                  if (state.alerts.isEmpty)
                    _EmptyAlertCard(
                      onCreate: () => _showCreateAlertSheet(context, state),
                    )
                  else
                    _AlertListCard(alerts: state.alerts),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCreateAlertSheet(BuildContext context, CoinAlertState state) {
    final bloc = context.read<CoinAlertBloc>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: _CreateAlertSheet(coinSymbol: state.coinSymbol),
      ),
    );
  }
}

class _CoinHeaderCard extends StatelessWidget {
  const _CoinHeaderCard({required this.state});

  final CoinAlertState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: state.imageUrl.isEmpty
              ? Container(
                  width: 42.w,
                  height: 42.w,
                  color: Colors.orangeAccent,
                  alignment: Alignment.center,
                  child: Text(
                    state.coinSymbol.isEmpty ? '?' : state.coinSymbol.substring(0, 1),
                    style: PoppinsTextStyles.primary16Semibold.copyWith(color: Colors.white),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: state.imageUrl,
                  width: 42.w,
                  height: 42.w,
                  fit: BoxFit.cover,
                ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.coinName,
                style: PoppinsTextStyles.primary18Semibold.copyWith(color: Colors.black87),
              ),
              Text(
                state.coinSymbol,
                style: PoppinsTextStyles.primary14Regular.copyWith(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AlertIdentityCard extends StatefulWidget {
  const _AlertIdentityCard({
    required this.initialValue,
    required this.onSubmit,
  });

  final String initialValue;
  final ValueChanged<String> onSubmit;

  @override
  State<_AlertIdentityCard> createState() => _AlertIdentityCardState();
}

class _AlertIdentityCardState extends State<_AlertIdentityCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _CoinAlertView._borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kết nối user alert',
            style: PoppinsTextStyles.primary18Semibold
                .copyWith(color: _CoinAlertView._textPrimary),
          ),
          SizedBox(height: 8.h),
          Text(
            'Nhập email hoặc externalId một lần để dùng các API alert.',
            style: PoppinsTextStyles.primary14Regular
                .copyWith(color: _CoinAlertView._textSecondary),
          ),
          SizedBox(height: 14.h),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Ví dụ: user1@test.com hoặc ext-001',
              filled: true,
              fillColor: const Color(0xFFF5F7FB),
              hintStyle: PoppinsTextStyles.primary14Regular.copyWith(
                color: const Color(0xFF98A2B3),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _CoinAlertView._primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              onPressed: () => widget.onSubmit(_controller.text),
              child: const Text('Tiếp tục'),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyAlertCard extends StatelessWidget {
  const _EmptyAlertCard({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _CoinAlertView._borderColor),
      ),
      child: Column(
        children: [
          Text(
            'Chưa có alert nào cho coin này',
            style: PoppinsTextStyles.primary16Semibold
                .copyWith(color: _CoinAlertView._textPrimary),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tạo alert tăng/giảm theo % trong 1h hoặc 24h.',
            textAlign: TextAlign.center,
            style: PoppinsTextStyles.primary14Regular
                .copyWith(color: _CoinAlertView._textSecondary),
          ),
          SizedBox(height: 14.h),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: _CoinAlertView._primaryColor,
              side: const BorderSide(color: _CoinAlertView._primaryColor),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            onPressed: onCreate,
            child: const Text('Tạo alert'),
          ),
        ],
      ),
    );
  }
}

class _AlertListCard extends StatelessWidget {
  const _AlertListCard({required this.alerts});

  final List<AlertSubscription> alerts;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _CoinAlertView._borderColor),
      ),
      child: Column(
        children: [
          for (var index = 0; index < alerts.length; index++) ...[
            _AlertTile(alert: alerts[index]),
            if (index != alerts.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.alert});

  final AlertSubscription alert;

  @override
  Widget build(BuildContext context) {
    final isAbove = alert.isAbove;
    final color = isAbove ? const Color(0xFF16C784) : const Color(0xFFEA3943);
    final verb = isAbove ? 'Tăng lên' : 'Giảm xuống';
    final pctText = alert.changePct < 1
        ? alert.changePct.toStringAsFixed(2)
        : alert.changePct.toStringAsFixed(1);
    final subtitle = alert.isRepeat
        ? 'Định kỳ • ${alert.timeWindowLabel}'
        : 'Một lần • ${alert.timeWindowLabel}';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAbove ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              color: color,
              size: 18.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$verb $pctText% / ${alert.timeWindowLabel}',
                  style: PoppinsTextStyles.primary16Semibold
                      .copyWith(color: _CoinAlertView._textPrimary),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: PoppinsTextStyles.primary14Regular
                      .copyWith(color: _CoinAlertView._textSecondary),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Switch(
                value: alert.isActive,
                activeThumbColor: Colors.white,
                activeTrackColor: _CoinAlertView._primaryColor,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFD0D5DD),
                onChanged: (value) {
                  context.read<CoinAlertBloc>().add(
                        ToggleCoinAlert(id: alert.id, isActive: value),
                      );
                },
              ),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFFEECEE),
                  foregroundColor: const Color(0xFFEA3943),
                ),
                onPressed: () {
                  context.read<CoinAlertBloc>().add(DeleteCoinAlert(alert.id));
                },
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreateAlertSheet extends StatefulWidget {
  const _CreateAlertSheet({required this.coinSymbol});

  final String coinSymbol;

  @override
  State<_CreateAlertSheet> createState() => _CreateAlertSheetState();
}

class _CreateAlertSheetState extends State<_CreateAlertSheet> {
  final TextEditingController _percentController = TextEditingController(text: '0.5');
  String _direction = 'above';
  int _windowMinutes = 60;
  bool _repeat = false;

  @override
  void dispose() {
    _percentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.coinSymbol} - Cảnh báo theo %',
              style: PoppinsTextStyles.primary18Semibold
                  .copyWith(color: _CoinAlertView._textPrimary),
            ),
            SizedBox(height: 18.h),
            SegmentedButton<String>(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return _CoinAlertView._primaryColor;
                  }
                  return const Color(0xFFF4F6FB);
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return _CoinAlertView._textPrimary;
                }),
                side: const WidgetStatePropertyAll(
                  BorderSide(color: _CoinAlertView._borderColor),
                ),
                textStyle: WidgetStatePropertyAll(
                  PoppinsTextStyles.primary14Semibold,
                ),
              ),
              segments: const [
                ButtonSegment(value: 'above', label: Text('Khi giá tăng')),
                ButtonSegment(value: 'below', label: Text('Khi giá giảm')),
              ],
              selected: {_direction},
              onSelectionChanged: (selection) {
                setState(() => _direction = selection.first);
              },
            ),
            SizedBox(height: 18.h),
            TextField(
              controller: _percentController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: PoppinsTextStyles.primary18Semibold
                  .copyWith(color: _CoinAlertView._textPrimary),
              decoration: InputDecoration(
                labelText: 'Ngưỡng %',
                suffixText: '%',
                filled: true,
                fillColor: const Color(0xFFF5F7FB),
                labelStyle: PoppinsTextStyles.primary14Regular.copyWith(
                  color: _CoinAlertView._textSecondary,
                ),
                suffixStyle: PoppinsTextStyles.primary18Semibold.copyWith(
                  color: _CoinAlertView._textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 18.h),
            SegmentedButton<int>(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xFF101828);
                  }
                  return const Color(0xFFF4F6FB);
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return _CoinAlertView._textPrimary;
                }),
                side: const WidgetStatePropertyAll(
                  BorderSide(color: _CoinAlertView._borderColor),
                ),
              ),
              segments: const [
                ButtonSegment(value: 60, label: Text('1h')),
                ButtonSegment(value: 1440, label: Text('24h')),
              ],
              selected: {_windowMinutes},
              onSelectionChanged: (selection) {
                setState(() => _windowMinutes = selection.first);
              },
            ),
            SizedBox(height: 12.h),
            CheckboxListTile(
              value: _repeat,
              contentPadding: EdgeInsets.zero,
              activeColor: _CoinAlertView._primaryColor,
              checkColor: Colors.white,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                'Nhận cảnh báo định kỳ',
                style: PoppinsTextStyles.primary14Regular.copyWith(
                  color: _CoinAlertView._textPrimary,
                ),
              ),
              onChanged: (value) {
                setState(() => _repeat = value ?? false);
              },
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _CoinAlertView._primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                onPressed: () {
                  final pct = double.tryParse(_percentController.text.replaceAll(',', '.'));
                  if (pct == null || pct <= 0) {
                    showErrorDialog(context, desc: 'Vui lòng nhập % hợp lệ');
                    return;
                  }
                  context.read<CoinAlertBloc>().add(
                        CreateCoinAlert(
                          alertDirection: _direction,
                          timeWindowMinutes: _windowMinutes,
                          changePct: pct,
                          repeat: _repeat,
                        ),
                      );
                  Navigator.of(context).pop();
                },
                child: const Text('Đặt cảnh báo giá'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
