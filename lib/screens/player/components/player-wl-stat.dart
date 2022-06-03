import 'package:flutter/material.dart';

// models
import '../../../models/player_wl.dart';

class PlayerWLstat extends StatelessWidget {
  const PlayerWLstat({
    Key? key,
    required this.playerWl,
    required this.label,
    required this.stat,
    required this.statColor
  }) : super(key: key);

  final PlayerWL playerWl;
  final String label;
  final String stat;
  final Color statColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Text(label,
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromRGBO(255, 255, 255, .54),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(stat,  style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: statColor,
          ),
        )
      ],
    );
  }
}