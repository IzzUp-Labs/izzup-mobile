import 'package:izzup/Models/company.dart';

class Employer {
  String email;
  String password;
  String lastName;
  String firstName;
  DateTime dateOfBirth;
  Company company;

  Employer(this.email, this.password, this.lastName, this.firstName,
      this.dateOfBirth, this.company);

  static Employer basic = Employer('', '', '', '', DateTime.now(), Company.basic);
}