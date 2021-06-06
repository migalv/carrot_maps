part of 'places_bloc.dart';

@freezed
class PlacesState with _$PlacesState {
  const factory PlacesState.initial() = _Initial;
  const factory PlacesState.formSubmitionSuccess() = _FormSubmitionSuccess;
  const factory PlacesState.formSubmitionFailure({
    required String failureMessage,
  }) = _FormSubmitionFailure;
}
