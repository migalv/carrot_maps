import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class InjectableModules {
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @Named("OpenWeatherBaseUrl")
  String get openWeatherBaseUrl => "http://api.openweathermap.org";

  @lazySingleton
  Dio dio(@Named('OpenWeatherBaseUrl') String url) =>
      Dio(BaseOptions(baseUrl: url));
}
