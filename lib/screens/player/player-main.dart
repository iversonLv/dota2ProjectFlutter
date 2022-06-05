import 'package:flutter/material.dart';
import 'package:flutter_dota2_web/models/player_recent_match.dart';
import 'package:flutter_dota2_web/shared/components/hero-img-tap-info.dart';
import 'package:flutter_svg/flutter_svg.dart';

// shared
import 'package:flutter_dota2_web/shared/components/rank-tier-icon.dart';
import 'package:flutter_dota2_web/shared/components/tooltip-wrapper.dart';
import 'package:flutter_dota2_web/shared/services.dart';

// services
import '../../config.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          FutureBuilder(
            future: Future.wait([getPlayerData(), getPlayerWLData()]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  color: Theme.of(context).backgroundColor,
                  child: const Center(
                      child: Text('Loading...', style: TextStyle(color: Colors.white,)),
                  ),
                );
              } else {
                // player data
                final Player player = snapshot.data[0];
                final PlayerWL playerWl = snapshot.data[1];

                return Container(
                  padding: const EdgeInsets.fromLTRB(35, 25, 25, 25),
                  color: Theme.of(context).backgroundColor,
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
                          Text(
                            player.profile?.name != null ? player.profile?.name as String : player.profile?.personaname as String,
                            style: TextStyle(
                            fontSize: 28,
                            color: Theme.of(context).primaryColor,
                            ),
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
            future: Future.wait([getPlayerReacntMatchData(), getHeroesData()]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  color: Theme.of(context).backgroundColor,
                  child: const Center(
                      child: Text('Loading...', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),)),
                  ),
                );
              } else {
                // player matches data
                final List<PlayerRecentMatch> playerRecentMatches = snapshot.data[0];
                // heroes data
                final Map<String, dynamic> heroes = snapshot.data[1];
                return ListView.builder(
                  itemCount: playerRecentMatches.length,
                  itemBuilder: (BuildContext context, int index) {
                   final Map<String, dynamic> hero = heroes[playerRecentMatches[index].heroId.toString()];
                  //  final String heroImg = hero['img'];
                  //  final String heroName = hero['localized_name'];
                  //  final String heroPrimaryAttri = hero['primary_attr'];

                  //  final int heroHP = hero['base_health'] + hero['base_str'] * 20;
                  //  final int heroMP = hero['base_mana'] + hero['base_int'] * 12;

                  //  final String heroAttackType = hero['attack_type'];
                  //  final List<dynamic> heroRoles = hero['roles'];

                  //  final int heroBaseStr = hero['base_str'];
                  //  final double heroStrGain = hero['str_gain'];

                  //  final int heroBaseAgi = hero['base_agi'];
                  //  final double heroAgiGain = hero['agi_gain'];

                  //  final int heroBaseInt = hero['base_int'];
                  //  final double heroIntGain = hero['int_gain'];

                  //  final int heroMoveSpeed = hero['move_speed'];
                  //  final int heroBaseAttack = hero['base_attack_min'] + heroBaseAgi - hero['base_attack_max'] + heroBaseAgi;
                  //  final double heroBaseArmor = hero['base_armor'] + 0.167 * heroBaseAgi;
                  //  final int heroAttackRange = hero['attack_range'];

                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Stack(
                        children: [
                          HeroImgAndTapInfo(hero: hero)
                          
                        ],
                      )
                    );
                  }
                );
              }
            }
          ),
          )
          
        ],
      )
    );
  }
}
