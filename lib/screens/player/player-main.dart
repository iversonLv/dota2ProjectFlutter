import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dota2_web/screens/player/components/player-win-count.dart';

// shared
import 'package:flutter_dota2_web/shared/components/rank-tier-icon.dart';
import 'package:flutter_dota2_web/shared/components/tooltip-wrapper.dart';
import 'package:flutter_dota2_web/shared/services.dart';

// services
import '../../shared/utils.dart';
import './services.dart';

// models
import '../../models/player.dart';
import '../../models/player_wl.dart';

// constants
import '../../shared/app-color.dart';

// component
import './components/player-avatar.dart';
import 'components/player-recent-match.dart';
import 'components/player-wl-stat.dart';
import 'package:flutter_dota2_web/models/player_recent_match.dart';
import 'package:flutter_dota2_web/screens/player/components/player-average-maximum.dart';

final List<String> extraList = ['winRate','kills','deaths','assists','gold_per_min','xp_per_min','last_hits','hero_damage','hero_healing','tower_damage', 'duration'];
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

  final ScrollController controllerAverageData = ScrollController();
  final ScrollController controllerRecentMatched = ScrollController();

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
                  padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
                  decoration: const BoxDecoration(
                    boxShadow: [BoxShadow(blurRadius: 2, color: Color.fromRGBO(0, 0, 0, .2), spreadRadius: 1, offset: Offset(0.0, 0.75))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PlayerAvatar(player: player),
                      const SizedBox(width: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // player name and confirmed by
                          Row(
                            children: [
                              Text(
                                player.profile?.name != null ? player.profile?.name as String : player.profile?.personaname as String,
                                style: TextStyle(
                                fontSize: 22,
                                color: Theme.of(context).primaryColor,
                                ),
                              ),
                            const SizedBox(width: 5,),
                            // confirmed by
                            player.profile?.name != null ? TooltipWrapper(
                                message: 'Confirmed by ${player.profile?.name}',
                                child: const Icon(
                                  Icons.check_circle_outlined,
                                  color: yellowColor,
                                  size: 25.0,
                                ),
                              ) : const SizedBox(),
                              const SizedBox(width: 5,),
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
                              const SizedBox(width: 5,),
                              // PLUS
                              player.profile?.plus as bool ? 
                              const TooltipWrapper(
                                message: 'Dota plus subscriber', 
                                child: Image(
                                  width: 25,
                                  height: 25,
                                  image: NetworkImage('https://www.opendota.com/assets/images/dota2/dota_plus_icon.png'),
                                )
                              )
                                : const SizedBox(),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // player wins stat
                              PlayerWLstat(playerWl: playerWl, label: 'WINS', stat: playerWl.win.toString(), statColor: greenColor),
                              const SizedBox(width: 10,),
                              // player loses stat
                              PlayerWLstat(playerWl: playerWl, label: 'LOSSES', stat: playerWl.lose.toString(), statColor: redColor),
                              const SizedBox(width: 10,),
                              // plaery winrate stat
                              PlayerWLstat(playerWl: playerWl, label: 'WINRATE', stat: '${(playerWl.win! / (playerWl.lose! + playerWl.win!) * 100).toStringAsFixed(2)} %', statColor: calColor(playerWl.win, playerWl.lose! + playerWl.win!)),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      // RankTierIcon
                      RankTierIcon(player: player),
                    ],
                  ),
                );
              }
            },
          ),
          // playerRecentMatches and average
          Expanded(
            child: FutureBuilder(
            future: Future.wait([
              getGameModesData(),
              getLandRoleData(),
              getHeroesData(),
              getRegionData(),
              getPatchData(),
              getPlayerReacntMatchData(),
              getPlayerCountData()
            ]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Center(
                      child: Text('Loading...', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),)),
                  ),
                );
              } else {
                // data from API or local json
                // game modes
                final Map<String, dynamic> gameModes = snapshot.data[0];
                // land roles
                final Map<String, dynamic> landRole = snapshot.data[1];
                // heroes data
                final Map<String, dynamic> heroes = snapshot.data[2];
                // region
                final Map<String, dynamic> region = snapshot.data[3]; 
                // patch
                final List<dynamic> patch = snapshot.data[4];
                // player matches data
                final List<PlayerRecentMatch> playerRecentMatches = snapshot.data[5];
                // player count
                final Map<String, dynamic> playerCounts = extractCountData(snapshot.data[6]);
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5,),
                    Text(
                      '  Averages/Maximumsin last 20 displayed matches',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                        
                      )
                    ),
                    const SizedBox(height: 5,),
                    SizedBox(
                      height: 70,
                      child: 
                      ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        }),
                        child: ListView.separated(
                            controller: controllerAverageData,
                            separatorBuilder: (context, index) => const SizedBox(
                              width: 2,
                            ),
                            itemCount: extraList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              final item = extraList[index];
                              return PlayerAverageMaximum(item: item, playerRecentMatches: playerRecentMatches, heroes: heroes);
                            }
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      '  Count win %',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                        
                      )
                    ),
                    const SizedBox(height: 5,),
                    SizedBox(
                      height: 50,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        }),
                        child: ListView.separated(
                            controller: controllerAverageData,
                            separatorBuilder: (context, index) => const SizedBox(
                              width: 2,
                            ),
                            itemCount: playerCounts.keys.toList().length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              final List<dynamic> playerCountsListArr = playerCounts.values.toList();
                              return PlayerWinCount(
                                playerCountsListArr: playerCountsListArr[index],
                                gameModes: gameModes,
                                landRole: landRole,
                                region: region,
                                patch: patch
                              );
                            }
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      '  Recent Matches',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                        
                      )
                    ),
                    const SizedBox(height: 5,),
                    // recent matches
                    Expanded(
                      child: 
                      ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        }),
                        child: ListView.separated(
                          controller: controllerRecentMatched,
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
                          final int playerSlot  = playerRecentMatches[index].playerSlot!;
                          final bool radiantWin = playerRecentMatches[index].radiantWin!;

                            return PlayerRecentMatchContainer(
                              matchDuration: matchDuration,
                              side: side,
                              gameMode: gameMode,
                              startTime: startTime,
                              kills: kills,
                              deaths: deaths,
                              assists: assists,
                              playerSlot: playerSlot,
                              radiantWin: radiantWin,
                              hero: hero,
                            );
                          }
                        ),
                      ),
                    ),
                  ],
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

