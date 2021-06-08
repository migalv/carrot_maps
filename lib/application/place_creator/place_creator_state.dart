part of 'place_creator_bloc.dart';

@freezed
class PlaceCreatorState with _$PlaceCreatorState {
  const factory PlaceCreatorState.initial() = _Initial;
  const factory PlaceCreatorState.formSubmitionSuccess() =
      _FormSubmitionSuccess;
  const factory PlaceCreatorState.formSubmitionFailure({
    required String failureMessage,
  }) = _FormSubmitionFailure;
}
