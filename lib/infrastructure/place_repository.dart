import 'package:carrot_maps/domain/failures/place_repository_failure.dart';
import 'package:carrot_maps/domain/i_place_repository.dart';
import 'package:carrot_maps/domain/place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carrot_maps/infrastructure/core/firestore_helpers.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

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
        const failure = const PlaceRepositoryFailure.insufficientPermissions();
        return left(failure);
      } else {
        const failure = const PlaceRepositoryFailure.unexpected();
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

      final failure = PlaceRepositoryFailure.unexpected();
      return left(failure);
    });
  }
}
