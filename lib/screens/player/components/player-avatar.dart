import 'package:flutter/material.dart';
// models
import '../../../models/player.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    Key? key,
    required this.player,
  }) : super(key: key);

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(blurRadius: 15, color: Color.fromRGBO(0, 0, 0, .4), spreadRadius: 2)],
      ),
      child: CircleAvatar(
        radius: 100,
        backgroundImage: NetworkImage(player.profile?.avatarfull as String),
      ),
    );
  }
}