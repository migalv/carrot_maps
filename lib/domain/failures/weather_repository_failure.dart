import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_repository_failure.freezed.dart';

@freezed
class WeatherRepositoryFailure with _$WeatherRepositoryFailure {
  const factory WeatherRepositoryFailure.serverError({
    int? errorCode,
  }) = _ServerError;

  const factory WeatherRepositoryFailure.noResponse({
    String? errorMessage,
  }) = _NoResponse;

  const factory WeatherRepositoryFailure.unknownServerResponse({
    int? errorCode,
  }) = _UnknownServerResponse;
}
