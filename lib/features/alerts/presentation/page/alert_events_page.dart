import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nexpaylab/app/data/model/alert/alert_event_item.dart';
import 'package:nexpaylab/app/di/dependency_injection.dart';
import 'package:nexpaylab/features/alerts/presentation/bloc/alert_events_bloc.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';
import 'package:nexpaylab/shared/ui/dialogs.dart';

class AlertEventsPage extends StatelessWidget {
  const AlertEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AlertEventsBloc>()..add(const LoadAlertEvents()),
      child: const _AlertEventsView(),
    );
  }
}

class _AlertEventsView extends StatefulWidget {
  const _AlertEventsView();

  @override
  State<_AlertEventsView> createState() => _AlertEventsViewState();
}

class _AlertEventsViewState extends State<_AlertEventsView> {
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _pollTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (!mounted) return;
      context.read<AlertEventsBloc>().add(const LoadAlertEvents());
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AlertEventsBloc, AlertEventsState>(
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          context.read<AlertEventsBloc>().add(const ClearAlertEventsMessage());
        }
        if (state.errorMessage.isNotEmpty) {
          showErrorDialog(context, desc: state.errorMessage);
          context.read<AlertEventsBloc>().add(const ClearAlertEventsMessage());
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FC),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF7F8FC),
            elevation: 0,
            leading: IconButton(
              onPressed: context.pop,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF121826)),
            ),
            title: Text(
              'Thông báo',
              style: OlaTextStyles.title20bold.copyWith(color: const Color(0xFF121826)),
            ),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<AlertEventsBloc>().add(const LoadAlertEvents());
              },
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  if (state.status == AlertEventsStatus.loading ||
                      state.status == AlertEventsStatus.submitting)
                    const Center(child: CircularProgressIndicator()),
                  if (state.requiresIdentity)
                    _AlertEventsIdentityCard(
                      initialValue: state.identity,
                      onSubmit: (value) {
                        context.read<AlertEventsBloc>().add(
                              SaveAlertEventsIdentity(value),
                            );
                      },
                    )
                  else if (state.events.isEmpty)
                    const _EmptyEventsCard()
                  else
                    ...state.events.map(_AlertEventTile.new),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AlertEventsIdentityCard extends StatefulWidget {
  const _AlertEventsIdentityCard({
    required this.initialValue,
    required this.onSubmit,
  });

  final String initialValue;
  final ValueChanged<String> onSubmit;

  @override
  State<_AlertEventsIdentityCard> createState() => _AlertEventsIdentityCardState();
}

class _AlertEventsIdentityCardState extends State<_AlertEventsIdentityCard> {
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
        border: Border.all(color: const Color(0xFFE6E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kết nối user alert',
            style: PoppinsTextStyles.primary18Semibold.copyWith(
              color: const Color(0xFF121826),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Nhập email hoặc externalId để xem thông báo đã nhận.',
            style: PoppinsTextStyles.primary14Regular.copyWith(
              color: const Color(0xFF667085),
            ),
          ),
          SizedBox(height: 14.h),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Ví dụ: user1@test.com hoặc ext-001',
              filled: true,
              fillColor: const Color(0xFFF5F7FB),
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
                backgroundColor: const Color(0xFF4F7CFF),
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

class _EmptyEventsCard extends StatelessWidget {
  const _EmptyEventsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE6E8F0)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 42.sp,
            color: const Color(0xFF98A2B3),
          ),
          SizedBox(height: 12.h),
          Text(
            'Chưa có thông báo nào',
            style: PoppinsTextStyles.primary16Semibold.copyWith(
              color: const Color(0xFF121826),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Khi alert được trigger, danh sách sẽ xuất hiện ở đây.',
            textAlign: TextAlign.center,
            style: PoppinsTextStyles.primary14Regular.copyWith(
              color: const Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertEventTile extends StatelessWidget {
  const _AlertEventTile(this.event);

  final AlertEventItem event;

  @override
  Widget build(BuildContext context) {
    final color = event.isAbove ? const Color(0xFF16C784) : const Color(0xFFEA3943);
    final verb = event.isAbove ? 'tăng' : 'giảm';
    final pct = event.observedChangePct;
    final content = pct == null
        ? '${event.coinId.toUpperCase()} đã $verb, giá hiện tại ${_formatPrice(event.observedPrice)}'
        : '${event.coinId.toUpperCase()} đã $verb ${pct.toStringAsFixed(2)}% trong ${event.timeWindowLabel}, hiện tại ${_formatPrice(event.observedPrice)}';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE6E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              event.isAbove ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              color: color,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: PoppinsTextStyles.primary14Semibold.copyWith(
                    color: const Color(0xFF121826),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  _formatDateTime(event.triggeredAt),
                  style: PoppinsTextStyles.primary14Regular.copyWith(
                    color: const Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? value) {
    if (value == null) return '';
    return DateFormat('HH:mm - dd/MM/yyyy').format(value.toLocal());
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: r'$',
      decimalDigits: price >= 1000 ? 0 : 2,
    );
    return formatter.format(price);
  }
}
