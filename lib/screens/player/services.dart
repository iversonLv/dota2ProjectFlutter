import 'package:http/http.dart' as http;
import 'dart:convert';

// config
import '../../config.dart';

// models
import '../../models/player.dart';
import '../../models/player_recent_match.dart';
import '../../models/player_wl.dart';

// getPlayerData
Future<Player> getPlayerData() async {
    var url = Uri.https(baseApiUrl, 'api/players/$playerId', {});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = Player.fromJson(jsonDecode(response.body));
      return data;
    } else {
      return throw Exception('Failed to load post!');
    }
  }

// getPlayerWLData
Future<PlayerWL> getPlayerWLData() async {
  var url = Uri.https(baseApiUrl, 'api/players/$playerId/wl', {});
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var data = PlayerWL.fromJson(jsonDecode(response.body));
    return data;
  } else {
    return throw Exception('Failed to load post!');
  }
}

// getPlayerRecentMatchData
Future<List<PlayerRecentMatch>> getPlayerReacntMatchData() async {
  var url = Uri.https(baseApiUrl, 'api/players/$playerId/recentMatches', {});
  var response = await http.get(url);
  if (response.statusCode == 200) {
    List<dynamic> raw = jsonDecode(response.body) as List;
    var data = raw.map((f) => PlayerRecentMatch.fromJson(f)).toList();
    return data;
  } else {
    return throw Exception('Failed to load post!');
  }
}

// getPlayerCount
Future<Map<String, dynamic>> getPlayerCountData() async {
  var url = Uri.https(baseApiUrl, 'api/players/$playerId/counts', {});
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data;
  } else {
    return throw Exception('Failed to load post!');
  }
}