import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dota2_web/config.dart';
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
                              PlayerWLstat(playerWl: playerWl, label: 'WINRATE', stat: '${(playerWl.win! / (playerWl.lose! + playerWl.win!) * 100).toStringAsFixed(2)} %', statColor: Theme.of(context).primaryColor),
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
                              final finalData = parseAvgMaxData(playerRecentMatches, false).toJson();
                              return Container(
                                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                decoration: const BoxDecoration(
                                    color: Colors.black12,
                                    boxShadow: [BoxShadow(blurRadius: 2, color: Color.fromRGBO(0, 0, 0, .2), spreadRadius: 1)],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(nameDestruct(extraList[index], '_',  0, 'upperCase').toUpperCase(), style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).primaryColor,
                                        
                                      ),),
                                      item == 'winRate' ? Text('${finalData['winRate'] * 100}%'.toUpperCase(), style: TextStyle(
                                            fontSize: 20,
                                            color: Theme.of(context).primaryColor,
                                          ))
                                      :
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(finalData[item]?.average, style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: item == 'kills' ? greenColor : item == 'deaths' ? redColor : lightBlueColor,
                                          )),
                                          const SizedBox(width: 5,),
                                          Text(finalData[item]?.maximums?.max, style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).primaryColor,
                                          )),
                                          const SizedBox(width: 5,),
                                          Container(
                                            width: 25,
                                            height: 25,
                                            color: Colors.transparent,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.transparent,
                                              radius: 100,
                                              backgroundImage: NetworkImage(steamCDN + heroes[finalData[item].maximums.heroId.toString()]['icon']),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
                          final int kdaTotal = kills + deaths + assists;

                            return Container(
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

// calculate win rate
double winRate(List<PlayerRecentMatch> matches) {
    // win: (element.player_slot > 120 && !element.radiant_win) || (element.player_slot <= 120 && element.radiant_win)
    final int winLength = matches.where((PlayerRecentMatch match) => 
      (match.playerSlot! > 120 && !match.radiantWin!) || (match.playerSlot! <= 120 && match.radiantWin!)
    ).length;
    final totalMatchLength = matches.length;
    // console.log(winLength, totalMatchLength);
    return winLength / totalMatchLength;
}

class Maximums {
  int? matchId;
  int? heroId;
  String? max;
  
  Maximums({this.matchId, this.heroId, this.max});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['matchId'] = matchId;
    data['heroId'] = heroId;
    data['max'] = max;
    return data;
  }
}

class FilterData {
  String? average;
  Maximums? maximums;

  FilterData({this.average, this.maximums});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['average'] = average;
    data['maximums'] = maximums;
    return data;
  }
}


class FinalData {
  double? winRate;
  int? length;
  
  FilterData? kills;
  FilterData? deaths;
  FilterData? assists;
  FilterData? gold_per_min;
  FilterData? xp_per_min;
  FilterData? last_hits;
  FilterData? hero_damage;
  FilterData? hero_healing;
  FilterData? tower_damage;
  FilterData? duration;

  FinalData({this.winRate, this.length});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['winRate'] = winRate;
    data['length'] = length;
    data['kills'] = kills;
    data['deaths'] = deaths;
    data['assists'] = assists;
    data['gold_per_min'] = gold_per_min;
    data['xp_per_min'] = xp_per_min;
    data['last_hits'] = last_hits;
    data['hero_damage'] = hero_damage;
    data['hero_healing'] = hero_healing;
    data['tower_damage'] = tower_damage;
    data['duration'] = duration;
    return data;
  }
}

dynamic filterMax(List<PlayerRecentMatch> matches, String field) {
  
    final maximums = Maximums();
    maximums.matchId = null;
    maximums.heroId = null;
    final filterData = FilterData();
    filterData.average = '';
    filterData.maximums = maximums;

    final List<int> matchesMap = matches.map<int>((PlayerRecentMatch match) {
      return match.toJson()[field];
    }).toList();

    final int maxNum = matchesMap.reduce(max).round();
    //   we only need the match_id, hero_id for icon, and field data
    maximums.matchId = matches.firstWhere((PlayerRecentMatch match) => match.toJson()[field] == maxNum).matchId;
    maximums.heroId = matches.firstWhere((PlayerRecentMatch match) => match.toJson()[field] == maxNum).heroId;
    final int average = (matches.map((PlayerRecentMatch match) => match.toJson()[field]).reduce((cur, total) => cur + total) / matches.length).round();
    if (field != 'duration') {
      filterData.average = greaterNum(
        average, 1000, 'k'
      );
      maximums.max = greaterNum(matches.firstWhere((PlayerRecentMatch match) => match.toJson()[field] == maxNum).toJson()[field].round(), 1000, 'k');
    } else if (field == 'duration'){
      filterData.average = duration(average);
      maximums.max = duration(matches.firstWhere((PlayerRecentMatch match) => match.toJson()[field] == maxNum).toJson()[field]);
    } else {
      filterData.average = null;
      maximums.max = null;
    }
    filterData.maximums = maximums;
    return filterData;
  }

  // parse/extra recent matches or matches
  FinalData parseAvgMaxData(List<PlayerRecentMatch> data, bool enableTurbo) {
    if (!enableTurbo) {
      data = data.where((PlayerRecentMatch i) => i.gameMode != 23).toList();
    }
    //   force only analizy the 20 item
    if (data.length > 20) {
      data = data.sublist(0, 20);
    }
    final finalData = FinalData();
    finalData.winRate = winRate(data);
    finalData.length = data.length;
    
    finalData.kills = filterMax(data, 'kills');
    finalData.deaths = filterMax(data, 'deaths');
    finalData.assists = filterMax(data, 'assists');
    finalData.gold_per_min = filterMax(data, 'gold_per_min');
    finalData.xp_per_min = filterMax(data, 'xp_per_min');
    finalData.last_hits = filterMax(data, 'last_hits');
    finalData.hero_damage = filterMax(data, 'hero_damage');
    finalData.hero_healing = filterMax(data, 'hero_healing');
    finalData.tower_damage = filterMax(data, 'tower_damage');
    finalData.duration = filterMax(data, 'duration');

    return finalData;
  }