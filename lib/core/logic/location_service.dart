import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  Future<CustomPosition> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      //serviceEnabled = await Geolocator.isLocationServiceEnabled();
      // if (!serviceEnabled) {
      //   return CustomPosition(
      //       msg: "Location services are disabled.", success: false);
      // }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return CustomPosition(
              msg: "Location permissions are denied.", success: false);
        }
      }
      if (permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          return CustomPosition(
              msg:
                  "Location permissions are permanently denied, we cannot request permissions.",
              success: false);
        }
      }
      final position = await Geolocator.getCurrentPosition();
      debugPrint(position.toJson().toString());

      return CustomPosition(msg: "", success: true, position: position);
    } catch (e) {
      return CustomPosition(msg: e.toString(), success: false);
    }
  }

  Future<String?> getLocationName(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latLng.latitude, latLng.longitude,

          // localeIdentifier: "en"
      );
      debugPrint(placemarks.first.toJson().toString());
      if (placemarks[0].thoroughfare!.isNotEmpty &&
          placemarks[0].subLocality!.isNotEmpty) {
        return "${placemarks[0].thoroughfare ?? ""} ${placemarks[0].subLocality ?? ""}";
      } else {
        return "${placemarks[0].subAdministrativeArea ?? ""} ${placemarks[0].locality ?? ""}";
      }
    } catch (e) {
      debugPrint("+++$e");
      return null;
    }
  }
}

class CustomPosition {
  final Position? position;
  final String msg;
  final bool success;

  CustomPosition({this.position, required this.msg, required this.success});
}
