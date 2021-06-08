import 'package:carrot_maps/application/map/map_bloc.dart';
import 'package:carrot_maps/domain/place.dart';
import 'package:carrot_maps/injection.dart';
import 'package:carrot_maps/presentation/home/widgets/thermometer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MapBloc>(),
      child: BlocConsumer<MapBloc, MapState>(
        listener: _blocListener,
        builder: (context, state) {
          List<Place> places = [];
          bool isLoading = false;
          double? temperature;

          state.when(
            initial: () {
              isLoading = false;
            },
            loadInProgress: () {
              isLoading = true;
            },
            loadSuccess: (loadedPlaces, loadedTemperature) {
              isLoading = false;
              temperature = loadedTemperature;
              places = loadedPlaces;
            },
            loadFailure: (failureMessage) {
              isLoading = false;
            },
          );

          return Stack(
            children: [
              _buildMap(context, places),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Thermometer(
                    temperature: temperature,
                    isLoading: isLoading,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMap(BuildContext context, List<Place> places) {
    Set<Marker> markers = {};

    markers = places
        .map(
          (place) => Marker(
            markerId: MarkerId(place.name),
            infoWindow: InfoWindow(title: place.name),
            position: LatLng(place.latitude, place.longitude),
          ),
        )
        .toSet();

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

        context.read<MapBloc>().add(
              MapEvent.loadStarted(
                latitude: _locationData.latitude ?? 0.0,
                longitude: _locationData.longitude ?? 0.0,
              ),
            );

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
  }

  void _blocListener(BuildContext context, MapState state) => state.when(
        initial: () {},
        loadInProgress: () {},
        loadSuccess: (places, temperature) {},
        loadFailure: (failureMessage) =>
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failureMessage ?? "Un error inesperado ocurrió"),
          ),
        ),
      );
}
