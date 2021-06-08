import 'package:carrot_maps/domain/failures/weather_service_failure.dart';
import 'package:carrot_maps/infrastructure/weather/weather_service.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'weather_service_test.mocks.dart';

@GenerateMocks([Dio])
Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final mockDio = MockDio();
  final weatherService = WeatherService(mockDio);

  group('getTemperatureForCoordinates', () {
    test(
      'should return WeatherServiceFailure.serverError when server responds with error code',
      () async {
        // arrange
        const double tLatitude = 37.39;
        const double tLongitude = -122.08;
        const int tStatusCode = 401;
        const String tStatusMessage = "Error 401";

        when(mockDio.get(
          any,
          queryParameters: anyNamed("queryParameters"),
        )).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: "/data/2.5/weather"),
            response: Response(
              requestOptions: RequestOptions(path: "/data/2.5/weather"),
              statusCode: tStatusCode,
              statusMessage: tStatusMessage,
            ),
          ),
        );
        // act
        final result = await weatherService.getTemperatureForCoordinates(
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(
          result,
          const Left(
            WeatherServiceFailure.serverError(errorCode: tStatusCode),
          ),
        );
      },
    );

    test(
      'should return WeatherServiceFailure.noResponse when server does not respond',
      () async {
        // arrange
        const double tLatitude = 37.39;
        const double tLongitude = -122.08;

        when(mockDio.get(
          any,
          queryParameters: anyNamed("queryParameters"),
        )).thenThrow(
          DioError(requestOptions: RequestOptions(path: "/data/2.5/weather")),
        );
        // act
        final result = await weatherService.getTemperatureForCoordinates(
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(
          result,
          const Left(
            WeatherServiceFailure.noResponse(errorMessage: ""),
          ),
        );
      },
    );

    test(
      'should return WeatherServiceFailure.unknownServerResponse when server responds unexpectedly',
      () async {
        // arrange
        const double tLatitude = 37.39;
        const double tLongitude = -122.08;
        const int tStatusCode = 204;

        when(mockDio.get(
          any,
          queryParameters: anyNamed("queryParameters"),
        )).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: "/data/2.5/weather"),
            statusCode: tStatusCode,
          ),
        );
        // act
        final result = await weatherService.getTemperatureForCoordinates(
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(
          result,
          const Left(
            WeatherServiceFailure.unknownServerResponse(
              errorCode: tStatusCode,
            ),
          ),
        );
      },
    );

    test(
      'should return the correct temperature when the server responds with OK status',
      () async {
        // arrange
        const double tLatitude = 37.39;
        const double tLongitude = -122.08;
        const int tStatusCode = 200;
        const double tTemperature = 282.55;

        when(mockDio.get(
          any,
          queryParameters: anyNamed("queryParameters"),
        )).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            requestOptions: RequestOptions(path: "/data/2.5/weather"),
            statusCode: tStatusCode,
            data: tResponseData,
          ),
        );
        // act
        final result = await weatherService.getTemperatureForCoordinates(
          latitude: tLatitude,
          longitude: tLongitude,
        );

        // assert
        expect(
          result,
          const Right(tTemperature),
        );
      },
    );
  });
}

const tResponseData = {
  "coord": {"lon": -122.08, "lat": 37.39},
  "weather": [
    {"id": 800, "main": "Clear", "description": "clear sky", "icon": "01d"}
  ],
  "base": "stations",
  "main": {
    "temp": 282.55,
    "feels_like": 281.86,
    "temp_min": 280.37,
    "temp_max": 284.26,
    "pressure": 1023,
    "humidity": 100
  },
  "visibility": 16093,
  "wind": {"speed": 1.5, "deg": 350},
  "clouds": {"all": 1},
  "dt": 1560350645,
  "sys": {
    "type": 1,
    "id": 5122,
    "message": 0.0139,
    "country": "US",
    "sunrise": 1560343627,
    "sunset": 1560396563
  },
  "timezone": -25200,
  "id": 420006353,
  "name": "Mountain View",
  "cod": 200
};
