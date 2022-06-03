// rankTierPipe tooltip above player rank icon
String rankTierPipe(rankTier) {

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