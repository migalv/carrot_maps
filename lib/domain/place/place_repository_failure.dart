import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_repository_failure.freezed.dart';

@freezed
class PlaceRepositoryFailure with _$PlaceRepositoryFailure {
  /// Failure when an unexpected error ocurred in the PlaceRepository
  const factory PlaceRepositoryFailure.unexpected() = Unexpected;

  /// Failure when trying to access data without the required permissions
  const factory PlaceRepositoryFailure.insufficientPermissions() =
      InsufficientPermissions;
}
