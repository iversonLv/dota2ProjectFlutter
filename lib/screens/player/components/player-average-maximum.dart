import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dota2_web/config.dart';

import '../../../models/player_recent_match.dart';
import '../../../shared/app-color.dart';
import '../../../shared/utils.dart';

class PlayerAverageMaximum extends StatelessWidget {
  const PlayerAverageMaximum({
    Key? key,
    required this.item,
    required this.playerRecentMatches,
    required this.heroes,
  }) : super(key: key);
  final String item;
  final List<PlayerRecentMatch> playerRecentMatches;
  final Map<String, dynamic> heroes;

  @override
  Widget build(BuildContext context) {
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
              Text(nameDestruct(item, '_',  0, 'upperCase').toUpperCase(), style: TextStyle(
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