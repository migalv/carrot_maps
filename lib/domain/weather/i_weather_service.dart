import 'package:carrot_maps/domain/weather/weather_service_failure.dart';
import 'package:dartz/dartz.dart';

/// Specifies a contract for a repository to handle weather with a server
abstract class IWeatherService {
  /// Retreives the temperature for a given coordinates
  Future<Either<WeatherServiceFailure, double>> getTemperatureForCoordinates({
    required double latitude,
    required double longitude,
  });
}
