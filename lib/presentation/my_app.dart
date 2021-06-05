import 'package:carrot_maps/presentation/home/home_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carrot Maps',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}
