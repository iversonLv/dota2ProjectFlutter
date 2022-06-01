class PlayerWL {
  int? win;
  int? lose;

  PlayerWL({this.win, this.lose});

  PlayerWL.fromJson(Map<String, dynamic> json) {
    win = json['win'];
    lose = json['lose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['win'] = win;
    data['lose'] = lose;
    return data;
  }
}
