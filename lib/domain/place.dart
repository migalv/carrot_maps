import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';

@freezed

/// Data class object that represents a place in a map
abstract class Place with _$Place {
  const factory Place({
    /// The given name to place
    required String name,

    /// Coordinate for longitude
    required double longitude,

    /// Coordinate for latitude
    required double latitude,
  }) = _Place;
}
