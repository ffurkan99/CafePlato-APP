import 'package:flutter/material.dart';
import 'dart:math' as math;

/// CafePlato Arc — marka motifi.
/// Fincan tabağını çağrıştıran iki ince konsantrik yay.
/// Düşük opacity ile arka plan dekorasyonu olarak kullanılır.
class CafePlatoArc extends StatelessWidget {
  /// Motifin rengi. Genellikle açık beyaz veya çok açık primary.
  final Color color;

  /// Genel opacity (0.0 – 1.0). Bileşenin kendi opacity'si bu değerle çarpılır.
  final double opacity;

  /// Çizilecek yayın merkezini ne kadar dışarı taşıracağını belirler.
  /// [Alignment.centerRight] veya [Alignment.bottomRight] gibi değerler alır.
  final Alignment alignment;

  /// İç yayın yarıçapı faktörü (widget genişliğine göre).
  final double innerRadiusFactor;

  /// Dış yayın yarıçapı faktörü (widget genişliğine göre).
  final double outerRadiusFactor;

  const CafePlatoArc({
    super.key,
    this.color = Colors.white,
    this.opacity = 0.08,
    this.alignment = Alignment.centerRight,
    this.innerRadiusFactor = 0.55,
    this.outerRadiusFactor = 0.72,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: CustomPaint(
          painter: _ArcPainter(
            color: color,
            alignment: alignment,
            innerRadiusFactor: innerRadiusFactor,
            outerRadiusFactor: outerRadiusFactor,
          ),
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final double innerRadiusFactor;
  final double outerRadiusFactor;

  const _ArcPainter({
    required this.color,
    required this.alignment,
    required this.innerRadiusFactor,
    required this.outerRadiusFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    // Merkez noktası alignment'a göre hesaplanır
    final dx = (alignment.x + 1) / 2 * size.width;
    final dy = (alignment.y + 1) / 2 * size.height;
    final center = Offset(dx, dy);

    final innerRadius = size.width * innerRadiusFactor;
    final outerRadius = size.width * outerRadiusFactor;

    // Yay açısı: tabak hissi için ~200°
    const sweepAngle = 200 * math.pi / 180;
    const startAngle = -160 * math.pi / 180;

    // İç yay
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    // Dış yay (biraz daha ince)
    paint.strokeWidth = 0.8;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.alignment != alignment ||
      oldDelegate.innerRadiusFactor != innerRadiusFactor ||
      oldDelegate.outerRadiusFactor != outerRadiusFactor;
}
