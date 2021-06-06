import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carrot_maps/domain/failures/place_repository_failure.dart';
import 'package:carrot_maps/domain/i_place_repository.dart';
import 'package:carrot_maps/domain/place.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'places_event.dart';
part 'places_state.dart';
part 'places_bloc.freezed.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final IPlaceRepository _placeRepository;

  PlacesBloc(this._placeRepository) : super(const PlacesState.initial());

  @override
  Stream<PlacesState> mapEventToState(
    PlacesEvent event,
  ) async* {
    event.map(formSubmitted: (event) async* {
      Place newPlace = Place(
        name: event.name,
        longitude: event.longitude,
        latitude: event.latitude,
      );
      final result = await _placeRepository.create(newPlace);

      yield* result.fold((l) async* {
        yield PlacesState.formSubmitionFailure(failure: l);
      }, (r) async* {
        yield PlacesState.formSubmitionSuccess();
        yield PlacesState.initial();
      });
    });
  }
}
