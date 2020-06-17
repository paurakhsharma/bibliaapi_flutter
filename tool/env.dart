import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  var apiKey = Platform.environment['API_KEY'];
  var baseUrl = Platform.environment['BASE_URL'];
  if (apiKey == null)
    throw Exception('Environment key not found: Make sure environment variable API_KEY is set');
  if (apiKey == null)
    throw Exception('Environment key not found: Make sure environment variable BASE_URL is set');
  final config = {
    "apiKey": apiKey,
    "baseUrl": baseUrl
  };

  final filename = 'lib/.env.dart';
  File(filename).writeAsString('final environment = ${json.encode(config)};');
}
