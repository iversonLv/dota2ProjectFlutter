import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// config
import '../../config.dart';

// local json
Future<Object> getGameModesData() async {
  final String response = await rootBundle.loadString('data/game-mode.json');
  final data = await json.decode(response);
  return data;
}

// getHeroesData
Future<Object> getHeroesData() async {
  var url = Uri.https(baseApiUrl, 'api/constants/heroes', {});
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data;
  } else {
    return throw Exception('Failed to load post!');
  }
}
