import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// config
import '../../config.dart';

// local json
// game mode
Future<Object> getGameModesData() async {
  final String response = await rootBundle.loadString('assets/data/game-mode.json');
  final data = await json.decode(response);
  return data;
}

// land role
Future<Object> getLandRoleData() async {
  final String response = await rootBundle.loadString('assets/data/land_role.json');
  final data = await json.decode(response);
  return data;
}

// getHeroesData
Future<Map<String, dynamic>> getHeroesData() async {
  var url = Uri.https(baseApiUrl, 'api/constants/heroes', {});
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data;
  } else {
    return throw Exception('Failed to load post!');
  }
}

// https://api.opendota.com/api/constants/region
Future<Map<String, dynamic>> getRegionData() async {
  var url = Uri.https(baseApiUrl, 'api/constants/region', {});
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data;
  } else {
    return throw Exception('Failed to load post!');
  }
}

// https://api.opendota.com/api/constants/patch
Future<List<dynamic>> getPatchData() async {
  var url = Uri.https(baseApiUrl, 'api/constants/patch', {});
  var response = await http.get(url);
  if (response.statusCode == 200) {
    List<dynamic> raw = jsonDecode(response.body) as List;
    var data = raw.map((f) => f).toList();
    return data;
  } else {
    return throw Exception('Failed to load post!');
  }
}