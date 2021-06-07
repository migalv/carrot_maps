part of 'map_bloc.dart';

@freezed
class MapState with _$MapState {
  const factory MapState.initial() = _Initial;
  const factory MapState.loadSuccess(List<Place> places) = _LoadSuccess;
  const factory MapState.loadFailure(String failureMessage) = _LoadFailure;
}
