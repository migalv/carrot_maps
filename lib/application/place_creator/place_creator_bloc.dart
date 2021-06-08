import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carrot_maps/domain/place/i_place_repository.dart';
import 'package:carrot_maps/domain/place/place.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'palce_creator_event.dart';
part 'place_creator_state.dart';
part 'place_creator_bloc.freezed.dart';

@injectable
class PlaceCreatorBloc extends Bloc<PlaceCreatorEvent, PlaceCreatorState> {
  final IPlaceRepository _placeRepository;

  PlaceCreatorBloc(this._placeRepository)
      : super(const PlaceCreatorState.initial());

  @override
  Stream<PlaceCreatorState> mapEventToState(
    PlaceCreatorEvent event,
  ) async* {
    yield* event.map(
      formSubmitted: (event) async* {
        double longitude = 0;
        double latitude = 0;

        try {
          longitude = double.parse(event.longitude);
          latitude = double.parse(event.latitude);

          if (_validateLatLng(latitude, longitude)) {
            yield const PlaceCreatorState.formSubmitionFailure(
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
              yield PlaceCreatorState.formSubmitionFailure(
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
              yield const PlaceCreatorState.formSubmitionSuccess();
            });
          }
        } on FormatException {
          yield const PlaceCreatorState.formSubmitionFailure(
            failureMessage: "Valores incorrectos para longitud y/o latitud",
          );
        }
        yield const PlaceCreatorState.initial();
      },
    );
  }

  bool _validateLatLng(double lat, double long) =>
      long < -180 || long > 180 || lat < -90 || lat > 90;
}
