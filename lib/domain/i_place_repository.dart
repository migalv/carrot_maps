import 'package:carrot_maps/domain/failures/place_repository_failure.dart';
import 'package:carrot_maps/domain/place.dart';
import 'package:dartz/dartz.dart';

/// Specifies a contract for a repository that handles Places
abstract class IPlaceRepository {
  /// Returns a stream with a list of places saved by the user
  Stream<Either<PlaceRepositoryFailure, List<Place>>> get placesStream;

  /// Creates a place at the server
  Future<Either<PlaceRepositoryFailure, Unit>> create(Place place);
}
