import 'package:carrot_maps/domain/place/place.dart';
import 'package:carrot_maps/infrastructure/place/place_repository.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carrot_maps/infrastructure/core/firestore_helpers.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final MockFirestoreInstance mockFirestore = MockFirestoreInstance();
  final PlaceRepository placeRepository = PlaceRepository(mockFirestore);

  final Map<String, dynamic> placesJson =
      jsonFixtureAsMap('places.json')["places"] as Map<String, dynamic>;

  final List<Place> places = placesJson.entries
      .map((entry) => Place.fromJson(entry.value as Map<String, dynamic>)
          .copyWith(id: entry.key))
      .toList();

  group('placesStream', () {
    test(
      'should emit Place Entities available from Firestore',
      () async {
        // arrange
        for (final place in places) {
          await mockFirestore.placesCollection
              .doc(place.id)
              .set(place.toJson());
        }
        // act
        expectLater(
          placeRepository.placesStream.map((e) => e.getOrElse(() => [])),
          emits(places),
        );
      },
    );
  });

  group('create', () {
    test(
      'should return unit when no errors happened',
      () async {
        // arrange
        const Place place = Place(name: "Madrid", longitude: 20, latitude: 20);
        // act
        final result = await placeRepository.create(place);
        // assert
        expect(result, const Right(unit));
      },
    );
  });
}
