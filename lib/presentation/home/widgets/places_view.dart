import 'package:carrot_maps/application/places/places_bloc.dart';
import 'package:carrot_maps/injection.dart';
import 'package:carrot_maps/presentation/themes/carrot_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlacesView extends StatefulWidget {
  const PlacesView({Key? key}) : super(key: key);

  @override
  _PlacesViewState createState() => _PlacesViewState();
}

class _PlacesViewState extends State<PlacesView> {
  final _nameController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _latitudeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PlacesBloc>(),
      child: BlocConsumer<PlacesBloc, PlacesState>(
        listener: _blocListener,
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    "Introduce los detalles del nuevo lugar",
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Nombre del lugar",
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Introduce un nombre';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _longitudeController,
                    decoration: const InputDecoration(
                      labelText: "Longitud",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Introduce una longitud';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _latitudeController,
                    decoration: const InputDecoration(
                      labelText: "Latitud",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Introduce una latitud';
                      }
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      _submitForm(context);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(accentColor),
                  ),
                  child: const Text("Crear lugar"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _blocListener(BuildContext context, PlacesState state) => state.when(
        initial: () {},
        formSubmitionSuccess: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Lugar creado satisfactoriamente!"),
          ),
        ),
        formSubmitionFailure: (failure) =>
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure),
          ),
        ),
      );

  void _submitForm(BuildContext context) {
    final event = PlacesEvent.formSubmitted(
      name: _nameController.text,
      longitude: _longitudeController.text,
      latitude: _latitudeController.text,
    );

    context.read<PlacesBloc>().add(event);
  }
}
