import 'package:carrot_maps/application/place_loader/place_loader_bloc.dart';
import 'package:carrot_maps/application/weather/weather_bloc.dart';
import 'package:carrot_maps/injection.dart';
import 'package:carrot_maps/presentation/home/widgets/map_widget.dart';
import 'package:carrot_maps/presentation/home/widgets/thermometer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) {
          final PlaceLoaderBloc placeLoaderBloc = getIt<PlaceLoaderBloc>();
          return placeLoaderBloc..add(const PlaceLoaderEvent.loadStarted());
        }),
        BlocProvider(create: (_) => getIt<WeatherBloc>()),
      ],
      child: Stack(
        children: const [
          MapWidget(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Thermometer(),
            ),
          ),
        ],
      ),
    );
  }
}
