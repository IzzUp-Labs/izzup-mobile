import 'badges.dart';

class UserStats {
  int? oneStars;
  int? twoStars;
  int? threeStars;
  int? four_stars;
  int? five_stars;
  double? average;
  int? total;
  List<Badges> badges;

  UserStats(this.oneStars, this.twoStars, this.threeStars, this.four_stars, this.five_stars, this.average, this.total, this.badges);

factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      json['one_stars'],
      json['two_stars'],
      json['three_stars'],
      json['four_stars'],
      json['five_stars'],
      json['average'] != null ? json['average'].toDouble() : 0.0,
      json['total'],
      json['badges'] != null ? List<Badges>.from(json['badges'].map((badge) => Badges.fromJson(badge))) : [],
    );
  }

  static UserStats basic = UserStats(0, 0, 0, 0, 0, 0.0, 0, []);
}