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

class User {
  int id;
  String email;
  String password;
  String lastName;
  String firstName;
  DateTime dateOfBirth;
  String? photo;
  UserRole role;
  String? idPhoto;

  User(this.id, this.email, this.password, this.lastName, this.firstName,
      this.dateOfBirth, this.photo, this.role, this.idPhoto);

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
        json['id_photo']);
  }

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

  static User basic =
      User(0, '', '', '', '', DateTime.now(), '', UserRole.extra, '');
}
