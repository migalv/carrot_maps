part of 'place_loader_bloc.dart';

@freezed
class PlaceLoaderEvent with _$PlaceLoaderEvent {
  const factory PlaceLoaderEvent.loadStarted() = _LoadStarted;
}
