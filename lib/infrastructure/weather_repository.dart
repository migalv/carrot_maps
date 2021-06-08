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
      late WeatherRepositoryFailure failure;
      if (e.response != null) {
        failure = WeatherRepositoryFailure.serverError(
          errorCode: e.response!.statusCode,
        );
      } else {
        failure = WeatherRepositoryFailure.noResponse(
          errorMessage: e.message,
        );
      }
      return Left(failure);
    }

    final failure = WeatherRepositoryFailure.unknownServerResponse(
      errorCode: response.statusCode,
    );
    return Left(failure);
  }
}

const String serverErrorMessage =
    "Server responded with error.{e.response!.statusCode != null ? ' ({e.response!.statusCode})' : ''}";
const String noResponseErrorMessage =
    "Server did not respond.{e.message != " " ? ' Error: {e.message}' : ''}";
const String unknownServerResponseErrorMessage =
    "Received an unknown server response {e.response!.statusCode != null ? ' ({e.response!.statusCode})' : ''}";
