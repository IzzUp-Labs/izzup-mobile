class Badges {
  String id;
  String nameFr;
  String nameEn;
  String image;
  bool is_extra;
  int? ratingCount;
  double opacity;
  bool clicked;

  Badges(this.id, this.nameFr, this.nameEn, this.image, this.is_extra, this.ratingCount, {this.opacity = 0.4, this.clicked = false});

  factory Badges.fromJson(Map<String, dynamic> json) {
    return Badges(
      json['id'],
      json['name_fr'],
      json['name_en'],
      json['image'],
      json['is_extra'],
      json['rating_count'],
    );
  }

  static Badges basic = Badges('', '', '', '', false, 0);
}