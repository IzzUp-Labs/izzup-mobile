class Tag {
  String id;
  String name;
  String color;

  Tag({
    required this.id,
    required this.name,
    required this.color,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(id: json['id'], name: json['name'], color: json['color']);
  }

  toJson() {
    return {'id': id, 'name': name, 'color': color};
  }

  static Tag basic = Tag(id: '0', name: '', color: '');
}
