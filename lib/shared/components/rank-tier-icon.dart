import 'package:flutter/material.dart';

// shared
import 'package:flutter_dota2_web/shared/components/tooltip-wrapper.dart';

// models
import '../../models/player.dart';

// shared
import '../utils.dart';

// constants
import '../app-color.dart';

class RankTierIcon extends StatelessWidget {
  const RankTierIcon({
    Key? key,
    required this.player,
  }) : super(key: key);

  final Player player;

  @override
  Widget build(BuildContext context) {
    const double size = 60;
    return TooltipWrapper(
        message: rankTierPipe(player.rankTier),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Rank stars number
            player.rankTier != null && player.rankTier.toString()[1] != '0' ? Image(
              height: size,
              width: size,
              image: NetworkImage(
                'https://www.opendota.com/assets/images/dota2/rank_icons/rank_star_${player.rankTier.toString()[1]}.png',
                scale: 1
              ),
            ) : const SizedBox(),
            // Rank icon
            Image(
              height: size,
              width: size,
              image: NetworkImage('https://www.opendota.com/assets/images/dota2/rank_icons/rank_icon_${player.rankTier != null ? player.rankTier.toString()[0] : "0"}${player.leaderboardRank != null && player.leaderboardRank! >= 1  &&  player.leaderboardRank! <= 10 ? "c" : (player.leaderboardRank != null &&  player.leaderboardRank!  <=100 && player.leaderboardRank! > 10 ? "b" : "")}.png'),
            ),
            // Rank number if not null
            Positioned(
              bottom: 5,
              child: Text(
                player.leaderboardRank != null ? player.leaderboardRank.toString() : '',
                style: 
                  const TextStyle(
                    fontSize: 20,
                    color: lightYellowColor
                  ),
                ),
            ),
          ],
        ),
      );
  }
}