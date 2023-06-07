import 'package:location/location.dart';

class LocationService {
  static final Location _location = Location();

  static Future<bool> _isServiceEnabled() async {
    return (await _location.serviceEnabled()) ||
        (await _location.requestService());
  }

  static Future<PermissionStatus> _isPermissionGranted() async {
    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.deniedForever) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return PermissionStatus.denied;
      }
    }
    return permission;
  }

  static Future<LocationData?> getLocation() async {
    bool isServiceEnabled = await _isServiceEnabled();
    PermissionStatus isPermissionGranted = await _isPermissionGranted();

    if (isServiceEnabled && isPermissionGranted != PermissionStatus.denied) {
      return await _location.getLocation();
    }
    return null;
  }
}
