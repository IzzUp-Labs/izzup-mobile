import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  String name;
  String address;
  String placeId;
  LatLng location;
  double rating;

  Place(this.name, this.address, this.placeId, this.location, this.rating);

  static Place basic = Place('', '', '', const LatLng(0.0, 0.0), 3.0);

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        json['name'],
        json['formatted_address'],
        json['place_id'],
        LatLng(json['geometry']['location']['lat'],
            json['geometry']['location']['lng']),
        double.parse(json['rating'].toString()));
  }
}
