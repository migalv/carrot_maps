part of 'place_creator_bloc.dart';

@freezed
class PlaceCreatorEvent with _$PlaceCreatorEvent {
  const factory PlaceCreatorEvent.formSubmitted({
    required String name,
    required String longitude,
    required String latitude,
  }) = _FormSubmitted;
}
