class PlayerRecentMatch {
  int? matchId;
  int? playerSlot;
  bool? radiantWin;
  int? duration;
  int? gameMode;
  int? lobbyType;
  int? heroId;
  int? startTime;
  int? version;
  int? kills;
  int? deaths;
  int? assists;
  String? skill;
  int? xpPerMin;
  int? goldPerMin;
  int? heroDamage;
  int? towerDamage;
  int? heroHealing;
  int? lastHits;
  int? lane;
  int? laneRole;
  bool? isRoaming;
  int? cluster;
  int? leaverStatus;
  int? partySize;

  PlayerRecentMatch(
      {this.matchId,
      this.playerSlot,
      this.radiantWin,
      this.duration,
      this.gameMode,
      this.lobbyType,
      this.heroId,
      this.startTime,
      this.version,
      this.kills,
      this.deaths,
      this.assists,
      this.skill,
      this.xpPerMin,
      this.goldPerMin,
      this.heroDamage,
      this.towerDamage,
      this.heroHealing,
      this.lastHits,
      this.lane,
      this.laneRole,
      this.isRoaming,
      this.cluster,
      this.leaverStatus,
      this.partySize
    });

  PlayerRecentMatch.fromJson(Map<String, dynamic> json) {
    matchId = json['match_id'];
    playerSlot = json['player_slot'];
    radiantWin = json['radiant_win'];
    duration = json['duration'];
    gameMode = json['game_mode'];
    lobbyType = json['lobby_type'];
    heroId = json['hero_id'];
    startTime = json['start_time'];
    version = json['version'];
    kills = json['kills'];
    deaths = json['deaths'];
    assists = json['assists'];
    skill = json['skill'];
    xpPerMin = json['xp_per_min'];
    goldPerMin = json['gold_per_min'];
    heroDamage = json['hero_damage'];
    towerDamage = json['tower_damage'];
    heroHealing = json['hero_healing'];
    lastHits = json['last_hits'];
    lane = json['lane'];
    laneRole = json['lane_role'];
    isRoaming = json['is_roaming'];
    cluster = json['cluster'];
    leaverStatus = json['leaver_status'];
    partySize = json['party_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['match_id'] = matchId;
    data['player_slot'] = playerSlot;
    data['radiant_win'] = radiantWin;
    data['duration'] = duration;
    data['game_mode'] = gameMode;
    data['lobby_type'] = lobbyType;
    data['hero_id'] = heroId;
    data['start_time'] = startTime;
    data['version'] = version;
    data['kills'] = kills;
    data['deaths'] = deaths;
    data['assists'] = assists;
    data['skill'] = skill;
    data['xp_per_min'] = xpPerMin;
    data['gold_per_min'] = goldPerMin;
    data['hero_damage'] = heroDamage;
    data['tower_damage'] = towerDamage;
    data['hero_healing'] = heroHealing;
    data['last_hits'] = lastHits;
    data['lane'] = lane;
    data['lane_role'] = laneRole;
    data['is_roaming'] = isRoaming;
    data['cluster'] = cluster;
    data['leaver_status'] = leaverStatus;
    data['party_size'] = partySize;
    return data;
  }
}
