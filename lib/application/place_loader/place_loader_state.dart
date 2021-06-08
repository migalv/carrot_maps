part of 'place_loader_bloc.dart';

@freezed
class PlaceLoaderState with _$PlaceLoaderState {
  const factory PlaceLoaderState.initial() = _Initial;
  const factory PlaceLoaderState.loadSuccess({
    required List<Place> places,
  }) = _LoadSuccess;
  const factory PlaceLoaderState.loadFailure({
    String? failureMessage,
  }) = _LoadFailure;
}
