import 'package:izzup/Models/company.dart';

class MapLocation {
  final int id;
  final double longitude;
  final double latitude;
  final Company company;

  MapLocation(this.id, this.longitude, this.latitude, this.company);

  factory MapLocation.fromJson(Map<String, dynamic> json) {
    return MapLocation(json['id'], double.parse(json['longitude']),
        double.parse(json['latitude']), Company.fromJson(json['company']));
  }

  static MapLocation basic = MapLocation(0, 0, 0, Company.basic);
}
