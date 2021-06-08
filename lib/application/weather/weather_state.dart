part of 'weather_bloc.dart';

@freezed
class WeatherState with _$WeatherState {
  const factory WeatherState.initial() = _Initial;
  const factory WeatherState.loadInProgress() = _LoadInProgress;
  const factory WeatherState.loadSuccess({
    required double temperature,
  }) = _LoadSuccess;
  const factory WeatherState.loadFailure({
    required String errorMessage,
  }) = _LoadFailure;
}
