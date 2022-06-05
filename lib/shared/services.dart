import 'dart:convert';

import 'package:http/http.dart' as http;

// config
import '../../config.dart';

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