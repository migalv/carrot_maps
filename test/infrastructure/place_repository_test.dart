import 'package:carrot_maps/domain/place.dart';
import 'package:carrot_maps/infrastructure/place_repository.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carrot_maps/infrastructure/core/firestore_helpers.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  MockFirestoreInstance mockFirestore = MockFirestoreInstance();
  PlaceRepository placeRepository = PlaceRepository(mockFirestore);

  final Map<String, dynamic> placesJson =
      jsonFixtureAsMap('places.json')["places"] as Map<String, dynamic>;

  final List<Place> places = placesJson.entries
      .map((entry) => Place.fromJson(entry.value).copyWith(id: entry.key))
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
}
