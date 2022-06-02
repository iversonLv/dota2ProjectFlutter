import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './models/player.dart';
import './models/player_wl.dart';
import './utils.dart';

const baseApiUrl = 'api.opendota.com';
const playerId = 128741677;  //topson 94054712
//128741677

const greenColor = Color.fromRGBO(102, 187, 106, 1);
const redColor = Color.fromRGBO(255, 76, 76, 1);
const yellowColor = Color.fromRGBO(201, 175, 29, 1);
const lightBlueColor = Color.fromRGBO(124, 153, 168, 1);
const lightYellowColor = Color.fromRGBO(236, 217, 200, 1);

ThemeData _customTheme() {
  return ThemeData(
    primaryColor: const Color.fromRGBO(245, 245, 245, .87),
    scaffoldBackgroundColor: const Color.fromRGBO(25, 32, 35, 1),
    backgroundColor: const Color.fromRGBO(14, 84, 113, .37),
    cardColor: const Color(0xFF883B2D),
    textSelectionTheme: const TextSelectionThemeData(
    selectionColor: Color(0xFFFEDBD0),
    ),
    errorColor: Colors.red,
    buttonTheme: ThemeData.light().buttonTheme.copyWith(
    buttonColor: const Color(0xFFFEDBD0),
    colorScheme: ThemeData.light().colorScheme.copyWith(
      secondary: const Color.fromRGBO(14, 84, 113, 0.37),
      ),
    ),
    buttonBarTheme: ThemeData.light().buttonBarTheme.copyWith(
    buttonTextTheme: ButtonTextTheme.accent,
    ),
    primaryIconTheme: ThemeData.light().primaryIconTheme.copyWith(
    color: const Color.fromRGBO(245, 245, 245, .87),
    ),
  );
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Love Dota2',
      theme: _customTheme(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // getPlayData
  Future<Player> getPlayData() async {
    var url = Uri.https(baseApiUrl, 'api/players/$playerId', {});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = Player.fromJson(jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Failed to load post!');
    }
  }
  Future<PlayerWL> getPlayWLData() async {
    var url = Uri.https(baseApiUrl, 'api/players/$playerId/wl', {});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = PlayerWL.fromJson(jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Failed to load post!');
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder(
      future: Future.wait([getPlayData(), getPlayWLData()]),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Container(
            color: Theme.of(context).backgroundColor,
            child: const Center(
                child: Text('Loading...', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),)),
            ),
          );
        } else {
          final Player player = snapshot.data[0];
          final PlayerWL playerWl = snapshot.data[1];
          return Container(
            padding: const EdgeInsets.fromLTRB(35, 25, 25, 25),
            color: Theme.of(context).backgroundColor,
            child: Column(
              children: [
                Center(
                  child: PlayerAvatar(player: player),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      player.profile?.name != null ? player.profile?.name as String : player.profile?.personaname as String,
                      style: TextStyle(
                      fontSize: 28,
                      color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 10,),
                    player.profile?.name != null ? Tooltip(
                      padding: const EdgeInsets.all(5.0),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      preferBelow: false,
                      textStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor
                      ),
                      message: 'Confirmed by ${player.profile?.name}',
                      child: const Icon(
                        Icons.check_circle_outlined,
                        color: yellowColor,
                        size: 25.0,
                      ),
                    ) : const SizedBox()
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Column(
                    children: [
                      const Text(
                        'WINS',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(255, 255, 255, .54),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(playerWl.win.toString(), style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: greenColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Column(
                    children: [
                      const Text('LOSSES',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(255, 255, 255, .54),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(playerWl.lose.toString(), style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: redColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Column(
                    children: [
                      const Text('WINRATE',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(255, 255, 255, .54),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('${(playerWl.win! / (playerWl.lose! + playerWl.win!) * 100).toStringAsFixed(2)} %',  style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  // PLUS
                  player.profile?.plus as bool ? 
                    Tooltip (
                      padding: const EdgeInsets.all(5.0),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      preferBelow: false,
                      textStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor
                      ),
                      message: 'Dota plus subscriber',
                      child: const Image(
                        width: 65,
                        height: 75,
                        image: NetworkImage('https://www.opendota.com/assets/images/dota2/dota_plus_icon.png'),
                      ),
                  ) : const SizedBox(),
                  const SizedBox(width: 20,),
                  // Rate
                    Tooltip(
                      padding: const EdgeInsets.all(5.0),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      preferBelow: false,
                      textStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor
                      ),
                      message: rankTierPipe(player.rankTier),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Rank stars number
                          player.rankTier != null && player.rankTier.toString()[1] != '0' ? Image(
                            height: 124,
                            width: 124,
                            image: NetworkImage(
                              'https://www.opendota.com/assets/images/dota2/rank_icons/rank_star_${player.rankTier.toString()[1]}.png',
                              scale: 1
                            ),
                          ) : const SizedBox(width: 0),
                          // Rank icon
                          Image(
                            height: 124,
                            width: 124,
                            image: NetworkImage('https://www.opendota.com/assets/images/dota2/rank_icons/rank_icon_${player.rankTier != null ? player.rankTier.toString()[0] : "0"}${player.leaderboardRank != null && player.leaderboardRank! >= 1  &&  player.leaderboardRank! <= 10 ? "c" : (player.leaderboardRank != null &&  player.leaderboardRank!  <=100 && player.leaderboardRank! > 10 ? "b" : "")}.png'),
                          ),
                          // Rank number if not null
                          Positioned(
                            bottom: 8,
                            child: Text(
                              player.leaderboardRank != null ? player.leaderboardRank.toString() : '',
                              style: 
                                const TextStyle(
                                  fontSize: 22,
                                  color: lightYellowColor
                                ),
                              ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20,),
                  ],

                )
              ],
            ),
          );
        }
      },
      )
    );
  }
}

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    Key? key,
    required this.player,
  }) : super(key: key);

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 124,
      height: 124,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(blurRadius: 15, color: Color.fromRGBO(0, 0, 0, .4), spreadRadius: 2)],
      ),
      child: CircleAvatar(
        radius: 100,
        backgroundImage: NetworkImage(player.profile?.avatarfull as String),
      ),
    );
  }
}
