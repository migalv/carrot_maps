import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_service_failure.freezed.dart';

@freezed
class WeatherServiceFailure with _$WeatherServiceFailure {
  const factory WeatherServiceFailure.serverError({
    int? errorCode,
  }) = _ServerError;

  const factory WeatherServiceFailure.noResponse({
    String? errorMessage,
  }) = _NoResponse;

  const factory WeatherServiceFailure.unknownServerResponse({
    int? errorCode,
  }) = _UnknownServerResponse;
}
