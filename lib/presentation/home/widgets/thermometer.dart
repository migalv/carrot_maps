import 'dart:math';

import 'package:carrot_maps/application/weather/weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:carrot_maps/core/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Thermometer extends StatelessWidget {
  const Thermometer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherBloc, WeatherState>(
      listener: _blocListener,
      builder: (context, state) {
        bool isLoading = false;
        double? temperature;

        state.when(
          initial: () => isLoading = false,
          loadInProgress: () => isLoading = true,
          loadSuccess: (loadedTemperature) {
            isLoading = false;
            temperature = loadedTemperature;
          },
          loadFailure: (receivedErrorMessage) {
            isLoading = false;
          },
        );

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
                      temperature != null
                          ? "${temperature!.toPrecision(1)}°C"
                          : "N/A",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  void _blocListener(BuildContext context, WeatherState state) => state.when(
        initial: () {},
        loadInProgress: () {},
        loadSuccess: (places) {},
        loadFailure: (failureMessage) =>
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failureMessage),
          ),
        ),
      );
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
