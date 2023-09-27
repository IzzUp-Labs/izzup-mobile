import 'package:izzup/Models/company.dart';

class MapLocation {
  final String id;
  final double longitude;
  final double latitude;
  final Company company;

  MapLocation(this.id, this.longitude, this.latitude, this.company);

  factory MapLocation.fromJson(Map<String, dynamic> json) {
    return MapLocation(json['id'], double.parse(json['longitude']),
        double.parse(json['latitude']), Company.fromJson(json['company']));
  }

  static MapLocation basic = MapLocation('0', 0, 0, Company.basic);

  isEquals(MapLocation mapLocation) {
    return id == mapLocation.id &&
        longitude == mapLocation.longitude &&
        latitude == mapLocation.latitude &&
        company.isEquals(mapLocation.company);
  }

  @override
  toString() {
    return 'MapLocation{id: $id, longitude: $longitude, latitude: $latitude, company: ${company.toString()}}';
  }
}
