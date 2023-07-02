import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:izzup/Services/prefs.dart';
import 'package:location/location.dart';

class LocationService {
  static final Location _location = Location();

  static Future<bool> _isServiceEnabled() async {
    return (await _location.serviceEnabled()) ||
        (await _location.requestService());
  }

  static Future<PermissionStatus> isPermissionGranted() async {
    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.deniedForever) {
      return await _location.requestPermission();
    }
    return permission;
  }

  static Future<LocationData?> getLocation() async {
    bool isServiceEnabled = await _isServiceEnabled();
    PermissionStatus isGranted = await isPermissionGranted();
    if (isServiceEnabled && isGranted != PermissionStatus.denied) {
      Prefs.setBool('locationServiceEnabled', true);
      return await _location.getLocation();
    }
    return null;
  }
}

extension LocationLatLngExtension on LocationData {
  LatLng get latLng => _toLatLng();

  _toLatLng() {
    return LatLng(latitude!, longitude!);
  }
}
