class Rating {
  String? id;
  int? stars;
  String? targetId;
  String? comment;
  List<String>? badges;

  Rating(this.id, this.stars, this.targetId, this.comment, this.badges);

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      json['id'],
      json['stars'],
      json['target_id'],
      json['comment'],
      json['badges'] != null ? List<String>.from(json['badges']) : null,
    );
  }

  static Rating basic = Rating('', 0, '', '', []);

  Map<String, dynamic> toJson() {
    return {
      'stars': stars,
      'target_id': targetId,
      'comment': comment,
      'badges': badges,
    };
  }
}