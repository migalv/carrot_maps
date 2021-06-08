part of 'map_bloc.dart';

@freezed
class MapState with _$MapState {
  const factory MapState.initial() = _Initial;
  const factory MapState.loadInProgress() = _LoadInProgress;
  const factory MapState.loadSuccess({
    required List<Place> places,
    required double temperature,
  }) = _LoadSuccess;
  const factory MapState.loadFailure({
    String? failureMessage,
  }) = _LoadFailure;
}
