import 'package:izzup/Models/user.dart';

class MessagingRoom {
  String id;
  User participant;
  User createdBy;
  DateTime creationDate;

  MessagingRoom(this.id, this.participant, this.createdBy, this.creationDate);

  factory MessagingRoom.fromJson(Map<String, dynamic> json) {
    return MessagingRoom(json['id'], User.fromJson(json['participant']),
        User.fromJson(json['createdBy']), DateTime.parse(json['creationDate']));
  }
}
