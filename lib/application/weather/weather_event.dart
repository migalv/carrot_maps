part of 'weather_bloc.dart';

@freezed
class WeatherEvent with _$WeatherEvent {
  const factory WeatherEvent.locationFetched({
    double? latitude,
    double? longitude,
  }) = _LocationFetched;
}
