import 'package:flutter/material.dart';
import 'package:flutter_dota2_web/config.dart';
import 'package:flutter_dota2_web/shared/app-color.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeroImgAndTapInfo extends StatelessWidget {
  const HeroImgAndTapInfo({
    Key? key,
    required this.hero,
  }) : super(key: key);

  final Map<String, dynamic> hero;

  @override
  Widget build(BuildContext context) {
    final String heroImg = hero['img'];
    final String heroName = hero['localized_name'];
    final String heroPrimaryAttri = hero['primary_attr'];

    final int heroHP = hero['base_health'] + hero['base_str'] * 20;
    final int heroMP = hero['base_mana'] + hero['base_int'] * 12;

    final String heroAttackType = hero['attack_type'];
    final List<dynamic> heroRoles = hero['roles'];

    final int heroBaseStr = hero['base_str'];
    final double heroStrGain = hero['str_gain'];

    final int heroBaseAgi = hero['base_agi'];
    final double heroAgiGain = hero['agi_gain'];

    final int heroBaseInt = hero['base_int'];
    final double heroIntGain = hero['int_gain'];

    final int heroMoveSpeed = hero['move_speed'];
    final String heroBaseAttack = '${hero['base_attack_min'] + heroBaseAgi} - ${hero['base_attack_max'] + heroBaseAgi}';
    final double heroBaseArmor = hero['base_armor'] + 0.167 * heroBaseAgi;
    final int heroAttackRange = hero['attack_range'];
    return GestureDetector(
      onTap: () {
        // hero info
        showModalBottomSheet<void>(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 440,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              // padding: const EdgeInsets.all(20),
              child: Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.topCenter,
                    children: <Widget>[
                      // hero img
                      Positioned(
                        top: -70,
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(blurRadius: 15, color: Color.fromRGBO(0, 0, 0, .4), spreadRadius: 2)],
                              ),
                              child: CircleAvatar(
                                radius: 100,
                                backgroundImage: NetworkImage(steamCDN + heroImg),
                              ),
                            ),
                            Positioned(
                              top: -20,
                              child: Container(
                                width: 30,
                                height: 30,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).scaffoldBackgroundColor
                                  
                                ),
                                child: SvgPicture.asset('assets/images/hero-attr-$heroPrimaryAttri.svg'),
                              ),
                            ),
                            Positioned(
                              top: -80,
                              child: IconButton(
                                iconSize: 48,
                                onPressed: () => Navigator.pop(context), 
                                icon: const Icon(Icons.keyboard_double_arrow_down_rounded, size:48, color: Colors.white,)
                              ),
                            ),
                          ],
                        ),
                      ),
                      // hero name
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              heroName,
                              style: TextStyle(
                                fontSize: 28,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10,),
                            // hp mp
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'HP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: heroHPColor,
                                  ),
                                ),
                                Text(
                                  heroHP.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: heroHPColor,
                                  ),
                                ),
                                const Text(
                                  ' / MP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: heroMPColor,
                                  ),
                                ),
                                Text(
                                  heroMP.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: heroMPColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            // hero attach type and roles
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                Text(
                                  '$heroAttackType - ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                for(var role in heroRoles ) Text('$role, ', style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            // hero attri and attri gain
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HeroBaseAttrAndGain(heroAttri: 'str', heroBase: heroBaseStr, heroGain: heroStrGain, heroPrimaryAttri: heroPrimaryAttri),
                                const SizedBox(width: 15,),
                                HeroBaseAttrAndGain(heroAttri: 'agi', heroBase: heroBaseAgi, heroGain: heroAgiGain, heroPrimaryAttri: heroPrimaryAttri),
                                const SizedBox(width: 15,),
                                HeroBaseAttrAndGain(heroAttri: 'int', heroBase: heroBaseInt, heroGain: heroIntGain, heroPrimaryAttri: heroPrimaryAttri),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            const Divider(color: Colors.white,),
                            const SizedBox(height: 10,),
                            // hero info
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                HeroBaseInfo(heroBaseInfoLabel: 'Move speed', heroBaseInfo: heroMoveSpeed.toString()),
                                const SizedBox(height: 10,),
                                HeroBaseInfo(heroBaseInfoLabel: 'Base attack', heroBaseInfo: heroBaseAttack.toString()),
                                const SizedBox(height: 10,),
                                HeroBaseInfo(heroBaseInfoLabel: 'Base armor', heroBaseInfo: heroBaseArmor.toStringAsFixed(1)),
                                const SizedBox(height: 10,),
                                HeroBaseInfo(heroBaseInfoLabel: 'Attack range', heroBaseInfo: heroAttackRange.toString()),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
              );
          },
        );
      },
      // hero img
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(blurRadius: 15, color: Color.fromRGBO(0, 0, 0, .4), spreadRadius: 2)],
        ),
        child: CircleAvatar(
          radius: 100,
          backgroundImage: NetworkImage(steamCDN + heroImg),
        ),
      ),
    );
  }
}

// heroBaseInfo
class HeroBaseInfo extends StatelessWidget {
  const HeroBaseInfo({
    Key? key,
    required this.heroBaseInfoLabel,
    required this.heroBaseInfo,
  }) : super(key: key);

  final String heroBaseInfo;
  final String heroBaseInfoLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$heroBaseInfoLabel:', style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).primaryColor,)
        ),
        Text(heroBaseInfo, style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).primaryColor,)
        )
      ],
    );
  }
}

// here base attr and gain
class HeroBaseAttrAndGain extends StatelessWidget {
  const HeroBaseAttrAndGain({
    Key? key,
    required this.heroAttri,
    required this.heroBase,
    required this.heroGain,
    required this.heroPrimaryAttri
  }) : super(key: key);

  final String heroAttri;
  final int heroBase;
  final double heroGain;
  final String heroPrimaryAttri;

  Color setHeroPrimaryAttr(String heroAttri, String heroPrimaryAttri) {
    if (heroPrimaryAttri == heroAttri) {
      return Colors.white;
    } else {
      return Colors.white30;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).scaffoldBackgroundColor,
            // if it's primary attri the attr icon will be white border to highlight
            border: Border.all(width: 3, color: setHeroPrimaryAttr(heroAttri, heroPrimaryAttri))
          ),
          child: SvgPicture.asset('assets/images/hero-attr-$heroAttri.svg'),
        ),
        const SizedBox(height: 10,),
        Text(
          '$heroBase + $heroGain', style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).primaryColor,
          )
        )
      ],
    );
  }
}
