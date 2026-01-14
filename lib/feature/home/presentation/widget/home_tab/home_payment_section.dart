import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/gen/assets.gen.dart';
import 'package:nexpaylab/share/theme/app_style.dart';
import 'package:nexpaylab/share/ui/extensions/image.dart';

class HomePaymentCard {
  const HomePaymentCard({required this.image, required this.label});

  final String image;
  final String label;
}

class HomePaymentSection extends StatelessWidget {
  const HomePaymentSection({
    required this.cards,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
    this.onScanTap,
    super.key,
  });

  final List<HomePaymentCard> cards;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final VoidCallback? onScanTap;

  @override
  Widget build(BuildContext context) {
    final paymentCardPages = _chunkPaymentCards(cards);
    final paymentPageCount = paymentCardPages.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment',
          style: PoppinsTextStyles.display16Regular.copyWith(
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            color: OlaColors.primarycolor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onScanTap,
              borderRadius: BorderRadius.circular(16.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.iconsHomeQrscan.qrScanIcon.load(
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Scan QR to Pay',
                    style: PoppinsTextStyles.primary18Regular.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 100.h,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemCount: paymentPageCount,
            itemBuilder: (context, index) {
              final pageCards = paymentCardPages[index];

              return AnimatedBuilder(
                animation: pageController,
                builder: (context, child) {
                  final page = pageController.hasClients
                      ? (pageController.page ??
                            pageController.initialPage.toDouble())
                      : pageController.initialPage.toDouble();

                  final distance = (page - index).abs().clamp(0.0, 1.0);
                  final scale = 1 - (distance * 0.06);
                  final opacity = 1 - (distance * 0.25);
                  final translateY = distance * 10;

                  return Opacity(
                    opacity: opacity,
                    child: Transform.translate(
                      offset: Offset(0, translateY),
                      child: Transform.scale(scale: scale, child: child),
                    ),
                  );
                },
                child: _PaymentCardsRow(cards: pageCards),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        if (paymentPageCount > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              paymentPageCount,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: (index == currentPage ? 24 : 4).w,
                height: 4.h,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: index == currentPage
                      ? const Color(0xFF8B5CF6)
                      : const Color(0xFF262A34),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

List<List<HomePaymentCard>> _chunkPaymentCards(List<HomePaymentCard> cards) {
  const itemsPerPage = 4;
  final pages = <List<HomePaymentCard>>[];

  for (var i = 0; i < cards.length; i += itemsPerPage) {
    pages.add(
      cards.sublist(
        i,
        (i + itemsPerPage > cards.length) ? cards.length : i + itemsPerPage,
      ),
    );
  }

  return pages;
}

class _PaymentCardsRow extends StatelessWidget {
  const _PaymentCardsRow({required this.cards});

  final List<HomePaymentCard> cards;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: cards.map((card) => _PaymentCardItem(card: card)).toList(),
    );
  }
}

class _PaymentCardItem extends StatelessWidget {
  const _PaymentCardItem({required this.card});

  final HomePaymentCard card;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 68.w,
          height: 68.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            image: DecorationImage(
              image: NetworkImage(card.image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          card.label,
          style: PoppinsTextStyles.primary12Regular.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
