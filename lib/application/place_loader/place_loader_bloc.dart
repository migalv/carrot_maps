import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carrot_maps/domain/place/i_place_repository.dart';
import 'package:carrot_maps/domain/place/place.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'place_loader_event.dart';
part 'place_loader_state.dart';
part 'place_loader_bloc.freezed.dart';

@injectable
class PlaceLoaderBloc extends Bloc<PlaceLoaderEvent, PlaceLoaderState> {
  final IPlaceRepository _placeRepository;

  PlaceLoaderBloc(this._placeRepository) : super(const _Initial());

  @override
  Stream<PlaceLoaderState> mapEventToState(
    PlaceLoaderEvent event,
  ) async* {
    yield* event.when(
      loadStarted: () async* {
        yield* _placeRepository.placesStream.map(
          (failureOrPlaces) => failureOrPlaces.fold(
            (failure) => PlaceLoaderState.loadFailure(
              failureMessage: failure.when(
                unexpected: () => "Ocurrió un error inesperado",
                insufficientPermissions: () =>
                    "Usuario sin los permisos necesarios",
              ),
            ),
            (places) => PlaceLoaderState.loadSuccess(
              places: places,
            ),
          ),
        );
      },
    );
  }
}
