import 'package:http/http.dart' as http;
import 'dart:convert';

// config
import '../../config.dart';

// models
import '../../models/player.dart';
import '../../models/player_wl.dart';

// getPlayData
Future<Player> getPlayData() async {
    var url = Uri.https(baseApiUrl, 'api/players/$playerId', {});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = Player.fromJson(jsonDecode(response.body));
      return data;
    } else {
      return throw Exception('Failed to load post!');
    }
  }

// getPlayWLData
Future<PlayerWL> getPlayWLData() async {
  var url = Uri.https(baseApiUrl, 'api/players/$playerId/wl', {});
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var data = PlayerWL.fromJson(jsonDecode(response.body));
    return data;
  } else {
    return throw Exception('Failed to load post!');
  }
}