import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nexpaylab/share/theme/app_style.dart';

import 'package:nexpaylab/share/ui/widget/navigation/bottom_bar_active_item.dart';
import 'package:nexpaylab/share/ui/widget/navigation/bottom_bar_inactive_item.dart';
import 'package:nexpaylab/share/ui/widget/navigation/bottom_bar_painter.dart';
import 'package:nexpaylab/share/ui/widget/navigation/constants/constants.dart';
import 'package:nexpaylab/share/ui/widget/navigation/models/bottom_bar_item_model.dart';
import 'package:nexpaylab/share/ui/widget/navigation/notch_bottom_bar_controller.dart';

/// Class to generate the NotchBottomBar
class AnimatedNotchBottomBar extends StatefulWidget {
  const AnimatedNotchBottomBar({
    required this.notchBottomBarController,
    required this.bottomBarItems,
    required this.onTap,
    required this.kIconSize,
    required this.kBottomRadius,
    super.key,
    this.showNotch = true,
    this.showBorder = true,
    this.color = Colors.white,
    this.itemLabelStyle,
    this.activeItemLabelStyle,
    this.shadowElevation,
    this.showShadow = true,
    this.showLabel = true,
    this.notchShader,
    this.showBlurBottomBar = false,
    this.blurOpacity = 0.5,
    this.blurFilterX = 5.0,
    this.blurFilterY = 10.0,
    this.notchColor = Colors.white,
    this.durationInMilliSeconds = 300,
    this.bottomBarWidth = 500,
    this.removeMargins = false,
    this.bottomBarHeight = 62.0,
    this.elevation = 5.0,
    this.showBottomRadius = true,
    this.showTopRadius = true,
    this.notchGradient,
    this.maxLine,
    this.textOverflow,
    this.textAlign,
    this.textDirection,
    this.topMargin = 10.0,
    this.circleMargin = 8.0,
    this.topBorderOnly = false,
  });

  /// Controller for animation
  final NotchBottomBarController notchBottomBarController;

  /// List of items of bottom bar
  final List<BottomBarItem> bottomBarItems;

  /// Function called when an item was tapped
  final ValueChanged<int> onTap;

  /// Color of bottom bar
  final Color color;

  /// Boolean to show shadow
  final bool showShadow;

  /// Boolean to show bottom text
  final bool showLabel;

  /// TextStyle to show bottom text
  final TextStyle? itemLabelStyle;

  /// TextStyle to show active bottom text
  final TextStyle? activeItemLabelStyle;

  ///Boolean to show blur effect
  final bool showBlurBottomBar;

  ///Opacity
  final double blurOpacity;

  /// Filter X
  final double blurFilterX;

  /// Filter Y
  final double blurFilterY;

  /// Color of bottom bar
  final Color notchColor;

  final Shader? notchShader;

  final double? shadowElevation;

  final double kIconSize;

  final double kBottomRadius;

  /// show center notch and floating circle indicator
  final bool showNotch;

  /// show outline stroke around the bar
  final bool showBorder;

  /// set the maxLine of item label
  final int? maxLine;

  /// to handle the overflow of the item label
  final TextOverflow? textOverflow;

  /// textAlign to align the label text
  final TextAlign? textAlign;

  /// set the textDirection of item label
  final TextDirection? textDirection;

  /// Duration in milliseconds for animation
  final int durationInMilliSeconds;

  /// bottom bar width for web and desktop apps (It should be greater then 500 otherwise it will take media query width)
  final double bottomBarWidth;

  /// Hide side and bottom margins of bottom navigation bar
  final bool removeMargins;

  /// bottom bar height can be modify
  final double bottomBarHeight;

  /// elevation
  final double elevation;

  /// set bottom radius

  final bool showBottomRadius;

  /// set top radius

  final bool showTopRadius;

  /// add any gradient color to the notch
  final Gradient? notchGradient;

  /// set margin between notch and circle
  final double circleMargin;

  /// set top margin
  final double topMargin;

  /// Show only top border
  final bool topBorderOnly;

  @override
  State<AnimatedNotchBottomBar> createState() => _AnimatedNotchBottomBarState();
}

class _AnimatedNotchBottomBarState extends State<AnimatedNotchBottomBar>
    with SingleTickerProviderStateMixin {
  late double _screenWidth;
  int maxCount = 5;
  int currentIndex = 0;
  late final AnimationController _animationController;
  bool _isInitial = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width <= 500
        ? MediaQuery.of(context).size.width
        : widget.bottomBarWidth;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationInMilliSeconds),
    );

    kHeight = widget.bottomBarHeight;
    kTopRadius = widget.showTopRadius ? kTopRadius : 0;
    kBottomRadius = widget.showBottomRadius ? kBottomRadius : 0;
    kMargin = widget.removeMargins ? 0 : 14.0;
    widget.notchBottomBarController.addListener(() {
      _animationController
        ..reset()
        ..forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// throws exception if list length is more then 5
    if (widget.bottomBarItems.length > 5) {
      throw Exception(' Bottom bar item length should not be more than 5');
    }

    /// uncomment
    if (widget.notchBottomBarController.index >
        widget.bottomBarItems.length - 1) {
      throw Exception(
        ' Initial page index cannot be higher than bottom bar items length',
      );
    }
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final height = kHeight + kMargin * 2 + bottomPadding;

    return widget.bottomBarItems.length > maxCount
        ? const SizedBox.shrink()
        : AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext _, Widget? __) {
              ///to set any initial page
              var scrollPosition = widget.notchBottomBarController.index
                  .toDouble();
              int? currentIndex = widget.notchBottomBarController.index;
              if (widget.notchBottomBarController.oldIndex != null) {
                _isInitial = false;
                scrollPosition =
                    Tween<double>(
                      begin: widget.notchBottomBarController.oldIndex!
                          .toDouble(),
                      end: widget.notchBottomBarController.index.toDouble(),
                    )
                    // ignore: invalid_use_of_protected_member
                    .lerp(_animationController.value);
                currentIndex = widget.notchBottomBarController.index;
              } else {
                scrollPosition = widget.notchBottomBarController.index
                    .toDouble();
                currentIndex = widget.notchBottomBarController.index;
              }

              return ClipRRect(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: widget.removeMargins ? 4.0 : 8.0,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: widget.showBlurBottomBar
                              ? widget.blurFilterX
                              : 0.0,
                          sigmaY: widget.showBlurBottomBar
                              ? widget.blurFilterY
                              : 0.0,
                        ),
                        child: Opacity(
                          opacity: widget.showBlurBottomBar
                              ? widget.blurOpacity
                              : 1,
                          child: CustomPaint(
                            size: Size(_screenWidth, height),
                            painter: BottomBarPainter(
                              position: _itemPosByScrollPosition(
                                scrollPosition,
                              ),
                              showNotch: widget.showNotch,
                              showBorder: widget.showBorder,
                              color: widget.color,
                              showShadow: widget.showShadow,
                              notchColor: widget.notchColor,
                              shader: widget.notchShader,
                              shadowElevation: widget.shadowElevation,
                              kBottomRadius: widget.kBottomRadius,
                              gradient: widget.notchGradient,
                              elevation: widget.elevation,
                              topBorderOnly: widget.topBorderOnly,
                            ),
                          ),
                        ),
                      ),
                      if (widget.showNotch)
                        for (
                          var i = 0;
                          i < widget.bottomBarItems.length;
                          i++
                        ) ...[
                          if (i == currentIndex &&
                              (_animationController.value == 1.0 || _isInitial))
                            Positioned(
                              top: widget.removeMargins
                                  ? -widget.circleMargin / 2
                                  : widget.topMargin,
                              left:
                                  kCircleRadius -
                                  widget.topMargin / 2 +
                                  _itemPosByScrollPosition(scrollPosition) +
                                  2,
                              child: BottomBarActiveItem(
                                i,
                                itemWidget: widget.bottomBarItems[i].activeItem,
                                scrollPosition: scrollPosition,
                                onTap: widget.onTap,
                                kIconSize: widget.kIconSize,
                              ),
                            ),
                          if (i != currentIndex)
                            Positioned(
                              top: kMargin + (kHeight - kCircleRadius * 2) / 2,
                              left:
                                  widget.circleMargin +
                                  _itemPosByIndex(i) +
                                  kCircleRadius -
                                  40, // Center 80px width item (80/2 = 40)
                              child: BottomBarInActiveItem(
                                i,
                                textOverflow: widget.textOverflow,
                                textDirection: widget.textDirection,
                                textAlign: widget.textAlign,
                                maxLine: widget.maxLine,
                                itemWidget:
                                    widget.bottomBarItems[i].inActiveItem,
                                labelWidget:
                                    widget.bottomBarItems[i].itemLabelWidget,
                                label: widget.bottomBarItems[i].itemLabel,
                                onTap: (selectedIndex) {
                                  widget.notchBottomBarController.jumpTo(
                                    selectedIndex,
                                  );
                                  widget.onTap.call(selectedIndex);
                                },
                                showLabel: widget.showLabel,
                                labelStyle: widget.itemLabelStyle,
                                kIconSize: widget.kIconSize,
                              ),
                            ),
                        ]
                      else
                        for (
                          var i = 0;
                          i < widget.bottomBarItems.length;
                          i++
                        ) ...[
                          Positioned(
                            top: kMargin + (kHeight - kCircleRadius * 2) / 2,
                            left:
                                widget.circleMargin +
                                _itemPosByIndex(i) +
                                kCircleRadius -
                                40, // Center 80px width item
                            child: BottomBarInActiveItem(
                              i,
                              textOverflow: widget.textOverflow,
                              textDirection: widget.textDirection,
                              textAlign: widget.textAlign,
                              maxLine: widget.maxLine,
                              itemWidget: i == currentIndex
                                  ? widget.bottomBarItems[i].activeItem
                                  : widget.bottomBarItems[i].inActiveItem,
                              labelWidget:
                                  widget.bottomBarItems[i].itemLabelWidget,
                              label: widget.bottomBarItems[i].itemLabel,
                              onTap: (selectedIndex) {
                                widget.notchBottomBarController.jumpTo(
                                  selectedIndex,
                                );
                                widget.onTap.call(selectedIndex);
                              },
                              showLabel: widget.showLabel,
                              labelStyle: i == currentIndex
                                  ? (widget.activeItemLabelStyle ??
                                        widget.itemLabelStyle ??
                                        const TextStyle(
                                          color: OlaColors.primarycolor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ))
                                  : widget.itemLabelStyle,
                              kIconSize: widget.kIconSize,
                            ),
                          ),
                        ],
                    ],
                  ),
                ),
              );
            },
          );
  }

  double _firstItemPosition(double spaceParameter) {
    return (_screenWidth - kMargin * 2) * spaceParameter;
  }

  double _lastItemPosition(double spaceParameter) {
    return _screenWidth -
        (_screenWidth - kMargin * 2) * spaceParameter -
        (kCircleRadius + widget.circleMargin) * 2;
  }

  double _itemDistance() {
    return (_lastItemPosition(widget.removeMargins ? 0.05 : 0.1) -
            _firstItemPosition(widget.removeMargins ? 0.05 : 0.1)) /
        (widget.bottomBarItems.length - 1);
  }

  double _itemPosByScrollPosition(double scrollPosition) {
    return _firstItemPosition(widget.removeMargins ? 0.05 : 0.1) +
        _itemDistance() * scrollPosition;
  }

  double _itemPosByIndex(int index) {
    return _firstItemPosition(widget.removeMargins ? 0.05 : 0.1) +
        _itemDistance() * index;
  }
}
