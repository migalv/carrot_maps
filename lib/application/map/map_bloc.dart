import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carrot_maps/domain/i_place_repository.dart';
import 'package:carrot_maps/domain/i_weather_repository.dart';
import 'package:carrot_maps/domain/place.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'map_event.dart';
part 'map_state.dart';
part 'map_bloc.freezed.dart';

@injectable
class MapBloc extends Bloc<MapEvent, MapState> {
  final IPlaceRepository _placeRepository;
  final IWeatherRepository _weatherRepository;

  MapBloc(
    this._placeRepository,
    this._weatherRepository,
  ) : super(const _Initial());

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    yield* event.when(loadStarted: (latitude, longitude) async* {
      yield const MapState.loadInProgress();

      final failureOrTemperature =
          await _weatherRepository.getTemperatureForCoordinates(
        latitude: latitude,
        longitude: longitude,
      );

      final temperature = failureOrTemperature.getOrElse(() => 0.0);

      yield* _placeRepository.placesStream.map(
        (failureOrPlaces) => failureOrPlaces.fold(
          (failure) => MapState.loadFailure(
            failureMessage: failure.when(
              unexpected: () => "Ocurrió un error inesperado",
              insufficientPermissions: () =>
                  "Usuario sin los permisos necesarios",
            ),
          ),
          (places) => MapState.loadSuccess(
            places: places,
            temperature: temperature,
          ),
        ),
      );
    });
  }
}
