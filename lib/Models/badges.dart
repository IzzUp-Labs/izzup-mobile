class Badges {
  String id;
  String name;
  String image;
  double opacity;
  bool clicked;

  Badges(this.id, this.name, this.image, {this.opacity = 0.4, this.clicked = false});

  static Badges basic = Badges('', '', '');
}