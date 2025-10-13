import 'package:flutter/material.dart';

class HamburgerIcon extends StatelessWidget {
  final double size;
  final Color color;

  const HamburgerIcon({
    super.key,
    this.size = 60,
    this.color = const Color(0xFF87CEEB),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: HamburgerPainter(color: color),
    );
  }
}

class HamburgerPainter extends CustomPainter {
  final Color color;

  HamburgerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Pão superior
    final topBunPath = Path();
    topBunPath.addArc(
      Rect.fromCircle(center: Offset(center.dx, center.dy - radius * 0.3), radius: radius * 0.8),
      0,
      3.14159,
    );
    canvas.drawPath(topBunPath, paint..color = const Color(0xFFD2691E));

    // Alface
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, center.dy - radius * 0.1), width: radius * 1.4, height: radius * 0.2),
        const Radius.circular(5),
      ),
      paint..color = Colors.green,
    );

    // Carne
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: radius * 1.2, height: radius * 0.3),
        const Radius.circular(8),
      ),
      paint..color = const Color(0xFF8B4513),
    );

    // Queijo
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, center.dy + radius * 0.1), width: radius * 1.3, height: radius * 0.15),
        const Radius.circular(3),
      ),
      paint..color = Colors.orange,
    );

    // Pão inferior
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, center.dy + radius * 0.4), width: radius * 1.5, height: radius * 0.3),
        const Radius.circular(10),
      ),
      paint..color = const Color(0xFFD2691E),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}