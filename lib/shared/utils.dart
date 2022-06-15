
import 'package:intl/intl.dart';
import 'package:flutter_dota2_web/config.dart';
import 'package:flutter/material.dart';

// rankTierPipe tooltip above player rank icon
String rankTierPipe(int? rankTier) {

  final List<String> rankTierMapping = ['Herald', 'Guardian', 'Crusader', 'Archon', 'Legend', 'Ancient', 'Divine' , 'Immortal'];

  if (rankTier != null) {
      final int tier = int.parse(rankTier.toString()[0]) - 1;
      final int star = int.parse(rankTier.toString()[1]);
      if (tier == 7) {
        // If rank tier is Immortal won't have star num
        return rankTierMapping[tier];
      } else {
        if (star == 0) {
          return rankTierMapping[tier];
        } else {
          return '${rankTierMapping[tier]} [ $star ]';
        }
      }
    } else {
      return 'Unknown';
    }
}

// win lost result
bool win(int? playerSlot, bool? radiantWin) {
  return (playerSlot! > 120 && !radiantWin!) || (playerSlot <= 120 && radiantWin!) ? true : false;
}

// duration pipe
String duration(int duration) {
  var minus = false;
  duration < 0 ? minus = true : minus = false;
  final String getMin = ((duration.floor() / 60).abs()).toString().split('.')[0];
  final int duartionPS = duration.floor().abs() % 60;
  var getSec = duartionPS == 0 ? '00'
  : duartionPS > 0 && duartionPS < 10 ? '0${duartionPS.toString()}' // if sec is < 10, then need add '0' before it
  : duartionPS;
  
  return minus ? '-$getMin:$getSec' : '$getMin:$getSec';
}

String nameDestruct(String? value, String separator, int separatorPlacement, String upperCase) {
  // example lobby_type name is lobby_type_normal, we need destruct only last string and uppercase
  if (value != null && value.split(separator).length > 1) {
   if (upperCase == 'upperCase') {
        return value.split(separator).sublist(separatorPlacement).map((String i) => i[0].toUpperCase() + i.substring(1).toLowerCase()).join(' ');
      } else {
        return value.split(separator).sublist(separatorPlacement).join(' ');
      }
    } else {
      return value.toString();
    }
}

// 
String? dateTillToday(int date) {
  final int todayParse = DateTime.now().millisecondsSinceEpoch;

  final lastPlayedTillToday = todayParse - date;

  final tillYears = lastPlayedTillToday / 1000 / 60  / 60 / 24 / 30 / 12;
  final tillMonths = lastPlayedTillToday / 1000 / 60  / 60 / 24 / 30;
  final tillDays = lastPlayedTillToday / 1000 / 60  / 60 / 24;
  final tillHours = lastPlayedTillToday / 1000 / 60  / 60;
  final tillMinutes = lastPlayedTillToday / 1000 / 60;

  if (date == 0 ) {
    return null;
  }
  if (tillYears >= 1 ) {
    if (tillYears.floor() > 1) {
      return '${tillYears.floor()} years ago';
    } else {
      return 'a year ago';
    }
  } else if (tillMonths >= 1 ){
    if (tillMonths.floor() > 1) {
      return '${tillMonths.floor()} months ago';
    } else {
      return 'a month ago';
    }
  } else if (tillDays >= 1) {
    if (tillDays.floor() > 1) {
      return '${tillDays.floor()} days ago';
    } else {
      return 'a day ago';
    }
  } else if (tillHours >= 1) {
    if (tillHours.floor() > 1) {
      return '${tillHours.floor()} hours ago';
    } else {
      return 'an hour ago';
    }
  } else if (tillMinutes  >= 1) {
    if (tillMinutes.floor() > 1) {
      return '${tillMinutes.floor()} minutes ago';
    } else {
      return 'a minute ago';
    }
  }
  return null;
}

String milisecondsToDate(int miliseconds) {
  final f = DateFormat(mediumDate);
  final String gameStartTime = f.format(DateTime.fromMillisecondsSinceEpoch(miliseconds));
  return gameStartTime;
}

String greaterNum(int num, int gN, String unit)  {
		var minus = '';
    if (num < 0) {
      minus = '-';
    }
    num = (num).abs();
    if (num > gN) {
      final newNum = (num / gN).toStringAsFixed(1);
      return '$minus$newNum$unit';
    } else {
      return '$minus$num';
    }
}

// show data from green to red base on the win and lose
Color calColor(int? win, int? games) {
    final red = (255 - 255 * win! / games!).round();
    final green = (255 * win / games).round();
    final finalColor = Color.fromRGBO(red, green, 0, 1);
    return finalColor;
  }
