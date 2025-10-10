import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kiwi/kiwi.dart';

import '../../core/design/app_button.dart';
import '../../core/logic/helper_methods.dart';
import '../../generated/locale_keys.g.dart';

class LocationView extends StatefulWidget {
  final LatLng? initialLocation;
  final bool withButton;

  const LocationView({
    super.key,
    this.initialLocation,
    this.withButton = false,
  });

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  late GoogleMapController googleMapController;
  LatLng initialAddress = LatLng(31.963158, 35.930359);
  String? currentAddressText;
  Set<Marker> markers = {};
  final _controller = Completer<GoogleMapController>();

  double zoom = 10;

  Future<void> goToMyLocation({LatLng? location}) async {
    googleMapController = await _controller.future;
    if (location == null) {
      final pos = await getCurrentLocation();

      location = pos.latLang;
      if (location != null) {
        goTo(location);
        await addMarkers(location);
      }
    } else {
      goTo(location);
      await addMarkers(location);
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.initialLocation);
    if (widget.initialLocation != null) {
      goToMyLocation(location: widget.initialLocation);
    }
    Geolocator.getServiceStatusStream().listen((event) {
      print("******");
      print(event);
      if (event == ServiceStatus.enabled) {
        goToMyLocation(location: widget.initialLocation);
      }
    });

  }

  Future<void> goTo(LatLng location) async {
    zoom = 14;
    await googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(zoom: zoom, target: location),
      ),
    );
  }

  Future<void> addMarkers(LatLng location) async {
    print(zoom);
    if (zoom < 14) {
      await goTo(location);
      setState(() {});
    }
    markers.add(Marker(markerId: const MarkerId("1"), position: location));

    final placeMarks = await placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );
    currentAddressText =
        "${placeMarks.first.locality}${placeMarks.first.locality.toString().isNotEmpty ? " - " : ""}${placeMarks.first.subAdministrativeArea}";
    setState(() {});
  }

  List<MyAddressModel> locations = [];





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: GoogleMap(
        markers: markers,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onTap: widget.initialLocation != null ? (v) {} : addMarkers,
        onCameraMove: (position) {
          zoom = position.zoom;
        },
        initialCameraPosition: CameraPosition(
          target: initialAddress,
          zoom: zoom,
        ),
        onMapCreated: _controller.complete,
      ),
      floatingActionButton:
      widget.withButton
          ? SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: AppButton(
            onPress:
            markers.isEmpty
                ? null
                : () {
              Navigator.pop(
                context,
                MyAddressModel(
                  location: markers.first.position,
                  description: currentAddressText!,
                ),
              );
            },
            text: LocaleKeys.confirm.tr(),
          ),
        ),
      ):SizedBox.shrink(),
    );
  }
}


class MyAddressModel {
  final LatLng location;
  final String? description;

  MyAddressModel({required this.location, this.description});
}
