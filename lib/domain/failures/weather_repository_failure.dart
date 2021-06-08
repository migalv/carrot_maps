import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_repository_failure.freezed.dart';

@freezed
class WeatherRepositoryFailure with _$WeatherRepositoryFailure {
  const factory WeatherRepositoryFailure.serverError({required int errorCode}) =
      _ServerError;
}
