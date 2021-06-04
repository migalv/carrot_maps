import 'package:carrot_maps/domain/failures/place_repository_failure.dart';
import 'package:carrot_maps/domain/i_place_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:carrot_maps/domain/place.dart';

class PlaceRepository implements IPlaceRepository {
  @override
  Future<Either<PlaceRepositoryFailure, Unit>> create(Place place) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  // TODO: implement placeStream
  Stream<Either<PlaceRepositoryFailure, List<Place>>> get placeStream =>
      throw UnimplementedError();
}
