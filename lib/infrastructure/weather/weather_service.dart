import 'package:carrot_maps/domain/failures/weather_service_failure.dart';
import 'package:carrot_maps/domain/weather/i_weather_service.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IWeatherService)
class WeatherService implements IWeatherService {
  final Dio _dio;

  WeatherService(this._dio);

  @override
  Future<Either<WeatherServiceFailure, double>> getTemperatureForCoordinates(
      {required double latitude, required double longitude}) async {
    late Response<Map<String, dynamic>> response;
    try {
      response = await _dio.get<Map<String, dynamic>>(
        "/data/2.5/weather",
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'appid': dotenv.env["OPEN_WEATHER_API_KEY"],
          'units': 'metric',
        },
      );
      if (response.statusCode == 200) {
        if (response.data != null) {
          return Right(response.data!["main"]["temp"] as double);
        }
      }
    } on DioError catch (e) {
      late WeatherServiceFailure failure;
      if (e.response != null) {
        failure = WeatherServiceFailure.serverError(
          errorCode: e.response!.statusCode,
        );
      } else {
        failure = WeatherServiceFailure.noResponse(
          errorMessage: e.message,
        );
      }
      return Left(failure);
    }

    final failure = WeatherServiceFailure.unknownServerResponse(
      errorCode: response.statusCode,
    );
    return Left(failure);
  }
}
