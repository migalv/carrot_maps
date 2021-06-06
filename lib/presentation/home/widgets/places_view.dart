import 'package:flutter/material.dart';

class PlacesView extends StatelessWidget {
  const PlacesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
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
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Nombre del lugar",
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Longitud",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Latitud",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("Crear lugar"),
          ),
        ],
      ),
    );
  }
}
