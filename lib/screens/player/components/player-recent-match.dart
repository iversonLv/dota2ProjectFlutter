import 'package:flutter/material.dart';

import '../../../shared/app-color.dart';
import '../../../shared/components/hero-img-tap-info.dart';
import '../../../shared/utils.dart';

class PlayerRecentMatchContainer extends StatelessWidget {
  const PlayerRecentMatchContainer({
    Key? key,
    required this.matchDuration,
    required this.side,
    required this.gameMode,
    required this.startTime,
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.playerSlot,
    required this.radiantWin,
    required this.hero,
  }) : super(key: key);
  final int matchDuration;
  final String side;
  final String gameMode;
  final int startTime;
  final int kills;
  final int deaths;
  final int assists;
  final int playerSlot;
  final bool radiantWin;
  final Map<String, dynamic> hero;

  @override
  Widget build(BuildContext context) {
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
                        color: win(playerSlot, radiantWin) ? greenColor : redColor,
                      ),
                      width: 20,
                      alignment: Alignment.center,
                      child: Text(
                        win(playerSlot, radiantWin) ? 'W' : 'L',
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