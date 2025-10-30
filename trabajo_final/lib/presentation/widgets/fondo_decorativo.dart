import 'package:flutter/material.dart';

/// Fondo decorativo reutilizable en todas las pantallas de la app
class FondoDecorativo extends StatelessWidget {
  final Widget child;

  const FondoDecorativo({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.white),

        _buildCircle(top: -40, left: -50, size: 160, color: const Color(0xFFBBA8FF)),
        _buildCircle(top: 200, right: -70, size: 180, color: const Color(0xFFF3B7FF)),
        _buildCircle(bottom: -80, left: 30, size: 220, color: const Color(0xFFD5C4FF)),

        Positioned(
          bottom: 100,
          right: 20,
          child: Transform.rotate(
            angle: 0.4,
            child: Opacity(
              opacity: 0.5,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3B7FF).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),

        SafeArea(child: child),
      ],
    );
  }

  Widget _buildCircle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
