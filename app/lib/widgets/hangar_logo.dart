import 'package:flutter/material.dart';

class HangarLogo extends StatelessWidget {
  final double size;
  final Color? backgroundColor;

  const HangarLogo({
    super.key,
    this.size = 100,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: backgroundColor != null ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ] : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.asset(
          'assets/images/Logo_hangar_hamburguer.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: const Color(0xFF87CEEB),
                borderRadius: BorderRadius.circular(size / 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_dining,
                    size: size * 0.4,
                    color: Colors.white,
                  ),
                  if (size > 60)
                    Text(
                      'HANGAR',
                      style: TextStyle(
                        fontSize: size * 0.12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}