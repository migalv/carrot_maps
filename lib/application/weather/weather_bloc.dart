import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carrot_maps/domain/weather/i_weather_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'weather_event.dart';
part 'weather_state.dart';
part 'weather_bloc.freezed.dart';

@injectable
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final IWeatherService _weatherService;

  WeatherBloc(this._weatherService) : super(const WeatherState.initial());

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    yield* event.map(
      locationFetched: (event) async* {
        yield const WeatherState.loadInProgress();

        if (event.latitude == null || event.longitude == null) {
          yield const WeatherState.loadFailure(
            errorMessage: invalidLocationErrorMessage,
          );
        } else {
          final failureOrTemperature =
              await _weatherService.getTemperatureForCoordinates(
            latitude: event.latitude!,
            longitude: event.longitude!,
          );

          yield failureOrTemperature.fold(
            (failure) {
              return failure.when(
                serverError: (errorCode) {
                  return WeatherState.loadFailure(
                    errorMessage: serverErrorMessage(errorCode),
                  );
                },
                noResponse: (errorMessage) {
                  return WeatherState.loadFailure(
                    errorMessage: noResponseErrorMessage(errorMessage),
                  );
                },
                unknownServerResponse: (errorCode) {
                  return WeatherState.loadFailure(
                    errorMessage: unknownServerResponseErrorMessage(errorCode),
                  );
                },
              );
            },
            (temperature) => WeatherState.loadSuccess(temperature: temperature),
          );
        }
      },
    );
  }
}

String serverErrorMessage(int? errorCode) =>
    "Server responded with error.${errorCode != null ? ' ($errorCode)' : ''}";
String noResponseErrorMessage(String? errorMessage) =>
    "Server did not respond.${errorMessage != " " ? ' Error: $errorMessage' : ''}";
String unknownServerResponseErrorMessage(int? errorCode) =>
    "Received an unknown server response ${errorCode != null ? ' ($errorCode)' : ''}";

const String invalidLocationErrorMessage =
    "Location is invalid, cannot retreive temperature.";
