import 'dart:math';

import 'package:flutter/material.dart';

class Thermometer extends StatelessWidget {
  final double temperature;
  const Thermometer({Key? key, required this.temperature}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112.0,
      width: 112.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black54,
      ),
      child: CustomPaint(
        foregroundPainter: CircleProgress(temperature),
        child: Center(
          child: Text(
            "$temperature°C",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
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
