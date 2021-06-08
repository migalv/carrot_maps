import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carrot_maps/domain/i_place_repository.dart';
import 'package:carrot_maps/domain/place.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'places_event.dart';
part 'places_state.dart';
part 'places_bloc.freezed.dart';

@injectable
class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final IPlaceRepository _placeRepository;

  PlacesBloc(this._placeRepository) : super(const PlacesState.initial());

  @override
  Stream<PlacesState> mapEventToState(
    PlacesEvent event,
  ) async* {
    yield* event.map(
      formSubmitted: (event) async* {
        double longitude = 0;
        double latitude = 0;

        try {
          longitude = double.parse(event.longitude);
          latitude = double.parse(event.latitude);

          if (_validateLatLng(latitude, longitude)) {
            yield const PlacesState.formSubmitionFailure(
              failureMessage: "Valores incorrectos para longitud y/o latitud",
            );
          } else {
            final Place newPlace = Place(
              name: event.name,
              longitude: longitude,
              latitude: latitude,
            );
            final result = await _placeRepository.create(newPlace);

            yield* result.fold((l) async* {
              yield PlacesState.formSubmitionFailure(
                failureMessage: l.when(
                  unexpected: () {
                    return "Ocurrió un error inesperado";
                  },
                  insufficientPermissions: () {
                    return "Usuario no tiene los permisos necesarios";
                  },
                ),
              );
            }, (r) async* {
              yield const PlacesState.formSubmitionSuccess();
            });
          }
        } on FormatException {
          yield const PlacesState.formSubmitionFailure(
            failureMessage: "Valores incorrectos para longitud y/o latitud",
          );
        }
        yield const PlacesState.initial();
      },
    );
  }

  bool _validateLatLng(double lat, double long) =>
      long < -180 || long > 180 || lat < -90 || lat > 90;
}
