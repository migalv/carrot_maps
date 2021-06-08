import 'package:carrot_maps/application/place_loader/place_loader_bloc.dart';
import 'package:carrot_maps/application/weather/weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<PlaceLoaderBloc, PlaceLoaderState>(
          listener: _blocListener,
          builder: (context, state) {
            Set<Marker> markers = {};

            state.when(
              initial: () {},
              loadSuccess: (places) {
                markers = places
                    .map(
                      (place) => Marker(
                        markerId: MarkerId(place.name),
                        infoWindow: InfoWindow(title: place.name),
                        position: LatLng(place.latitude, place.longitude),
                      ),
                    )
                    .toSet();
              },
              loadFailure: (failureMessage) {},
            );

            return GoogleMap(
              initialCameraPosition: const CameraPosition(target: LatLng(0, 0)),
              markers: markers,
              onMapCreated: (controller) async {
                bool _serviceEnabled;
                PermissionStatus _permissionGranted;
                LocationData _locationData;
                final Location location = Location();

                _serviceEnabled = await location.serviceEnabled();
                if (!_serviceEnabled) {
                  _serviceEnabled = await location.requestService();
                  if (!_serviceEnabled) {
                    return;
                  }
                }

                _permissionGranted = await location.hasPermission();
                if (_permissionGranted == PermissionStatus.denied) {
                  _permissionGranted = await location.requestPermission();
                  if (_permissionGranted != PermissionStatus.granted) {
                    return;
                  }
                }

                _locationData = await location.getLocation();

                context.read<PlaceLoaderBloc>().add(
                      const PlaceLoaderEvent.loadStarted(),
                    );

                context.read<WeatherBloc>().add(WeatherEvent.locationFetched(
                      latitude: _locationData.latitude,
                      longitude: _locationData.longitude,
                    ));

                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        _locationData.latitude ?? 0,
                        _locationData.longitude ?? 0,
                      ),
                      zoom: 10,
                    ),
                  ),
                );
              },
            );
          });

  void _blocListener(BuildContext context, PlaceLoaderState state) =>
      state.when(
        initial: () {},
        loadSuccess: (places) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("${places.length} lugares cargados satisfactoriamente"),
          ),
        ),
        loadFailure: (failureMessage) =>
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failureMessage ?? "Un error inesperado ocurrió"),
          ),
        ),
      );
}
