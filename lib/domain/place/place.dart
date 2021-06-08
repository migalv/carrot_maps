import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';
part 'place.g.dart';

@freezed

/// Data class object that represents a place in a map
class Place with _$Place {
  const factory Place({
    @JsonKey(ignore: true) String? id,

    /// The given name to place
    required String name,

    /// Coordinate for longitude
    required double longitude,

    /// Coordinate for latitude
    required double latitude,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  factory Place.fromFirestore(DocumentSnapshot doc) {
    return Place.fromJson(doc.data()! as Map<String, dynamic>)
        .copyWith(id: doc.id);
  }
}
