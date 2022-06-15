import 'package:flutter/material.dart';
import 'package:flutter_dota2_web/shared/app-color.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/utils.dart';

class PlayerWinCount extends StatelessWidget {
  const PlayerWinCount({
    Key? key,
    required this.playerCountsListArr,
    required this.gameModes,
    required this.landRole,
    required this.region,
    required this.patch,
  }) : super(key: key);

  final List<dynamic> playerCountsListArr;
  final Map<String, dynamic> gameModes;
  final Map<String, dynamic> landRole;
  final Map<String, dynamic> region;
  final List<dynamic> patch;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 230,
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: const BoxDecoration(
            color: Colors.black12,
            boxShadow: [BoxShadow(blurRadius: 2, color: Color.fromRGBO(0, 0, 0, .2), spreadRadius: 1)],
          ),
        child: 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for(var i in playerCountsListArr)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(countWinLabelExtract(i['id'], i['label'], gameModes, landRole, region, patch).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(greaterNum(i['win'], 1000, 'k'), style: const TextStyle(
                              fontSize: 10,
                              color: greenColor,
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Container(
                            color: calColor(i['win'], i['games']),
                            height: 15,
                            width: (100 * (i['win'] / i['games'])).round().toDouble(),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${(i['win'] / i['games'] * 100).round()}%', 
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).primaryColor,
                                    ),),
                                  Text('W',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                          ),
                          const SizedBox(width: 5,),
                          Text(greaterNum(i['games'] - i['win'], 1000, 'k'),style: const TextStyle(
                              fontSize: 10,
                              color: redColor,
                            ),),
                        ],
                      ),
                    ],
                  ),
                )
              ]
                
            )
      );
  }
}

String countWinLabelExtract(
  String id,
  String label,
  Map<String, dynamic> gameModes,
  Map<String, dynamic> landRole,
  Map<String, dynamic> region,
  List<dynamic> patch) {
  final String finalLabel;
  if (label == 'game_mode') {
    finalLabel = nameDestruct(gameModes[id]['name'], '_' , 2, 'upperCase');
  } else if (label == 'lane_role') {
    finalLabel = nameDestruct(landRole[id]['name'], '_' , 2, 'upperCase');
  } else if (label == 'region') {
    finalLabel = region[id];
  } else if (label == 'patch') {
    finalLabel = patch.firstWhere((i) => i['id'].toString() == id)['name'];
  } else {
    if (id == '0') {
      finalLabel = 'DIRE';
    } else {
      finalLabel = 'RADIANT';
    }
  }
  return finalLabel;
}

Map<String, dynamic> extractCountData(Map<String, dynamic> dataIn) {
  final countDataKeyArr = dataIn.keys.where((i) => i != 'leaver_status' && i != 'lobby_type').toList();
  final  playersCountsDestructData = {
    'is_radiant': [],
    'game_mode': [],
    'patch': [],
    'lane_role': [],
    'region': []
  };
  for (var value in countDataKeyArr) {
    final dataInKeyArr = dataIn[value]?.keys.toList();
    for (var key in dataInKeyArr!){
        playersCountsDestructData[value]!.add({
          'id': key.toString(),
          'label': value,
          'games':dataIn[value]![key]!['games'],
          'win':dataIn[value]![key]!['win'],
        });
    }
    // is_radiant and patch are not sort via games number
    if (value != 'is_radiant' && value != 'patch') {
      playersCountsDestructData[value] = playersCountsDestructData[value]!.toList()..sort((a, b) => b['games'].compareTo(a['games']));
    }
    // patch only show latest patch
    if (value == 'patch') {
      playersCountsDestructData[value] = playersCountsDestructData[value]!.toList()..sort((a, b) => int.parse(b['id']).compareTo(int.parse(a['id'])));
    }

    // game_mode and lane_role won't count unknow data as chart
    if (value == 'game_mode' || value == 'lane_role' || value == 'region') {
      playersCountsDestructData[value] = playersCountsDestructData[value]!.where((item) => item['id'].toString() != '0').toList();
    }

    // finally we only need top 2
      playersCountsDestructData[value] = playersCountsDestructData[value]!.toList().sublist(0, 2);
    }
    return playersCountsDestructData;
  }