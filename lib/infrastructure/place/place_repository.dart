import 'package:carrot_maps/domain/place/i_place_repository.dart';
import 'package:carrot_maps/domain/place/place.dart';
import 'package:carrot_maps/domain/place/place_repository_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carrot_maps/infrastructure/core/firestore_helpers.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IPlaceRepository)
class PlaceRepository implements IPlaceRepository {
  final FirebaseFirestore _firestore;

  /// Repository that handles Places from Cloud Firestore
  PlaceRepository(this._firestore);

  @override
  Future<Either<PlaceRepositoryFailure, Unit>> create(Place place) async {
    try {
      await _firestore.placesCollection.add(place.toJson());

      return right(unit);
    } on PlatformException catch (e) {
      if ((e.message ?? '').contains('PERMISSION_DENIED')) {
        const failure = PlaceRepositoryFailure.insufficientPermissions();
        return left(failure);
      } else {
        const failure = PlaceRepositoryFailure.unexpected();
        return left(failure);
      }
    }
  }

  @override
  Stream<Either<PlaceRepositoryFailure, List<Place>>> get placesStream async* {
    yield* _firestore.placesCollection.snapshots().map((snapshot) {
      return right<PlaceRepositoryFailure, List<Place>>(
          snapshot.docs.map((doc) => Place.fromFirestore(doc)).toList());
    }).handleError((e) {
      if (e is PlatformException &&
          (e.message ?? '').contains('PERMISSIONS_DENIED')) {
        const failure = PlaceRepositoryFailure.insufficientPermissions();
        return left(failure);
      }

      const failure = PlaceRepositoryFailure.unexpected();
      return left(failure);
    });
  }
}
