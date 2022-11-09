import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  late LocationData locData;

  Future<void> start() async {
    bool locationAvailable;
    PermissionStatus permissions;

    locationAvailable = await location.serviceEnabled();
    if (!locationAvailable) {
      locationAvailable = await location.requestService();
      if (!locationAvailable) {
        return;
      }
    }

    permissions = await location.hasPermission();
    if (permissions == PermissionStatus.denied) {
      permissions = await location.requestPermission();
      if (permissions != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<double?> latitude() async {
    locData = await location.getLocation();
    return locData.latitude;
  }

  Future<double?> longitude() async {
    locData = await location.getLocation();
    return locData.longitude;
  }
}
