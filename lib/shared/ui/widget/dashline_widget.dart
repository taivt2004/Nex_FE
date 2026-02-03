import 'package:flutter/material.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

class DashedLine extends StatelessWidget {
  const DashedLine({
    super.key,
    this.color = OlaColors.primarycolor700,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
  });

  final Color color;
  final double dashWidth;
  final double dashSpace;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: DashedLinePainter(
        color,
        dashWidth,
        dashSpace,
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  DashedLinePainter(this.color, this.dashWidth, this.dashSpace);

  final Color color;
  final double dashWidth;
  final double dashSpace;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0 // Set the width of the line
      ..style = PaintingStyle.stroke;

    var startX = 0.0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace; // Move to the next dash position
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
