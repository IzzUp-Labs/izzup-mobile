import 'package:izzup/Models/user.dart';

class Message {
  final int id;
  final User author;
  final String content;
  final DateTime creationDate;

  Message(this.id, this.author, this.content, this.creationDate);

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(json['id'], User.fromJson(json['author']), json['content'],
        DateTime.parse(json['creationDate']));
  }
}
