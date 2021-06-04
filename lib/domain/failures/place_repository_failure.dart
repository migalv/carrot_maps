import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_repository_failure.freezed.dart';

@freezed
abstract class PlaceRepositoryFailure with _$PlaceRepositoryFailure {
  /// Failure when an unexpected exception is thrown in the PlaceRepository
  const factory PlaceRepositoryFailure.unexpectedException({
    required Exception exception,
    required StackTrace stackTrace,
  }) = UnexpectedException;
}
