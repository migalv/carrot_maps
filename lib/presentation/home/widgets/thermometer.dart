import 'dart:math';

import 'package:flutter/material.dart';
import 'package:carrot_maps/core/extensions.dart';

class Thermometer extends StatelessWidget {
  final double? temperature;
  final bool isLoading;

  const Thermometer({Key? key, this.temperature = 0.0, this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112.0,
      width: 112.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black54,
      ),
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(
                strokeWidth: 8.0,
              ),
            )
          : CustomPaint(
              foregroundPainter: CircleProgress(temperature ?? 0.0),
              child: Center(
                child: Text(
                  "${temperature?.toPrecision(1) ?? 0}°C",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
    );
  }
}

class CircleProgress extends CustomPainter {
  double value;

  CircleProgress(this.value);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const int maximumValue = 50;
    final Color strokeColor = value > 29
        ? Colors.red
        : value > 21
            ? Colors.orange
            : Colors.green;

    final Paint outerCircle = Paint()
      ..strokeWidth = 14
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    final Paint tempArc = Paint()
      ..strokeWidth = 14
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = min(size.width / 2, size.height / 2) - 14;
    canvas.drawCircle(center, radius, outerCircle);

    final double angle = 2 * pi * (value / maximumValue);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
      tempArc,
    );
  }
}
