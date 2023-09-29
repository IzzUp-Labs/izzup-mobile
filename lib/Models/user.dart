import 'package:flutter/foundation.dart';

enum UserRole {
  extra,
  employer;

  String get value {
    switch (this) {
      case UserRole.extra:
        return 'EXTRA';
      case UserRole.employer:
        return 'EMPLOYER';
      default:
        return 'EXTRA';
    }
  }

  static UserRole fromString(String value) {
    switch (value) {
      case 'EXTRA':
        return UserRole.extra;
      case 'EMPLOYER':
        return UserRole.employer;
      default:
        return UserRole.extra;
    }
  }
}

enum UserVerificationStatus {
  verified,
  unverified,
  needsId,
  notValid;

  static fromString(String value) {
    switch (value) {
      case 'VERIFIED':
        return UserVerificationStatus.verified;
      case 'UNVERIFIED':
        return UserVerificationStatus.unverified;
      case 'NEED_ID':
        return UserVerificationStatus.needsId;
      case 'NOT_VALID':
        return UserVerificationStatus.notValid;
      default:
        return UserVerificationStatus.needsId;
    }
  }
}

class User {
  String id;
  String email;
  String password;
  String lastName;
  String firstName;
  DateTime dateOfBirth;
  String? photo;
  UserRole role;
  String? idPhoto;
  List<UserVerificationStatus> statuses;

  User(this.id, this.email, this.password, this.lastName, this.firstName,
      this.dateOfBirth, this.photo, this.role, this.idPhoto, this.statuses);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        json['id'],
        json['email'],
        json['password'],
        json['last_name'],
        json['first_name'],
        DateTime.parse(json['date_of_birth']),
        json['photo'],
        UserRole.fromString(json['role']),
        json['id_photo'],
        User.statusesFromJson(json['statuses'])
    );
  }

  static List<UserVerificationStatus> statusesFromJson(List<dynamic> statuses) {
    List<UserVerificationStatus> result = [];
    for (var status in statuses) {
      result.add(UserVerificationStatus.fromString(status['name']));
    }
    return result;
  }

  UserVerificationStatus get status {
    if (_isIdentityVerified()) {
      return UserVerificationStatus.verified;
    }
    if (_isIdentityUnverified()) {
      return UserVerificationStatus.unverified;
    }
    if (_isIdNeeded()) {
      return UserVerificationStatus.needsId;
    }
    if (_isIdentityNotValid()) {
      return UserVerificationStatus.notValid;
    }
    return UserVerificationStatus.needsId;
  }

  bool _isIdNeeded() => statuses.contains(UserVerificationStatus.needsId);
  bool _isIdentityUnverified() => statuses[0] == UserVerificationStatus.unverified && statuses.length == 1;
  bool _isIdentityVerified() => statuses[0] == UserVerificationStatus.verified && statuses.length == 1;
  bool _isIdentityNotValid() => statuses.contains(UserVerificationStatus.notValid);

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "last_name": lastName,
        "first_name": firstName,
        "date_of_birth": dateOfBirth.toIso8601String(),
        "photo": photo,
        "role": role.value,
        "id_photo": idPhoto
      };

  static User basic = User('0', '', '', '', '', DateTime.now(), '',
      UserRole.extra, '', [UserVerificationStatus.unverified]);
}
