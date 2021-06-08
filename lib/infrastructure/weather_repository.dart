import 'package:carrot_maps/domain/failures/weather_repository_failure.dart';
import 'package:carrot_maps/domain/i_weather_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IWeatherRepository)
class WeatherRepository implements IWeatherRepository {
  final Dio _dio;

  WeatherRepository(this._dio);

  @override
  Future<Either<WeatherRepositoryFailure, double>> getTemperatureForCoordinates(
      {required double latitude, required double longitude}) async {
    final response = await _dio.get(
      "/data/2.5/weather",
      queryParameters: {
        'lat': latitude,
        'lon': longitude,
        'appid': dotenv.env["OPEN_WEATHER_API_KEY"],
        'units': 'metric',
      },
    );

    if (response.statusCode == 200) {
      return Right(response.data["main"]["temp"] as double);
    }

    final failure = WeatherRepositoryFailure.serverError(
      errorCode: response.statusCode ?? 404,
    );
    return Left(failure);
  }
}
