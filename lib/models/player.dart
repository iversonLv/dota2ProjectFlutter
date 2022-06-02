class Player {
  String? trackedUntil;
  Profile? profile;
  int? soloCompetitiveRank;
  int? leaderboardRank;
  int? rankTier;
  int? competitiveRank;
  MmrEstimate? mmrEstimate;

  Player(
      {this.trackedUntil,
      this.profile,
      this.soloCompetitiveRank,
      this.leaderboardRank,
      this.rankTier,
      this.competitiveRank,
      this.mmrEstimate});

  Player.fromJson(Map<String, dynamic> json) {
    trackedUntil = json['tracked_until'];
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    soloCompetitiveRank = json['solo_competitive_rank'];
    leaderboardRank = json['leaderboard_rank'];
    rankTier = json['rank_tier'];
    competitiveRank = json['competitive_rank'];
    mmrEstimate = json['mmr_estimate'] != null
        ? MmrEstimate.fromJson(json['mmr_estimate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['tracked_until'] = trackedUntil;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['solo_competitive_rank'] = soloCompetitiveRank;
    data['leaderboard_rank'] = leaderboardRank;
    data['rank_tier'] = rankTier;
    data['competitive_rank'] = competitiveRank;
    if (mmrEstimate != null) {
      data['mmr_estimate'] = mmrEstimate!.toJson();
    }
    return data;
  }
}

class Profile {
  int? accountId;
  String? personaname;
  String? name;
  bool? plus;
  int? cheese;
  String? steamid;
  String? avatar;
  String? avatarmedium;
  String? avatarfull;
  String? profileurl;
  String? lastLogin;
  String? loccountrycode;
  bool? isContributor;

  Profile(
      {this.accountId,
      this.personaname,
      this.name,
      this.plus,
      this.cheese,
      this.steamid,
      this.avatar,
      this.avatarmedium,
      this.avatarfull,
      this.profileurl,
      this.lastLogin,
      this.loccountrycode,
      this.isContributor});

  Profile.fromJson(Map<String, dynamic> json) {
    accountId = json['account_id'];
    personaname = json['personaname'];
    name = json['name'];
    plus = json['plus'];
    cheese = json['cheese'];
    steamid = json['steamid'];
    avatar = json['avatar'];
    avatarmedium = json['avatarmedium'];
    avatarfull = json['avatarfull'];
    profileurl = json['profileurl'];
    lastLogin = json['last_login'];
    loccountrycode = json['loccountrycode'];
    isContributor = json['is_contributor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['account_id'] = accountId;
    data['personaname'] = personaname;
    data['name'] = name;
    data['plus'] = plus;
    data['cheese'] = cheese;
    data['steamid'] = steamid;
    data['avatar'] = avatar;
    data['avatarmedium'] = avatarmedium;
    data['avatarfull'] = avatarfull;
    data['profileurl'] = profileurl;
    data['last_login'] = lastLogin;
    data['loccountrycode'] = loccountrycode;
    data['is_contributor'] = isContributor;
    return data;
  }
}

class MmrEstimate {
  int? estimate;

  MmrEstimate({this.estimate});

  MmrEstimate.fromJson(Map<String, dynamic> json) {
    estimate = json['estimate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['estimate'] = estimate;
    return data;
  }
}
