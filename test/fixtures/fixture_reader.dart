import 'dart:convert';
import 'dart:io';

/// Reads from the 'test/fixtures/' folder the given File path and returns a string
String stringFixture(String filePath) =>
    File('test/fixtures/$filePath').readAsStringSync();

/// Reads from the 'test/fixtures/' folder the given JSON File path and returns a List
///
/// It decodes the read string using jsonDecode and casts it into a List
List jsonFixtureAsList(String filePath) {
  final String jsonString = stringFixture(filePath);

  final List json = jsonDecode(jsonString) as List;

  return json;
}

/// Reads from the 'test/fixtures/' folder the given JSON File path and returns a Map
///
/// It decodes the read string using jsonDecode and casts it into a Map
Map<String, dynamic> jsonFixtureAsMap(String filePath) {
  final String jsonString = stringFixture(filePath);

  final Map<String, dynamic> json =
      jsonDecode(jsonString) as Map<String, dynamic>;

  return json;
}
