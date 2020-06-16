import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final config = {
    "apiKey": Platform.environment['API_KEY'],
    "baseUrl": Platform.environment['BASE_URL']
  };

  final filename = 'lib/.env.dart';
  File(filename).writeAsString('final environment = ${json.encode(config)};');
}
