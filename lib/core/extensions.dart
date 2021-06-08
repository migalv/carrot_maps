import 'dart:math';

extension DoubleX on double {
  double toPrecision(int places) {
    final double mod = pow(10.0, places).toDouble();
    return (this * mod).round().toDouble() / mod;
  }
}
