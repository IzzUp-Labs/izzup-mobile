import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:izzup/Models/company.dart';
import 'package:izzup/Services/string_to_bool.dart';

class Employer {
  String email;
  String password;
  String lastName;
  String firstName;
  DateTime dateOfBirth;
  Company company;
  LatLng location;

  Employer(this.email, this.password, this.lastName, this.firstName,
      this.dateOfBirth, this.location, this.company);

  static Employer basic = Employer(
      '', '', '', '', DateTime.now(), const LatLng(0.0, 0.0), Company.basic);

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(
        json['email'],
        json['password'],
        json['last_name'],
        json['first_name'],
        DateTime.parse(json['date_of_birth']),
        LatLng(json['location']['latitude'], json['location']['longitude']),
        Company.fromJson(json['company']));
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'last_name': lastName,
      'first_name': firstName,
      'date_of_birth': dateOfBirth.dateString,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude
      },
      'company': company.toJson()
    };
  }
}
