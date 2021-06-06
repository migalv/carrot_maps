part of 'places_bloc.dart';

@freezed
class PlacesEvent with _$PlacesEvent {
  const factory PlacesEvent.formSubmitted({
    required String name,
    required double longitude,
    required double latitude,
  }) = _FormSubmitted;
}
