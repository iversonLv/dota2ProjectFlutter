import 'package:flutter/material.dart';

// models
import '../../models/player.dart';

// shared
import '../utils.dart';

// constants
import '../constants.dart';

class RankTierIcon extends StatelessWidget {
  const RankTierIcon({
    Key? key,
    required this.player,
  }) : super(key: key);

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
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
      );
  }
}