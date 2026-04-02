import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Full-screen decorative mashrabiya diamond pattern at 3% opacity.
class MashrabiyaBackground extends StatelessWidget {
  final Widget child;
  const MashrabiyaBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(painter: _MashrabiyaPainter()),
        ),
        child,
      ],
    );
  }
}

class _MashrabiyaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double tileSize = 60;
    final paint = Paint()
      ..color = AppColors.primaryContainer.withAlpha(8) // ~3% opacity
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width + tileSize; x += tileSize) {
      for (double y = 0; y < size.height + tileSize; y += tileSize) {
        final path = Path()
          ..moveTo(x + tileSize / 2, y)
          ..lineTo(x + tileSize, y + tileSize / 2)
          ..lineTo(x + tileSize / 2, y + tileSize)
          ..lineTo(x, y + tileSize / 2)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
