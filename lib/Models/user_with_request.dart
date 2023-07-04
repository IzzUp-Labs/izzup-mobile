import 'package:izzup/Models/job_offer_requests.dart';
import 'package:izzup/Models/tag.dart';
import 'package:izzup/Models/user.dart';

class UserWithRequests {
  int id;
  String address;
  List<Tag> tags;
  List<JobRequestWithVerificationCode> requests;
  User user;

  UserWithRequests(this.id, this.address, this.tags, this.requests, this.user);

  factory UserWithRequests.fromJson(Map<String, dynamic> json) {
    return UserWithRequests(
      json['id'],
      json['address'],
      json['tags'].map<Tag>((tag) => Tag.fromJson(tag)).toList(),
      json['requests'].map<JobRequestWithVerificationCode>((request) => JobRequestWithVerificationCode.fromJson(request)).toList(),
      User.fromJson(json['user']),
    );
  }
}