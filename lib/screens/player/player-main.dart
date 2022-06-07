import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dota2_web/models/player_recent_match.dart';
import 'package:flutter_dota2_web/shared/components/hero-img-tap-info.dart';

// shared
import 'package:flutter_dota2_web/shared/components/rank-tier-icon.dart';
import 'package:flutter_dota2_web/shared/components/tooltip-wrapper.dart';
import 'package:flutter_dota2_web/shared/services.dart';
import 'package:flutter_dota2_web/shared/utils.dart';

// services
import './services.dart';

// models
import '../../models/player.dart';
import '../../models/player_wl.dart';

// constants
import '../../shared/app-color.dart';

// component
import './components/player-avatar.dart';
import 'components/player-wl-stat.dart';


class PlayerMain extends StatefulWidget {
  const PlayerMain({ Key? key }) : super(key: key);

  @override
  _PlayerMainState createState() => _PlayerMainState();
}

class _PlayerMainState extends State<PlayerMain> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          FutureBuilder(
            future: Future.wait([getPlayerData(), getPlayerWLData()]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                      child: Text('Loading...', style: TextStyle(color: Colors.white,)),
                  );
              } else {
                // player data
                final Player player = snapshot.data[0];
                final PlayerWL playerWl = snapshot.data[1];

                return Container(
                  padding: const EdgeInsets.fromLTRB(35, 25, 25, 25),
                  child: Column(
                    children: [
                      Center(
                        // player avatar
                        child: PlayerAvatar(player: player),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // player name and confirmed by
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    player.profile?.name != null ? player.profile?.name as String : player.profile?.personaname as String,
                                    style: TextStyle(
                                    fontSize: 28,
                                    color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 10,),
                          // confirmed by
                          player.profile?.name != null ? TooltipWrapper(
                            message: 'Confirmed by ${player.profile?.name}',
                            child: const Icon(
                              Icons.check_circle_outlined,
                              color: yellowColor,
                              size: 25.0,
                            ),
                          ) : const SizedBox(),
                          const SizedBox(width: 10,),
                          // country
                          player.profile?.loccountrycode != null ?
                          TooltipWrapper(
                            message: player.profile?.loccountrycode as String,
                            child: Image(
                            height: 25,
                            width: 25,
                            image: NetworkImage(
                              'https://community.cloudflare.steamstatic.com/public/images/countryflags/${player.profile?.loccountrycode!.toLowerCase()}.gif',
                              scale: 1
                            ),
                          )) : const SizedBox(),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // player wins stat
                          PlayerWLstat(playerWl: playerWl, label: 'WINS', stat: playerWl.win.toString(), statColor: greenColor),
                          const SizedBox(width: 25,),
                          // player loses stat
                          PlayerWLstat(playerWl: playerWl, label: 'LOSSES', stat: playerWl.lose.toString(), statColor: redColor),
                          const SizedBox(width: 25,),
                          // plaery winrate stat
                          PlayerWLstat(playerWl: playerWl, label: 'WINRATE', stat: '${(playerWl.win! / (playerWl.lose! + playerWl.win!) * 100).toStringAsFixed(2)} %', statColor: Theme.of(context).primaryColor),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        // PLUS
                          player.profile?.plus as bool ? 
                          const TooltipWrapper(
                            message: 'Dota plus subscriber', 
                            child: Image(
                              width: 65,
                              height: 75,
                              image: NetworkImage('https://www.opendota.com/assets/images/dota2/dota_plus_icon.png'),
                            )
                          )
                            : const SizedBox(),
                          const SizedBox(width: 20,),
                          // RankTierIcon
                          RankTierIcon(player: player),
                          const SizedBox(width: 20,),
                        ],

                      )
                    ],
                  ),
                );
              }
            },
          ),
          // playerRecentMatches
          Expanded(
            child: FutureBuilder(
            future: Future.wait([getPlayerReacntMatchData(), getHeroesData(), getGameModesData()]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Center(
                      child: Text('Loading...', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),)),
                  ),
                );
              } else {
                // player matches data
                final List<PlayerRecentMatch> playerRecentMatches = snapshot.data[0];
                // heroes data
                final Map<String, dynamic> heroes = snapshot.data[1];
                // game modes
                final Map<String, dynamic> gameModes = snapshot.data[2];
                return ListView.separated(
                  itemCount: playerRecentMatches.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                   final Map<String, dynamic> hero = heroes[playerRecentMatches[index].heroId.toString()];

                   final int matchDuration = playerRecentMatches[index].duration!;
                   final String side =  playerRecentMatches[index].playerSlot! > 4 ?  'Dire' : 'Radiant';
                   final String gameMode = gameModes[playerRecentMatches[index].gameMode.toString()]['name'];
                   final int startTime = playerRecentMatches[index].startTime! * 1000;
                   final int kills = playerRecentMatches[index].kills!;
                   final int deaths = playerRecentMatches[index].deaths!;
                   final int assists = playerRecentMatches[index].assists!;
                   final int kdaTotal = kills + deaths + assists;

                    return Container(
                      // padding: const EdgeInsets.fromLTRB(40, 30, 20, 5),
                      height: 135,
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Stack(
                        children: [
                          // main container
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width - 70,
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                                boxShadow: [BoxShadow(blurRadius: 2, color: Color.fromRGBO(0, 0, 0, .2), spreadRadius: 1)],
                              ),
                              padding: const EdgeInsets.only(left: 40),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        const SizedBox(height: 5,),
                                        DurationSizeMode(label: 'Duration', data: duration(matchDuration)),
                                        const SizedBox(height: 5,),
                                        DurationSizeMode(label: 'Side', data: side),
                                        const SizedBox(height: 5,),
                                        DurationSizeMode(label: 'Mode', data: nameDestruct(gameMode, '_' , 2, 'upperCase')), 
                                        const SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            KDAText(label: 'K', kda: kills),
                                            KDAText(label: 'D', kda: deaths),
                                            KDAText(label: 'A', kda: assists),
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        // kda
                                        Row(
                                          children: [
                                            KDABar(label: 'K', kdaTotal: kdaTotal, kda: kills ),
                                            KDABar(label: 'D', kdaTotal: kdaTotal, kda: deaths ),
                                            KDABar(label: 'A', kdaTotal: kdaTotal, kda: assists ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  // win lost
                                  const SizedBox(width: 5,),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: win(playerRecentMatches[index].playerSlot, playerRecentMatches[index].radiantWin) ? greenColor : redColor,
                                    ),
                                    width: 20,
                                    alignment: Alignment.center,
                                    child: Text(
                                      win(playerRecentMatches[index].playerSlot, playerRecentMatches[index].radiantWin) ? 'W' : 'L',
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ),
                          ),
                          // hero name
                          Positioned(
                            right: 0,
                            top: 10,
                            left: 85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  hero['localized_name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  ' | ${dateTillToday(startTime).toString()}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  milisecondsToDate(startTime),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            )
                          ),
                          // hero img
                          Positioned(
                            width: 55,
                            height: 55,
                            left: 20,
                            top: 20,
                            child: HeroImgAndTapInfo(hero: hero),
                          ),
                        ],
                        
                      )
                    );
                  }
                );
              }
            }
          ),
          ),
        ],
      )
    );
  }
}

class KDAText extends StatelessWidget {
  const KDAText({
    Key? key,
    required this.label,
    required this.kda,
  }) : super(key: key);

  final String label;
  final int kda;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label: $kda',
      style: TextStyle(
        fontSize: 12,
        color: Theme.of(context).primaryColor,
      )
    );
  }
}

class KDABar extends StatelessWidget {
  const KDABar({
    Key? key,
    required this.label,
    required this.kdaTotal,
    required this.kda,
  }) : super(key: key);

  final String label;
  final int kda;
  final int kdaTotal;

  Color kdaColor(String label) {
    return label == 'K' ? greenColor : label == 'D' ? redColor : lightBlueColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 135) * (kda / kdaTotal),
      height: 10,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kdaColor(label),
      ),
    );
  }
}

class DurationSizeMode extends StatelessWidget {
  const DurationSizeMode({
    Key? key,
    required this.label,
    required this.data,
  }) : super(key: key);

  final String label;
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
        '$label: ',
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).primaryColor,
          )
        ),
        Text(
        data,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).primaryColor,
          )
        ),
      ],
    );
  }
}
