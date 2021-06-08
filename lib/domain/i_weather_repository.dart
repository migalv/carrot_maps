import 'package:carrot_maps/domain/failures/weather_repository_failure.dart';
import 'package:dartz/dartz.dart';

/// Specifies a contract for a repository to handle weather with a server
abstract class IWeatherRepository {
  /// Retreives the temperature for a given coordinates
  Future<Either<WeatherRepositoryFailure, double>>
      getTemperatureForCoordinates({
    required double latitude,
    required double longitude,
  });
}
