part of 'map_bloc.dart';

@freezed
class MapEvent with _$MapEvent {
  const factory MapEvent.loadStarted({
    required double latitude,
    required double longitude,
  }) = _LoadStarted;
}
