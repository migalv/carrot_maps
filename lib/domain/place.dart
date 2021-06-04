import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';

@freezed
abstract class Place with _$Place {
  const factory Place({
    required String name,
    required double longitude,
    required double latitude,
  }) = _Place;
}
